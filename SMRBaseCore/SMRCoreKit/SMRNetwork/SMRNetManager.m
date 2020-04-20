//
//  SMRNetManager.m
//  SMRNetworkDemo
//
//  Created by 丁治文 on 2018/10/6.
//  Copyright © 2018年 sumrise.com. All rights reserved.
//

#import "SMRNetManager.h"
#import "SMRNetConfig.h"
#import "SMRSession.h"
#import "SMRNetAPI.h"
#import "SMRNetAPIQueue.h"
#import "SMRNetDedouncer.h"
#import "SMRNetCache.h"
#import "SMRNetInfo.h"
#import "NSError+SMRNetwork.h"
#import "SMRLog.h"

// TODO:will remove from manager
#import <AFNetworking/AFNetworking.h>

@interface SMRNetManager ()

@property (strong, nonatomic) NSLock *lock;
@property (strong, nonatomic) SMRNetAPIQueue *netAPIQueue;
@property (strong, nonatomic) SMRNetCache *netCache;
@property (strong, nonatomic) SMRNetDedouncer<SMRNetAPI *> *dedouncer;

@end

@implementation SMRNetManager

@synthesize session = _session;
@synthesize config = _config;

+ (instancetype)sharedManager {
    static SMRNetManager *_sharedNetManager = nil;
    static dispatch_once_t _sharedNetManagerOnceToken;
    dispatch_once(&_sharedNetManagerOnceToken, ^{
        _sharedNetManager = [[SMRNetManager alloc] init];
        _sharedNetManager.lock = [[NSLock alloc] init];
    });
    return _sharedNetManager;
}

- (void)startWithConfig:(SMRNetConfig *)config {
    [self startWithSession:nil config:config];
}

- (void)startWithSession:(SMRSession *)session config:(SMRNetConfig *)config {
    _session = session ?: [[SMRSession alloc] init];
    _config = config ?: [[SMRNetConfig alloc] init];
    [_session configration:_config];
}

- (void)p_suspendAllTask {
    _suspended = YES;
}

- (void)p_resumeAllTask {
    _suspended = NO;
    SMRNetAPI *api = [self.netAPIQueue dequeue];
    while (api) {
        api.callback.retryCount++;
        [self queryAPIWithoutDedouncer:api];
        api = [self.netAPIQueue dequeue];
    }
}

- (void)p_callbackAllFaildTaskWithError:(NSError *)error {
    SMRNetAPI *api = [self.netAPIQueue dequeue];
    while (api) {
        if (api.callback.faildBlock) {
            api.callback.faildBlock(api, nil, error);
        }
        api = [self.netAPIQueue dequeue];
    }
    _suspended = NO;
}

#pragma mark - Query

- (void)query:(SMRNetAPI *)api {
    [self p_query:api callback:api.callback];
}

- (void)query:(SMRNetAPI *)api callback:(SMRAPICallback *)callback {
    [self p_query:api callback:callback];
}

- (void)p_query:(SMRNetAPI *)api callback:(SMRAPICallback *)callback {
    // 设置callback
    api.callback = callback;
    
    NSInteger maxCount = [self.config maxCountForDedounce];
    [self.dedouncer dedounce:api identifier:api.identifier maxCount:maxCount resultBlock:^(SMRNetDedouncer *dedouncer, SMRNetAPI *obj) {
        [self queryAPIWithoutDedouncer:api];
    }];
}

- (void)queryAPIWithoutDedouncer:(SMRNetAPI *)api {
    base_core_log(@"发起API:%@", api.identifier);
    // 创建task
    NSURLSessionTask *task = [self dataTaskWithAPI:api];
    // 发起请求
    if (!self.suspended) {
        [task resume];
    } else {
        [self.netAPIQueue enqueue:api];
    }
}

#pragma mark - DataTask

