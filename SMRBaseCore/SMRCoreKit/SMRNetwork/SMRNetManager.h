//
//  SMRNetManager.h
//  SMRNetworkDemo
//
//  Created by 丁治文 on 2018/10/6.
//  Copyright © 2018年 sumrise.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SMRNetConfig;
@class SMRNetAPI;
@class SMRAPICallback;
@interface SMRNetManager : NSObject

@property (assign, nonatomic, readonly) BOOL suspended;         ///< 挂起状态
@property (assign, nonatomic, readonly) BOOL reachable;         ///< 网络是否可用
@property (assign, nonatomic, readonly) BOOL reachableViaWWAN;  ///< WWAN网络(无线广域网)是否可用
@property (assign, nonatomic, readonly) BOOL reachableViaWiFi;  ///< WiFi网络是否可用

+ (instancetype)sharedManager;
- (void)startWithConfig:(SMRNetConfig *)config;
- (SMRNetConfig *)config;

#pragma mark - Query

/** API请求 */
- (void)query:(SMRNetAPI *)api;
/** API请求2 */
- (void)query:(SMRNetAPI *)api callback:(SMRAPICallback *)callback;

@end
