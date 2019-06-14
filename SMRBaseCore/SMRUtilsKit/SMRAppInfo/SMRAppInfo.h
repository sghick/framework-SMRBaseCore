//
//  SMRAppInfo.h
//  SMRBaseCoreDemo
//
//  Created by 丁治文 on 2019/4/11.
//  Copyright © 2019 sumrise. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SMRAppInfo : NSObject

/**
 deviceToken的设置方法,需要设置后才能有值
 */
+ (void)setDeviceToken:(nullable NSString *)deviceToken;
+ (NSString *)deviceToken;

/**
 登录状态的设置,此状态会存在沙盒中
 */
+ (void)setLogined:(BOOL)logined;
+ (BOOL)logined;

/**
 Web中默认的UserAgent,需要在启动时设置后才能有值
 */
+ (void)setWebPureUserAgent:(nullable NSString *)userAgent;
+ (NSString *)webPureUserAgent;
+ (NSString *)webPureUserAgentByAppendings:(NSArray<NSString *> *)appendings;

@end

NS_ASSUME_NONNULL_END