- (NSURLSessionDataTask *)dataTaskWithAPI:(SMRNetAPI *)api {
    SMRAPICallback *callback = api.callback;
    // cache
    if (callback.cacheBlock || callback.cacheOrSuccessBlock) {
        id object = [self.netCache objectWithPolicy:api.cachePolicy];
        if (callback.cacheBlock) {
            callback.cacheBlock(api, object);
        }
        if (callback.cacheOrSuccessBlock) {
            callback.cacheOrSuccessBlock(api, object, YES);
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
        // 同步时间和Cookie
        [SMRNetInfo syncNetInfoWithResponse:(NSHTTPURLResponse *)task.response];
        // 保存网络请求成功的结果
        [api fillResponse:responseObject error:nil];
        // 请求成功之后加入缓存
        if (api.cachePolicy) {
            [self.netCache addObject:responseObject policy:api.cachePolicy];
        }
        // 处理防抖结果
        NSArray<SMRNetAPI *> *dedouncedAPIs = [self.dedouncer objectForDedouncedWithIdentifier:api.identifier];
        [self.dedouncer removeObjectForDedouncedWithIdentifier:api.identifier];
        // 请求成功的回调
        if (callback.successBlock) {
            callback.successBlock(api, responseObject);
        }
        if (callback.cacheOrSuccessBlock) {
            callback.cacheOrSuccessBlock(api, responseObject, NO);
        }
        for (SMRNetAPI *deapi in dedouncedAPIs) {
            // 保存网络请求成功的结果
            [deapi fillResponse:responseObject error:nil];
            // 请求成功的回调
            if (deapi.callback.successBlock) {
                deapi.callback.successBlock(deapi, responseObject);
            }
            if (deapi.callback.cacheOrSuccessBlock) {
                deapi.callback.cacheOrSuccessBlock(deapi, responseObject, NO);
            }
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        id response = [self.session parserToResponseWithError:error];
        if (self.config.debugLog) {
            base_core_log(@"API请求错误:%@,\n\tresponse=%@,\n%@", api, response, error);
        }
        // 同步时间和Cookie
        [SMRNetInfo syncNetInfoWithResponse:(NSHTTPURLResponse *)task.response];
        // 保存网络请求失败的结果
        [api fillResponse:response error:error];
        // 重试
        BOOL willRetry = [self willRetryWithError:error api:api];
        // 新增API,再重试
        BOOL willQueryNewAPI = [self willQueryNewAPIAndRetryWithError:error api:api];
        // 如果不需要重试,并且不需要新增API,则进行回调,否则将在内部处理
        BOOL shouldCallback = (!willRetry && !willQueryNewAPI);
        if (shouldCallback && callback.faildBlock) {
            // 处理防抖结果
            NSArray<SMRNetAPI *> *dedouncedAPIs = [self.dedouncer objectForDedouncedWithIdentifier:api.identifier];
            [self.dedouncer removeObjectForDedouncedWithIdentifier:api.identifier];
            
            callback.faildBlock(api, response, error);
            for (SMRNetAPI *deapi in dedouncedAPIs) {
                // 保存网络请求失败的结果
                [deapi fillResponse:response error:error];
                // 请求成功的回调
                if (deapi.callback.faildBlock) {
                    deapi.callback.faildBlock(deapi, response, error);
                }
            }
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
                                      failure:(void (^)(NSURLSessionDataTask *, NSError *))failure {
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
    // 创建request对象
    NSError *requestError = nil;
    NSMutableURLRequest *request = [self.session requestWithAPI:api error:&requestError];
    if (requestError && failure) {
        // TODO:可优化为可以指定返回结果的队列
        dispatch_async(dispatch_get_main_queue(), ^{
            NSError *error = [NSError smr_errorForNetworkDomainWithCode:requestError.code
                                                                 detail:nil
                                                                message:nil
                                                               userInfo:requestError.userInfo];
            failure(nil, error);
        });
        return nil;
    }
    // 设置超时时间
    request.timeoutInterval = api.timeoutInterval;
    // 设置Header的时机
    [self configRequestGeneralHeadersBeforeDataTask:request api:api];
    [self.config configRequestBeforeDataTask:request api:api];
    // 设置ETag
    [self configETagBeforeDataTaskIfRequestMethodGET:request api:api];
    // 创建dataTask
    __block NSURLSessionDataTask *dataTask = nil;
    dataTask =
    [self.session dataTaskWithRequest:request uploadProgress:uploadProgress downloadProgress:downloadProgress completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
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
    NSError *requestError = nil;
    NSMutableURLRequest *request = [self.session multipartFormRequestWithAPI:api constructingBodyWithBlock:block error:&requestError];
    if (requestError && failure) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSError *error = [NSError smr_errorForNetworkDomainWithCode:requestError.code
                                                                 detail:nil
                                                                message:nil
                                                               userInfo:requestError.userInfo];
            failure(nil, error);
        });
        return nil;
    }
    // 设置超时时间
    request.timeoutInterval = api.timeoutInterval;
    // 设置Header的时机
    [self configRequestGeneralHeadersBeforeDataTask:request api:api];
    [self.config configRequestBeforeDataTask:request api:api];
    // 设置ETag
    [self configETagBeforeDataTaskIfRequestMethodGET:request api:api];
    // 创建dataTask
    __block NSURLSessionDataTask *dataTask = nil;
    dataTask =
    [self.session uploadTaskWithStreamedRequest:request progress:uploadProgress completionHandler:^(NSURLResponse * _Nonnull response, id  _Nonnull responseObject, NSError * _Nonnull error) {
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

#pragma mark - Retry

/// 是否需要重试
- (BOOL)willRetryWithError:(NSError *)error api:(SMRNetAPI *)api {
    SMRAPICallback *callback = api.callback;
    BOOL canRetry = [self.config canRetryWhenRecivedError:error api:api];
    BOOL shouldRetry = (canRetry && (callback.retryCount < api.maxRetryTime));
    if (shouldRetry) {
        callback.retryCount++;
        [[SMRNetManager sharedManager] queryAPIWithoutDedouncer:api];
    }
    return shouldRetry;
}

#pragma mark - APIInit

/// 是否需要前置一个API
- (BOOL)willQueryNewAPIAndRetryWithError:(NSError *)error api:(SMRNetAPI *)api {
    SMRNetAPI *nAPI = [self.config canQueryNewAPIAndRetryWhenRecivedError:error api:api];
    if (!nAPI) {
        return NO;
    }
    if (!nAPI.identifier.length) {
        NSAssert(NO, @"请为您的初始化API设置一个identifier");
        return NO;
    }
    if ([nAPI.identifier isEqualToString:api.identifier]) {
        return NO;
    }
    
    // 将当前API入队,同时拦截之后的所有API请求,并入队
    [self.netAPIQueue enqueue:api];
    // 保证API请求过程中不会被重复请求初始化API
    if (!self.suspended) {
        SMRAPICallback *callback = [SMRAPICallback callbackWithConstructingBlock:nil cacheOrSuccessBlock:nil cacheBlock:nil successBlock:^(SMRNetAPI *api, id response) {
            // API初始化成功后开启其它API请求
            [self p_resumeAllTask];
        } faildBlock:^(SMRNetAPI *api, id response, NSError *error) {
            base_core_log(@"初始化API失败:%@,%@", api.identifier, error);
            // API初始化失败后,向所有队列中API发送失败消息
            [self p_callbackAllFaildTaskWithError:error];
        } uploadProgress:nil downloadProgress:nil];

        base_core_log(@"初始化API中:%@", nAPI.identifier);
        // 先发起本次初始化API
        nAPI.callback = callback;
        [self queryAPIWithoutDedouncer:nAPI];
        // 挂起其它API,直到API初始化API判定成功
        [self p_suspendAllTask];
    }
    return YES;
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
        SMRNetCachePolicy *policy = [SMRNetCachePolicy policyWithIdentifier:@"SMRETagKey" cacheKey:api.url];
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
    if (response.statusCode == 304) {
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
    NSString *ETag = response.allHeaderFields[@"ETag"];
    if (ETag && response.statusCode == 200) {
        [self.netCache addObject:responseObject policy:[SMRNetCachePolicy policyWithIdentifier:@"SMRETagValue" cacheKey:api.url]];
        [self.netCache addObject:ETag policy:[SMRNetCachePolicy policyWithIdentifier:@"SMRETagKey" cacheKey:api.url]];
    }
}

#pragma mark - Getters

- (BOOL)reachable {
    return [AFNetworkReachabilityManager sharedManager].isReachable;
}

- (BOOL)reachableViaWWAN {
    return [AFNetworkReachabilityManager sharedManager].isReachableViaWWAN;
}

- (BOOL)reachableViaWiFi {
    return [AFNetworkReachabilityManager sharedManager].isReachableViaWiFi;
}

- (SMRNetAPIQueue *)netAPIQueue {
    [self.lock lock];
    if (!_netAPIQueue) {
        _netAPIQueue = [[SMRNetAPIQueue alloc] init];
    }
    [self.lock unlock];
    return _netAPIQueue;
}

- (SMRSession *)session {
    [self.lock lock];
    if (!_session) {
        _session = [[SMRSession alloc] init];
    }
    [self.lock unlock];
    return _session;
}

- (SMRNetConfig *)config {
    [self.lock lock];
    if (!_config) {
        _config = [[SMRNetConfig alloc] init];
    }
    [self.lock unlock];
    return _config;
}

- (SMRNetCache *)netCache {
    [self.lock lock];
    if (!_netCache) {
        _netCache = [[SMRNetCache alloc] init];
    }
    [self.lock unlock];
    return _netCache;
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

@implementation SMRNetAPI (SMRNetManager)

- (void)query {
    [[SMRNetManager sharedManager] query:self];
}

- (void)queryWithCallback:(SMRAPICallback *)callback {
    [[SMRNetManager sharedManager] query:self callback:callback];
}

@end
