//
//  SMRNetManager.h
//  SMRNetworkDemo
//
//  Created by 丁治文 on 2018/10/6.
//  Copyright © 2018年 sumrise.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SMRNetAPI.h"

NS_ASSUME_NONNULL_BEGIN

@class SMRSession;
@class SMRNetConfig;
@class SMRNetAPI;
@class SMRAPICallback;
@interface SMRNetManager : NSObject

@property (assign, nonatomic, readonly) BOOL suspended;         ///< 挂起状态
@property (assign, nonatomic, readonly) BOOL reachable;         ///< 网络是否可用
@property (assign, nonatomic, readonly) BOOL reachableViaWWAN;  ///< WWAN网络(无线广域网)是否可用
@property (assign, nonatomic, readonly) BOOL reachableViaWiFi;  ///< WiFi网络是否可用

@property (strong, nonatomic, readonly) SMRSession *session;
@property (strong, nonatomic, readonly) SMRNetConfig *config;

+ (instancetype)sharedManager;
- (void)startWithConfig:(SMRNetConfig *)config;
- (void)startWithSession:(nullable SMRSession *)session config:(nullable SMRNetConfig *)config;

#pragma mark - Query

/** API请求 */
- (void)query:(SMRNetAPI *)api __deprecated_msg("已废弃,使用-[SMRNetAPI query]");
/** API请求2 */
- (void)query:(SMRNetAPI *)api callback:(SMRAPICallback *)callback __deprecated_msg("已废弃,使用-[SMRNetAPI queryWithCallback:]");
/** API请求(不通过节流器) */
- (void)queryAPIWithoutDedouncer:(SMRNetAPI *)api;

@end

@interface SMRNetAPI (SMRNetManager)

/** API请求 */
- (void)query;
/** API请求2 */
- (void)queryWithCallback:(SMRAPICallback *)callback;

@end

NS_ASSUME_NONNULL_END
