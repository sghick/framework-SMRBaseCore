//
//  SMRSession.m
//  SMRBaseCoreDemo
//
//  Created by 丁治文 on 2019/1/21.
//  Copyright © 2019 sumrise. All rights reserved.
//

#import "SMRSession.h"
#import "AFNetworkActivityIndicatorManager.h"
#import "SMRNetConfig.h"
#import "SMRNetAPI.h"
#import "NSError+SMRNetwork.h"
#import "SMRNetCache.h"
#import "SMRNetInfo.h"
#import "SMRNetDedouncer.h"

@interface SMRSession ()

@property (strong, nonatomic) NSLock *lock;

@end

@implementation SMRSession
@synthesize netCache = _netCache;
@synthesize config = _config;
@synthesize dedouncer = _dedouncer;

- (void)configration:(SMRNetConfig *)config {
    _config = config;
    
    if ([self.config enableNetworkReachability]) {
        [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            SMRNetworkReachabilityStatus st = (SMRNetworkReachabilityStatus)status;
            [self.config didChangedNetworkWithWithStatus:st];
        }];
        [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    }
    self.requestSerializer = [AFJSONRequestSerializer serializer];
    self.requestSerializer.HTTPMethodsEncodingParametersInURI = [self.config HTTPMethodsEncodingParametersInURI];
    self.responseSerializer = [AFJSONResponseSerializer serializer];
    self.responseSerializer.acceptableContentTypes = [config setForAcceptableContentTypes];
    self.responseSerializer.acceptableStatusCodes = [config setForAcceptableStatusCodes];
    // 允许非正式颁发机构证书
    self.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    // 开启'菊花'监测网络
    [AFNetworkActivityIndicatorManager sharedManager].enabled = [self.config enableForStatuBarIndicator];
    
    [config configPrepare];
}

#pragma mark - SMRSessionDelegate

