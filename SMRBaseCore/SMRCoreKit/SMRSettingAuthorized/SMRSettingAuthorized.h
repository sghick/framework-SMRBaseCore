//
//  SMRSettingAuthorized.h
//  SMRBaseCore
//
//  Created by 丁治文 on 2019/7/11.
//  Copyright © 2019 sumrise. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SMRSettingAuthorized : NSObject

/** 打开此APP的设置页 */
+ (void)openSettings;

/** 通知权限 */
+ (void)getNotificationSetting:(void (^)(BOOL authorized))block;

/** 相机权限 */
+ (void)getCameraSetting:(void (^)(BOOL authorized))block request:(BOOL)request;

/** 麦克风权限 */
+ (void)getMicrophoneSetting:(void (^)(BOOL))block request:(BOOL)request;

/** 相册权限 */
+ (void)getAlblumSetting:(void (^)(BOOL authorized))block request:(BOOL)request;

@end

NS_ASSUME_NONNULL_END
