//
//  SMRNetManager.m
//  SMRNetworkDemo
//
//  Created by 丁治文 on 2018/10/6.
//  Copyright © 2018年 sumrise.com. All rights reserved.
//

#import "SMRNetManager.h"
#import "SMRNetConfig.h"
#import "SMRNetAPI.h"
#import "SMRNetAPIQueue.h"
#import "SMRSession.h"
#import "SMRNetDedouncer.h"
#import "NSError+SMRNetwork.h"

@interface SMRNetManager ()<
SMRSessionRetryDelegate,
SMRSessionAPIInitDelegate>

@property (strong, nonatomic) NSLock *lock;
@property (strong, nonatomic) SMRNetAPIQueue *netAPIQueue;
@property (strong, nonatomic) SMRSession *session;

// API防抖处理
@property (strong, nonatomic) NSMutableArray *dedounceIdentifier; ///< 存放'同时间内'的API标识
@property (strong, nonatomic) NSMutableDictionary<NSString *, NSMutableArray<SMRNetAPI *> *> *dedounceList; ///< 某API标识中所有的api

@end

@implementation SMRNetManager

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
    [self.session configration:config];
    self.session.dedouncer.invalidateDuration = config.invalidateDuration;
}

- (void)p_suspendAllTask {
    _suspended = YES;
}

- (void)p_resumeAllTask {
    _suspended = NO;
    SMRNetAPI *api = [self.netAPIQueue dequeue];
    while (api) {
        api.callback.retryCount++;
        [self p_queryOnlyAPI:api];
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
    
    NSTimeInterval timerIntervalForDedounce = [self.config timerIntervalForDedounce];
    NSInteger maxCount = [self.config maxCountForDedounce];
    [self.dedouncer dedounce:api identifier:api.identifier withinTime:timerIntervalForDedounce maxCount:maxCount resultBlock:^(SMRNetDedouncer *dedouncer, NSTimeInterval groupTag, SMRNetAPI *obj) {
        // 设置防止抖动的tag
        api.callback.groupTagForDedounce = groupTag;
        [self p_queryOnlyAPI:api];
    }];
}

- (void)p_queryOnlyAPI:(SMRNetAPI *)api {
    NSLog(@"发起API:%@", api.identifier);
    // 创建task
    NSURLSessionTask *task = [self.session smr_dataTaskWithAPI:api];
    // 发起请求
    if (!self.suspended) {
        [task resume];
    } else {
        [self.netAPIQueue enqueue:api];
    }
}

#pragma mark - SMRSessionRetryDelegate

/// 是否需要重试
- (BOOL)willRetryWithError:(NSError *)error api:(SMRNetAPI *)api {
    SMRAPICallback *callback = api.callback;
    BOOL canRetry = [self.config canRetryWhenRecivedError:error api:api];
    BOOL shouldRetry = (canRetry && (callback.retryCount < api.maxRetryTime));
    if (shouldRetry) {
        callback.retryCount++;
        [self p_queryOnlyAPI:api];
    }
    return shouldRetry;
}

#pragma mark - SMRSessionAPIInitDelegate

/// 是否需要初始化API/自动登录
- (BOOL)willQueryInitAPIWithError:(NSError *)error api:(SMRNetAPI *)api {
    BOOL shouldQueryInit = NO;
    // 从config中获取初始化API,如果获取到了,则判断是否满足初始化API的条件
    SMRNetAPI *initAPI = [self p_getInitAPIIfNeededWhenRecviedError:error api:api];
    if (initAPI) {
        shouldQueryInit = YES;
        // 将当前API入队,同时拦截之后的所有API请求,并入队
        [self.netAPIQueue enqueue:api];
        // 保证API请求过程中不会被重复请求初始化API
        if (!self.suspended) {
            SMRAPICallback *callback = [SMRAPICallback callbackWithConstructingBlock:nil cacheBlock:nil successBlock:^(SMRNetAPI *api, id response) {
                // 向config发送api初始化成功的消息
                BOOL successed = [self.config apiInitSuccessed:api response:response];
                if (successed) {
                    // API初始化成功后开启其它API请求
                    [self p_resumeAllTask];
                } else {
                    
                    NSLog(@"初始化API失败,config中判断失败:%@", api.identifier);
                    // 向config发送api初始化失败的消息
                    [self.config apiInitFaild:error];
                    // API初始化失败后,向所有队列中API发送失败消息
                    NSError *error = [NSError smr_errorForNetworkDomainWithCode:1001 detail:nil message:@"config认为API初始化失败" userInfo:nil];
                    [self p_callbackAllFaildTaskWithError:error];
                }
            } faildBlock:^(SMRNetAPI *api, id response, NSError *error) {
                
                NSLog(@"初始化API失败:%@,%@", api.identifier, error);
                // 向config发送api初始化失败的消息
                [self.config apiInitFaild:error];
                // API初始化失败后,向所有队列中API发送失败消息
                [self p_callbackAllFaildTaskWithError:error];
            } uploadProgress:nil downloadProgress:nil];
            
            NSLog(@"初始化API中:%@", initAPI.identifier);
            // 先发起本次初始化API
            initAPI.callback = callback;
            [self p_queryOnlyAPI:initAPI];
            // 挂起其它API,直到API初始化API判定成功
            [self p_suspendAllTask];
        }
    }
    return shouldQueryInit;
}

- (SMRNetAPI *)p_getInitAPIIfNeededWhenRecviedError:(NSError *)error api:(SMRNetAPI *)api {
    if ([self.config canQueryInitAPIWhenRecivedError:error currentAPI:api]) {
        SMRNetAPI *initAPI = [self.config apiForInitialization];
        if (!initAPI.identifier) {
            NSAssert(NO, @"请为您的初始化API设置一个identifier");
            return nil;
        }
        
        if (![initAPI.identifier isEqualToString:api.identifier]) {
            return initAPI;
        }
    }
    return nil;
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
        _session = [SMRSession manager];
        _session.retryDelegate = self;
        _session.initDelegate = self;
    }
    [self.lock unlock];
    return _session;
}

- (SMRNetConfig *)config {
    return self.session.config;
}

- (SMRNetCache *)netCache {
    return self.session.netCache;
}

- (SMRNetDedouncer<SMRNetAPI *> *)dedouncer {
    return self.session.dedouncer;
}

@end
