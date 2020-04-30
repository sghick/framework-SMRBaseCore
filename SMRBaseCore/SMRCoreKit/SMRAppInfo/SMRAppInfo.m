//
//  SMRAppInfo.m
//  SMRBaseCoreDemo
//
//  Created by 丁治文 on 2019/4/11.
//  Copyright © 2019 sumrise. All rights reserved.
//

#import "SMRAppInfo.h"

@implementation SMRAppInfo

static NSString *kUDForAppDeviceToken = @"kUDForAppDeviceToken";
static NSString *_deviceToken;
+ (void)setDeviceToken:(nullable NSString *)deviceToken {
    _deviceToken = deviceToken;
    [[self appUserDefaults] setObject:deviceToken forKey:kUDForAppDeviceToken];
}
+ (NSString *)deviceToken {
    if (!_deviceToken) {
        _deviceToken = [[self appUserDefaults] objectForKey:kUDForAppDeviceToken];
    }
    return _deviceToken;
}

static NSString *kUDForAppLogined = @"kUDForAppLogined";
static NSNumber *_logined;
+ (void)setLogined:(BOOL)logined {
    _logined = @(logined);
    [[self appUserDefaults] setObject:_logined forKey:kUDForAppLogined];
}
+ (BOOL)logined {
    if (_logined == nil) {
        _logined = [[self appUserDefaults] objectForKey:kUDForAppLogined];
    }
    return _logined.boolValue;
}

static NSString *kUDForWebPureUserAgent = @"kUDForWebPureUserAgent";
static NSString *_webPureUserAgent;
+ (void)setWebPureUserAgent:(nullable NSString *)userAgent {
    _webPureUserAgent = userAgent;
    [[self appUserDefaults] setObject:_webPureUserAgent forKey:kUDForWebPureUserAgent];
}
+ (NSString *)webPureUserAgent {
    if (!_webPureUserAgent) {
        _webPureUserAgent = [[self appUserDefaults] objectForKey:kUDForWebPureUserAgent];
    }
    return _webPureUserAgent;
}
+ (NSString *)webPureUserAgentByAppendings:(NSArray<NSString *> *)appendings {
    NSString *userAgent = [self webPureUserAgent];
    for (NSString *append in appendings) {
        userAgent = [userAgent stringByAppendingFormat:@" %@", append];
    }
    return userAgent;
}

#pragma mark - UserDefaults

static NSUserDefaults *_ud = nil;
+ (NSUserDefaults *)appUserDefaults {
    if (!_ud) {
        _ud = [[NSUserDefaults alloc] initWithSuiteName:nil];
    }
    return _ud;
}

@end