- (NSURLSessionDataTask *)smr_dataTaskWithAPI:(SMRNetAPI *)api {
    SMRAPICallback *callback = api.callback;
    // 设置标志位,如果服务器获取到结果后,此标志将变为YES,UI层可以根据此标志控制是否相并新页面
    __block BOOL didServiceResponse = NO;
    // cache
    if (callback.cacheBlock) {
        id object = [self.netCache objectWithPolicy:api.cachePolicy];
        if (!didServiceResponse) {
            callback.cacheBlock(api, object);
        }
    }
    // 创建task
    NSURLSessionDataTask *task = [self smr_dataTaskWithAPI:api constructingBodyWithBlock:^(id<AFMultipartFormData> _Nonnull formData) {
        if (callback.constructingBlock) {
            callback.constructingBlock(api, formData);
        }
    } uploadProgress:^(NSProgress *uploadProgress) {
        if (callback.uploadProgress) {
            callback.uploadProgress(api, uploadProgress);
        }
    } downloadProgress:^(NSProgress *downloadProgress) {
        if (callback.downloadProgress) {
            callback.downloadProgress(api, downloadProgress);
        }
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        // 设置请求结束的标志
        didServiceResponse = YES;
        // 同步时间和Cookie
        [SMRNetInfo syncNetInfoWithResponse:(NSHTTPURLResponse *)task.response];
        // 保存网络请求成功的结果
        [api fillResponse:responseObject error:nil];
        // 请求成功之后加入缓存
        if (api.cachePolicy) {
            [self.netCache addObject:responseObject policy:api.cachePolicy];
        }
        // 请求成功的回调
        if (callback.successBlock) {
            callback.successBlock(api, responseObject);
        }
        // 处理防抖结果
        NSArray<SMRNetAPI *> *dedouncedAPIs = [self.dedouncer objectForDedouncedWithIdentifier:api.identifier
                                                                                      groupTag:api.callback.groupTagForDedounce];
        for (SMRNetAPI *api in dedouncedAPIs) {
            // 保存网络请求成功的结果
            [api fillResponse:responseObject error:nil];
            // 请求成功的回调
            if (callback.successBlock) {
                callback.successBlock(api, responseObject);
            }
        }
        [self.dedouncer removeObjectForDedouncedWithIdentifier:api.identifier
                                                      groupTag:api.callback.groupTagForDedounce];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        id response = [self.config responseObjectWithError:error];
        if (self.config.debugLog) {
            NSLog(@"API请求错误:%@,\n\tresponse=%@,\n%@", api, response, error);
        }
        // 设置请求结束的标志
        didServiceResponse = YES;
        // 同步时间和Cookie
        [SMRNetInfo syncNetInfoWithResponse:(NSHTTPURLResponse *)task.response];
        // 保存网络请求失败的结果
        [api fillResponse:response error:error];
        // 重试
        BOOL willRetry = NO;
        if ([self.retryDelegate respondsToSelector:@selector(willRetryWithError:api:)]) {
            willRetry = [self.retryDelegate willRetryWithError:error api:api];
        }
        // 初始化API
        BOOL willQueryInitAPI = NO;
        if ([self.initDelegate respondsToSelector:@selector(willQueryInitAPIWithError:api:)]) {
            willQueryInitAPI = [self.initDelegate willQueryInitAPIWithError:error api:api];
        }
        // 如果不需要重试,并且不需要初始化API,则进行回调,否则将在内部处理
        BOOL shouldCallback = (!willRetry && !willQueryInitAPI);
        if (shouldCallback && callback.faildBlock) {
            callback.faildBlock(api, response, error);
            
            // 处理防抖结果
            NSArray<SMRNetAPI *> *dedouncedAPIs = [self.dedouncer objectForDedouncedWithIdentifier:api.identifier
                                                                                          groupTag:api.callback.groupTagForDedounce];
            for (SMRNetAPI *api in dedouncedAPIs) {
                // 保存网络请求失败的结果
                [api fillResponse:response error:error];
                // 请求成功的回调
                if (callback.successBlock) {
                    callback.faildBlock(api, response, error);
                }
            }
            [self.dedouncer removeObjectForDedouncedWithIdentifier:api.identifier
                                                          groupTag:api.callback.groupTagForDedounce];
        }
    }];
    // 保存task
    [api fillDataTask:task];
    return task;
}

- (NSURLSessionDataTask *)smr_dataTaskWithAPI:(SMRNetAPI *)api
                    constructingBodyWithBlock:(nullable void (^)(id<AFMultipartFormData>))block
                               uploadProgress:(nullable void (^)(NSProgress *))uploadProgress
                             downloadProgress:(nullable void (^)(NSProgress *))downloadProgress
                                      success:(void (^)(NSURLSessionDataTask *, id))success
                                      failure:(void (^)(NSURLSessionDataTask *, NSError *))failure{
    if (![api isKindOfClass:[SMRMultipartNetAPI class]]) {
        return [self smr_dataTaskWithAPI:api uploadProgress:uploadProgress downloadProgress:downloadProgress success:success failure:failure];
    } else {
        return [self smr_dataTaskForMultipartWithAPI:api constructingBodyWithBlock:block uploadProgress:uploadProgress success:success failure:failure];
    }
}

/**
 GET    ->downloadProgress
 POST   ->uploadProgress
 POST   ->uploadProgress+block
 GET,POST,HEAD,PUT,PATCH,DELETE ->success+failure
 */
