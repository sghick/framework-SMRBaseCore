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

@interface SMRNetManager ()<
SMRSessionRetryDelegate,
SMRSessionAPIInitDelegate>

@property (strong, nonatomic) SMRNetAPIQueue *netAPIQueue;
@property (strong, nonatomic) SMRSession *session;

@end

@implementation SMRNetManager

+ (instancetype)sharedManager {
    static SMRNetManager *_sharedNetManager = nil;
    static dispatch_once_t _sharedNetManagerOnceToken;
    dispatch_once(&_sharedNetManagerOnceToken, ^{
        _sharedNetManager = [[SMRNetManager alloc] init];
    });
    return _sharedNetManager;
}

- (void)startWithConfig:(SMRNetConfig *)config {
    [self.session configration:config];
}

- (void)suspendAllTask {
    _suspended = YES;
}

- (void)resumeAllTask {
    _suspended = NO;
    SMRNetAPI *api = [self.netAPIQueue dequeue];
    while (api) {
        [self p_query:api callback:api.callback];
        api = [self.netAPIQueue dequeue];
    }
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
- (BOOL)shouldRetryWithError:(SMRNetError *)error api:(SMRNetAPI *)api {
    SMRAPICallback *callback = api.callback;
    BOOL shouldRetry = NO;
    if (callback.retryCount < api.maxRetryTime) {
        shouldRetry = [self.config canRetryWhenRecivedError:error api:api];
        if (shouldRetry) {
            callback.retryCount++;
            [self p_query:api callback:callback];
        }
    }
    return shouldRetry;
}

#pragma mark - SMRSessionAPIInitDelegate

/// 是否需要初始化API/自动登录
- (BOOL)shouldQueryInitAPIWithError:(SMRNetError *)error api:(SMRNetAPI *)api {
    BOOL shouldQueryInit = NO;
    SMRNetAPI *initAPI = [self.config shouldQueryInitAPIWithCurrentAPI:api error:error];
    if (initAPI) {
        shouldQueryInit = YES;
        [self.netAPIQueue enqueue:api];
        if (!self.suspended) {
            SMRAPICallback *callback = [SMRAPICallback callbackWithConstructingBlock:nil cacheBlock:nil successBlock:^(SMRNetAPI *api, id response) {
                BOOL successed = [self.config apiInitSuccessed:api response:response];
                if (successed) {
                    [self resumeAllTask];
                } else {
                    NSLog(@"初始化API失败,config中判断失败:%@", api.identifier);
                }
            } faildBlock:^(SMRNetAPI *api, id response, SMRNetError *error) {
                NSLog(@"初始化API失败:%@,%@", api.identifier, error);
                [self.config apiInitFaild:error];
            } uploadProgress:nil downloadProgress:nil];
            NSLog(@"初始化API中:%@", initAPI.identifier);
            [self p_query:api callback:callback];
            // 挂起其它API,直到API初始化API判定成功
            [self suspendAllTask];
        }
    }
    return shouldQueryInit;
}

#pragma mark - Getters

- (SMRNetAPIQueue *)netAPIQueue {
    if (!_netAPIQueue) {
        _netAPIQueue = [[SMRNetAPIQueue alloc] init];
    }
    return _netAPIQueue;
}

- (SMRSession *)session {
    if (!_session) {
        _session = [SMRSession manager];
        _session.retryDelegate = self;
        _session.initDelegate = self;
    }
    return _session;
}

- (SMRNetConfig *)config {
    return self.session.config;
}

- (SMRNetCache *)netCache {
    return self.session.netCache;
}

@end
