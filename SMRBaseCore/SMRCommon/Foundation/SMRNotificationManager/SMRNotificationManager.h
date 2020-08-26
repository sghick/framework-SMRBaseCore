//
//  SMRNotificationManager.h
//  SMRBaseCoreDemo
//
//  Created by 丁治文 on 2019/5/10.
//  Copyright © 2019 sumrise. All rights reserved.
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

@interface SMRNotificationManager : NSObject

/** 设置执行任务时的处理方式 */
@property (copy  , nonatomic) SMRNotificationManagerActionBlock actionBlock;
/** 设置AppIcon位置的红点数,0自动隐藏 */
@property (assign, nonatomic) NSInteger applicationIconBadgeNumber;

@property (copy  , nonatomic, readonly) NSString * _Nullable pushURL;
@property (copy  , nonatomic, readonly) NSDictionary * _Nullable userInfo;
@property (assign, nonatomic, readonly) SMRPushFromType fromType;

/** 单例 */
+ (instancetype)sharedInstance;

/** 注册推送,获取推送权限 */
- (void)configNotificationWithDelegate:(id<UNUserNotificationCenterDelegate>)delegate API_AVAILABLE(ios(10.0));
- (void)configNotification;

/** 设置一个任务及参数,只要有url就可以回调actionBlock,新的任务会覆盖旧的 */
- (void)setActionWithPushURL:(nullable NSString *)pushURL userInfo:(NSDictionary *)userInfo fromType:(SMRPushFromType)fromType;

/** 执行一次任务[推荐]在root的`viewDidAppear/后台激活时`调用 */
- (void)performCurrentActionOnceIfNeeded;

/** 清除推送的badge */
- (void)clearIconBadgeNumber;

/** 二进制转字符串 */
+ (NSString *)deviceTokenWithData:(NSData *)data;

@end

NS_ASSUME_NONNULL_END