- (NSURLSessionDataTask *)smr_dataTaskWithAPI:(SMRNetAPI *)api
                               uploadProgress:(nullable void (^)(NSProgress *))uploadProgress
                             downloadProgress:(nullable void (^)(NSProgress *))downloadProgress
                                      success:(void (^)(NSURLSessionDataTask *, id))success
                                      failure:(void (^)(NSURLSessionDataTask *, NSError *))failure {
    
    AFHTTPSessionManager *manager = self;
    // 设置超时时间
    manager.requestSerializer.timeoutInterval = api.timeoutInterval;
    // 创建request对象
    NSError *serializationError = nil;
    NSString *apiURLStr = [NSString stringWithFormat:@"%@%@", api.host?:@"", api.url?:@""];
    NSMutableURLRequest *request = [manager.requestSerializer requestWithMethod:api.method
                                                                      URLString:[[NSURL URLWithString:apiURLStr relativeToURL:manager.baseURL] absoluteString]
                                                                     parameters:api.params
                                                                          error:&serializationError];
    if (serializationError) {
        if (failure) {
            dispatch_async(manager.completionQueue ?: dispatch_get_main_queue(), ^{
                NSError *error = [NSError smr_errorForNetworkDomainWithCode:serializationError.code detail:nil message:nil userInfo:serializationError.userInfo];
                failure(nil, error);
            });
        }
        
        return nil;
    }
    // 设置Header的时机
    [self configRequestGeneralHeadersBeforeDataTask:request api:api];
    [self.config configRequestBeforeDataTask:request api:api];
    // 设置ETag
    [self configETagBeforeDataTaskIfRequestMethodGET:request api:api];
    // 创建dataTask
    __block NSURLSessionDataTask *dataTask = nil;
    dataTask = [manager dataTaskWithRequest:request uploadProgress:uploadProgress downloadProgress:downloadProgress completionHandler:^(NSURLResponse * __unused response, id responseObject, NSError *error) {
        [self completionHandlerWithDataTask:dataTask response:response responseObject:responseObject error:error api:api success:success failure:failure];
    }];
    return dataTask;
}

/**
 POST   ->uploadProgress+block
 */
- (NSURLSessionDataTask *)smr_dataTaskForMultipartWithAPI:(SMRNetAPI *)api
                                constructingBodyWithBlock:(void (^)(id<AFMultipartFormData>))block
                                           uploadProgress:(void (^)(NSProgress *))uploadProgress
                                                  success:(void (^)(NSURLSessionDataTask *, id))success
                                                  failure:(void (^)(NSURLSessionDataTask *, NSError *))failure {
    AFHTTPSessionManager *manager = self;
    // 设置超时时间
    manager.requestSerializer.timeoutInterval = api.timeoutInterval;
    // 创建request对象
    NSError *serializationError = nil;
    NSString *apiURLStr = [NSString stringWithFormat:@"%@%@", api.host?:@"", api.url?:@""];
    NSMutableURLRequest *request = [self.requestSerializer multipartFormRequestWithMethod:api.method URLString:[[NSURL URLWithString:apiURLStr relativeToURL:manager.baseURL] absoluteString] parameters:api.params constructingBodyWithBlock:block error:&serializationError];
    if (serializationError) {
        if (failure) {
            dispatch_async(self.completionQueue ?: dispatch_get_main_queue(), ^{
                NSError *error = [NSError smr_errorForNetworkDomainWithCode:serializationError.code detail:nil message:nil userInfo:serializationError.userInfo];
                failure(nil, error);
            });
        }
        
        return nil;
    }
    // 设置Header的时机
    [self configRequestGeneralHeadersBeforeDataTask:request api:api];
    [self.config configRequestBeforeDataTask:request api:api];
    // 设置ETag
    [self configETagBeforeDataTaskIfRequestMethodGET:request api:api];
    // 创建dataTask
    __block NSURLSessionDataTask *dataTask = [self uploadTaskWithStreamedRequest:request progress:uploadProgress completionHandler:^(NSURLResponse * __unused response, id responseObject, NSError *error) {
        [self completionHandlerWithDataTask:dataTask response:response responseObject:responseObject error:error api:api success:success failure:failure];
    }];
    return dataTask;
}

