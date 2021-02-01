//
//  SMRNotificationManager.h
//  SMRBaseCoreDemo
//
//  Created by 丁治文 on 2019/5/10.
//  Copyright © 2019 ibaodashi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UserNotifications/UserNotifications.h>

NS_ASSUME_NONNULL_BEGIN

/// 点击推送时,即将跳转时的通知,一般用在外跳APP时刷新首页用,参数为即将跳转的URL
extern NSString * kSMRWillJumpFromPushNotificaation;

typedef NS_ENUM(NSInteger, SMRPushFromType) {
    SMRPushFromTypeNone,            ///< 无
    SMRPushFromTypeRemotePush,      ///< 远程推送
    SMRPushFromTypeLocalPush,       ///< 本地推送
    SMRPushFromTypeUniversalLink,   ///< 深度链接
    SMRPushFromTypePasteBoard,      ///< 粘贴版
    SMRPushFromType3DTouch,         ///< 3DTouch链接
    SMRPushFromTypeOtherAPP,        ///< 其它App
};

@class SMRNotificationManager;
typedef void(^SMRNotificationManagerActionBlock)(SMRNotificationManager *manager);

API_AVAILABLE(ios(10.0))
@interface SMRNotificationManager : NSObject

/// =========== 推荐在注册时设置=============== ///
/** 设置注册推送时所支持的option >= iOS10 */
@property (assign, nonatomic) UNAuthorizationOptions authOptions API_AVAILABLE(ios(10.0));
/** 设置注册推送时所支持的option < iOS10 */
@property (assign, nonatomic) UIUserNotificationType notiTypes;
/** 设置执行任务时的处理方式 */
@property (copy  , nonatomic) SMRNotificationManagerActionBlock actionBlock;
/** 设置UniversalLink域名校验,如"jump.xxxx.com" */
@property (copy  , nonatomic) NSString *domainForUL;
/** 配置白名单, 默认nil, 表示无限制; 配置后仅允许urlTypes中的url进行跳转 */
@property (copy  , nonatomic) NSArray<NSString *> *urlTypes;

/// =========== 功能方法=============== ///
/** 设置AppIcon位置的红点数,0自动隐藏 */
@property (assign, nonatomic) NSInteger applicationIconBadgeNumber;
/** 设置为YES后,执行 -performCurrentActionOnceIfPrepared有效 */
@property (assign, nonatomic) BOOL prepared;

@property (copy  , nonatomic, readonly) NSString * _Nullable pushURL;
@property (copy  , nonatomic, readonly) NSDictionary * _Nullable userInfo;
@property (assign, nonatomic, readonly) SMRPushFromType fromType;

/** 单例 */
+ (instancetype)sharedInstance;

/** 注册推送,获取推送权限 */
- (void)configNotificationWithDelegate:(id<UNUserNotificationCenterDelegate>)delegate API_AVAILABLE(ios(10.0));
- (void)configNotification;

/// 以下2个方法设置成功返回YES,同时会触发 -performCurrentActionOnceIfPrepared方法一次
/** UniversalLink activity跳转的方法 */
- (BOOL)setActionAndOpenWithUniversalLinkWithApplication:(UIApplication *)application userActivity:(NSUserActivity *)userActivity;
- (BOOL)setActionAndOpenWithURL:(NSURL *)url userInfo:(nullable NSDictionary *)userInfo fromType:(SMRPushFromType)fromType;

/** 设置一个任务及参数,只要有url就可以回调actionBlock,新的任务会覆盖旧的 */
- (void)setActionWithPushURL:(nullable NSString *)pushURL userInfo:(nullable NSDictionary *)userInfo fromType:(SMRPushFromType)fromType;

/** 执行一次任务[推荐]在root的`viewDidAppear/后台激活时`调用 */
- (void)performCurrentActionOnceIfNeeded __deprecated_msg("即将废弃, use -performCurrentActionOnceIfPrepared 方法代替");
- (void)performCurrentActionOnceIfPrepared;

/** 清除推送的badge */
- (void)clearIconBadgeNumber;

/** 二进制转字符串 */
+ (NSString *)deviceTokenWithData:(NSData *)data;

@end

NS_ASSUME_NONNULL_END
