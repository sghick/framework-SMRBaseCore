//
//  SMRNotificationManager.m
//  SMRBaseCoreDemo
//
//  Created by 丁治文 on 2019/5/10.
//  Copyright © 2019 sumrise. All rights reserved.
//

#import "SMRNotificationManager.h"

NSString * kSMRWillJumpFromPushNotificaation = @"kSMRWillJumpFromPushNotificaation";

@interface SMRNotificationManager ()

@end

@implementation SMRNotificationManager

+ (instancetype)sharedInstance {
    static SMRNotificationManager *_sharedNotificationManager = nil;
    static dispatch_once_t _sharedNotificationManagerOnceToken;
    dispatch_once(&_sharedNotificationManagerOnceToken, ^{
        _sharedNotificationManager = [[SMRNotificationManager alloc] init];
    });
    return _sharedNotificationManager;
}

#pragma mark - Regist

- (void)configNotificationWithDelegate:(id<UNUserNotificationCenterDelegate>)delegate {
    if (@available(iOS 10.0, *)) {
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        [center setDelegate:delegate];
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionAlert |
                                                 UNAuthorizationOptionBadge |
                                                 UNAuthorizationOptionSound)
                              completionHandler:^(BOOL granted, NSError * _Nullable error) {
                                  if (granted) { // 授权接收通知
                                      // 注册获得device Token
                                      dispatch_async(dispatch_get_main_queue(), ^{
                                          
                                          [[UIApplication sharedApplication] registerForRemoteNotifications];
                                      });
                                  }
                              }];
        
    } else {
        [self configNotification];
    }
}

- (void)configNotification {
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeSound | UIUserNotificationTypeBadge categories:nil];
    [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    // 注册获得device Token
    [[UIApplication sharedApplication] registerForRemoteNotifications];
}

#pragma mark - Jump

- (void)setApplicationIconBadgeNumber:(NSInteger)applicationIconBadgeNumber {
    [UIApplication sharedApplication].applicationIconBadgeNumber = applicationIconBadgeNumber;
}

- (NSInteger)applicationIconBadgeNumber {
    return [UIApplication sharedApplication].applicationIconBadgeNumber;
}

- (void)setActionWithPushURL:(NSString *)pushURL userInfo:(nonnull NSDictionary *)userInfo fromType:(SMRPushFromType)fromType {
    _pushURL = pushURL;
    _userInfo = userInfo;
    _fromType = fromType;
}

- (void)performCurrentActionOnceIfNeeded {
    if ([self canResponseCurrentAction]) {
        [self performCurrentAction];
        [self removeCurrentAction];
        [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    }
}

- (BOOL)canResponseCurrentAction {
    if (self.pushURL.length) {
        return YES;
    }
    return NO;
}

- (void)performCurrentAction {
    NSURL *url = [NSURL URLWithString:self.pushURL];
    [[NSNotificationCenter defaultCenter] postNotificationName:kSMRWillJumpFromPushNotificaation object:url];
    if (self.actionBlock) {
        self.actionBlock(self);
    }
}

- (void)removeCurrentAction {
    _pushURL = nil;
    _userInfo = nil;
    _fromType = SMRPushFromTypeNone;
}

- (void)clearIconBadgeNumber {
    if (@available(iOS 11.0, *)) {
        [UIApplication sharedApplication].applicationIconBadgeNumber = -1;
    } else {
        UILocalNotification *clearEpisodeNotification = [[UILocalNotification alloc] init];
        clearEpisodeNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:(0.3)];
        clearEpisodeNotification.timeZone = [NSTimeZone defaultTimeZone];
        clearEpisodeNotification.applicationIconBadgeNumber = -1;
        [[UIApplication sharedApplication] scheduleLocalNotification:clearEpisodeNotification];
    }
}

+ (NSString *)deviceTokenWithData:(NSData *)data {
    NSMutableString *deviceTokenStr = [NSMutableString string];
    const char *bytes = data.bytes;
    NSInteger count = data.length;
    for (int i = 0; i < count; i++) {
        [deviceTokenStr appendFormat:@"%02x", bytes[i]&0x000000FF];
    }
    return [deviceTokenStr copy];
}

@end