- (void)completionHandlerWithDataTask:(NSURLSessionDataTask *)dataTask
                             response:(NSURLResponse *)response
                       responseObject:(id)responseObject
                                error:(NSError *)error
                                  api:(SMRNetAPI *)api
                              success:(void (^)(NSURLSessionDataTask *, id))success
                              failure:(void (^)(NSURLSessionDataTask *, NSError *))failure {
    // 尝试使用ETag获取缓存
    id eTagResponseObject = [self responseObjectForETagWithResponse:(NSHTTPURLResponse *)response api:api];
    if (eTagResponseObject) {
        responseObject = eTagResponseObject;
    }
    // 尝试缓存ETag信息
    [self cacheResponseObjectForETag:responseObject response:(NSHTTPURLResponse *)response api:api];
    // 校验网络错误
    NSError *netError = [self.config validateServerErrorWithAPI:api response:response responseObject:responseObject error:error];
    if (netError) {
        if (failure) {
            failure(dataTask, netError);
        }
    } else {
        if (success) {
            success(dataTask, responseObject);
        }
    }
}

#pragma mark - GeneralHeaders

- (void)configRequestGeneralHeadersBeforeDataTask:(NSMutableURLRequest *)request api:(SMRNetAPI *)api {
    // 日期
    NSString *syncedRFC1123Date = [SMRNetInfo rfc1123StringWithDate:[SMRNetInfo syncedDate]];
    [request setValue:syncedRFC1123Date forHTTPHeaderField:@"Date"];
    // Cookie
    NSString *cookie = [SMRNetInfo getCookie];
    if (cookie) {
        [request setValue:cookie forHTTPHeaderField:@"cookie"];
    }
}

#pragma mark - ETag

- (void)configETagBeforeDataTaskIfRequestMethodGET:(NSMutableURLRequest *)request api:(SMRNetAPI *)api {
    if ([SMRReqeustMethodGET isEqualToString:api.method]) {
        SMRNetCachePolicy *policy = [SMRNetCachePolicy policyWithIdentifier:api.url cacheKey:api.url];
        NSString *etag = (NSString *)[self.netCache objectWithPolicy:policy];
        if (etag) {
            [request setValue:etag forHTTPHeaderField:@"If-None-Match"];
        }
    }
}

- (id)responseObjectForETagWithResponse:(NSHTTPURLResponse *)response api:(SMRNetAPI *)api {
    if (![response isKindOfClass:[NSHTTPURLResponse class]]) {
        return nil;
    }
    if ([(NSHTTPURLResponse *)response statusCode] == 304) {
        // 返回304我们就从缓存中取数据
        id responseObject = [self.netCache objectWithPolicy:[SMRNetCachePolicy policyWithIdentifier:@"SMRETagValue" cacheKey:api.url]];
        return responseObject;
    }
    return nil;
}

- (void)cacheResponseObjectForETag:(id)responseObject response:(NSHTTPURLResponse *)response api:(SMRNetAPI *)api {
    if (![response isKindOfClass:[NSHTTPURLResponse class]]) {
        return;
    }
    // 保存ETag
    NSString *ETag = [(NSHTTPURLResponse *)response allHeaderFields][@"ETag"];
    if (ETag && [(NSHTTPURLResponse *)response statusCode] == 200) {
        [self.netCache addObject:responseObject policy:[SMRNetCachePolicy policyWithIdentifier:@"SMRETagValue" cacheKey:api.url]];
        [self.netCache addObject:ETag policy:[SMRNetCachePolicy policyWithIdentifier:@"SMRETagKey" cacheKey:api.url]];
    }
}

#pragma mark - Getters

- (NSLock *)lock {
    if (!_lock) {
        _lock = [[NSLock alloc] init];
    }
    return _lock;
}

- (SMRNetCache *)netCache {
    [self.lock lock];
    if (!_netCache) {
        _netCache = [[SMRNetCache alloc] init];
    }
    [self.lock unlock];
    return _netCache;
}

- (SMRNetConfig *)config {
    [self.lock lock];
    if (!_config) {
        _config = [[SMRNetConfig alloc] init];
        [_config configPrepare];
    }
    [self.lock unlock];
    return _config;
}

- (SMRNetDedouncer<SMRNetAPI *> *)dedouncer {
    [self.lock lock];
    if (!_dedouncer) {
        _dedouncer = [[SMRNetDedouncer alloc] init];
    }
    [self.lock unlock];
    return _dedouncer;
}

@end
