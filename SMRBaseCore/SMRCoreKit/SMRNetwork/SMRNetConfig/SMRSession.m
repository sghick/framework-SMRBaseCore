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
#import "SMRNetError.h"
#import "SMRNetCache.h"
#import "SMRNetInfo.h"

@implementation SMRSession
@synthesize netCache = _netCache;
@synthesize config = _config;

- (void)configration:(SMRNetConfig *)config {
    _config = config;
    
    self.requestSerializer = [AFJSONRequestSerializer serializer];
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
        if (self.config.debugLog) {
            NSLog(@"API请求成功:%@,\n%@", api, responseObject);
        }
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
    } failure:^(NSURLSessionDataTask *task, SMRNetError *error) {
        id response = [self.config responseObjectWithError:error];
        NSLog(@"API请求错误:%@,\n\tresponse=%@,\n%@", api, response, error);
        // 设置请求结束的标志
        didServiceResponse = YES;
        // 同步时间和Cookie
        [SMRNetInfo syncNetInfoWithResponse:(NSHTTPURLResponse *)task.response];
        // 保存网络请求失败的结果
        [api fillResponse:nil error:error];
        // 重试
        BOOL shouldRetry = NO;
        if ([self.retryDelegate respondsToSelector:@selector(shouldRetryWithError:api:)]) {
            shouldRetry = [self.retryDelegate shouldRetryWithError:error api:api];
        }
        // 初始化API
        BOOL shouldInit = NO;
        if ([self.initDelegate respondsToSelector:@selector(shouldQueryInitAPIWithError:api:)]) {
            shouldInit = [self.initDelegate shouldQueryInitAPIWithError:error api:api];
        }
        // 如果不需要重试,并且不需要初始化API,则进行回调,否则将在内部处理
        BOOL shouldCallback = (!shouldRetry && !shouldInit);
        if (shouldCallback && callback.faildBlock) {
            callback.faildBlock(api, response, error);
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
                                      failure:(void (^)(NSURLSessionDataTask *, SMRNetError *))failure{
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
- (NSURLSessionDataTask *)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             smr_dataTaskWithAPI:(SMRNetAPI *)api
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            uploadProgress:(nullable void (^)(NSProgress *))uploadProgress
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          downloadProgress:(nullable void (^)(NSProgress *))downloadProgress
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   success:(void (^)(NSURLSessionDataTask *, id))success
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   failure:(void (^)(NSURLSessionDataTask *, SMRNetError *))failure {
    
    AFHTTPSessionManager *manager = self;
    // 设置超时时间
    manager.requestSerializer.timeoutInterval = api.timeoutInterval;
    // 创建request对象
    NSError *serializationError = nil;
    NSURL *relativeURL = [NSURL URLWithString:api.host] ?: manager.baseURL;
    NSMutableURLRequest *request = [manager.requestSerializer requestWithMethod:api.method
                                                                      URLString:[[NSURL URLWithString:api.url relativeToURL:relativeURL] absoluteString]
                                                                     parameters:api.params
                                                                          error:&serializationError];
    if (serializationError) {
        if (failure) {
            dispatch_async(manager.completionQueue ?: dispatch_get_main_queue(), ^{
                failure(nil, [SMRNetError smr_errorWithBaseError:serializationError]);
            });
        }
        
        return nil;
    }
    // 设置Header的时机
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
                                                  failure:(void (^)(NSURLSessionDataTask *, SMRNetError *))failure {
    AFHTTPSessionManager *manager = self;
    // 设置超时时间
    manager.requestSerializer.timeoutInterval = api.timeoutInterval;
    // 创建request对象
    NSError *serializationError = nil;
    NSURL *relativeURL = [NSURL URLWithString:api.host] ?: manager.baseURL;
    NSMutableURLRequest *request = [self.requestSerializer multipartFormRequestWithMethod:api.method URLString:[[NSURL URLWithString:api.url relativeToURL:relativeURL] absoluteString] parameters:api.params constructingBodyWithBlock:block error:&serializationError];
    if (serializationError) {
        if (failure) {
            dispatch_async(self.completionQueue ?: dispatch_get_main_queue(), ^{
                failure(nil, [SMRNetError smr_errorWithBaseError:serializationError]);
            });
        }
        
        return nil;
    }
    // 设置Header的时机
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
                              failure:(void (^)(NSURLSessionDataTask *, SMRNetError *))failure {
    // 尝试使用ETag获取缓存
    id eTagResponseObject = [self responseObjectForETagWithResponse:(NSHTTPURLResponse *)response api:api];
    if (eTagResponseObject) {
        responseObject = eTagResponseObject;
    }
    // 尝试缓存ETag信息
    [self cacheResponseObjectForETag:responseObject response:(NSHTTPURLResponse *)response api:api];
    // 校验网络错误
    SMRNetError *netError = [self.config validateServerErrorWithAPI:api response:response responseObject:responseObject error:error];
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

- (SMRNetCache *)netCache {
    if (!_netCache) {
        _netCache = [[SMRNetCache alloc] init];
    }
    return _netCache;
}

- (SMRNetConfig *)config {
    if (!_config) {
        _config = [[SMRNetConfig alloc] init];
        [_config configPrepare];
    }
    return _config;
}

@end
