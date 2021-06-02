//
//  SMRNotificationManager.m
//  SMRBaseCoreDemo
//
//  Created by 丁治文 on 2019/5/10.
//  Copyright © 2019 isumrise. All rights reserved.
//

#import "SMRNotificationManager.h"

NSString * kSMRWillJumpFromPushNotificaation = @"kSMRWillJumpFromPushNotificaation";

@interface SMRNotificationManager ()

@end

@implementation SMRNotificationManager

- (instancetype)init {
    self = [super init];
    if (self) {
        if (@available(iOS 10.0, *)) {
            _authOptions = UNAuthorizationOptionAlert | UNAuthorizationOptionBadge | UNAuthorizationOptionSound;
        }
        _notiTypes = UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound;
    }
    return self;
}

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
        [center requestAuthorizationWithOptions:self.authOptions
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
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:self.notiTypes categories:nil];
    [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    // 注册获得device Token
    [[UIApplication sharedApplication] registerForRemoteNotifications];
}

#pragma mark - SetJump

- (BOOL)setActionAndOpenWithUniversalLinkWithApplication:(UIApplication *)application userActivity:(NSUserActivity *)userActivity {
    if ([userActivity.activityType isEqualToString:NSUserActivityTypeBrowsingWeb]) {
        NSURL *webUrl = [NSURL URLWithString:userActivity.webpageURL.absoluteString];
        // 拦截所有的包大师的jump域名
        if ([webUrl.host isEqualToString:self.domainForUL]) {
            NSString *lastPath = [webUrl.absoluteString lastPathComponent];
            lastPath = [lastPath componentsSeparatedByString:@"?"].firstObject;
            lastPath = [lastPath stringByRemovingPercentEncoding];
            NSURL *openUrl = [NSURL URLWithString:lastPath];
            if ([self p_setOpenURL:openUrl userInfo:nil fromType:SMRPushFromTypeUniversalLink]) {
                return YES;
            } else {
                return [[UIApplication sharedApplication] openURL:openUrl];
            }
        }
    }
    return NO;
}

- (BOOL)setActionAndOpenWithURL:(NSURL *)url userInfo:(NSDictionary *)userInfo fromType:(SMRPushFromType)fromType {
    return [self p_setOpenURL:url userInfo:userInfo fromType:fromType];
}

/** 需要打开App时,统一由manager保存,由其处理 */
- (BOOL)p_setOpenURL:(NSURL *)url userInfo:(NSDictionary *)userInfo fromType:(SMRPushFromType)fromType {
    if (url.scheme.length && (!self.urlTypes.count || [self.urlTypes containsObject:url.scheme])) {
        SMRNotificationManager *manager = [SMRNotificationManager sharedInstance];
        [manager setActionWithPushURL:url.absoluteString userInfo:nil fromType:fromType];
        [self performCurrentActionOnceIfPrepared];
        return YES;
    } else {
        return NO;
    }
}

#pragma mark - Jump

- (void)setApplicationIconBadgeNumber:(NSInteger)applicationIconBadgeNumber {
    [UIApplication sharedApplication].applicationIconBadgeNumber = applicationIconBadgeNumber;
}

- (NSInteger)applicationIconBadgeNumber {
    return [UIApplication sharedApplication].applicationIconBadgeNumber;
}

- (void)setActionWithPushURL:(NSString *)pushURL userInfo:(NSDictionary *)userInfo fromType:(SMRPushFromType)fromType {
    _pushURL = pushURL;
    _userInfo = userInfo;
    _fromType = fromType;
}

- (void)performCurrentActionOnceIfNeeded {
    BOOL prepared = self.pushURL.length;
    if (prepared) {
        [self performCurrentAction];
        [self removeCurrentAction];
        [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    }
}

- (void)performCurrentActionOnceIfPrepared {
    BOOL prepared = (self.prepared && self.pushURL.length);
    if (prepared) {
        [self performCurrentAction];
        [self removeCurrentAction];
        [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    }
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
