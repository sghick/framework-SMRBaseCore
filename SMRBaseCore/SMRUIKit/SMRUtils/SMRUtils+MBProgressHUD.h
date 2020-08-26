//
//  SMRUtils+MBProgressHUD.h
//  SMRBaseCoreDemo
//
//  Created by 丁治文 on 2019/3/5.
//  Copyright © 2019 sumrise. All rights reserved.
//

#import "SMRUtils.h"

NS_ASSUME_NONNULL_BEGIN

@interface SMRUtils (MBProgressHUD)

/** toast */
+ (void)toast:(NSString *)toast;
+ (void)toast:(NSString *)toast inView:(nullable UIView *)inView;

/** 展示HUD */
+ (void)showHUD;
+ (void)showHUDInView:(nullable UIView *)inView;
+ (void)showHUDWithTitle:(nullable NSString *)title;
+ (void)showHUDWithTitle:(nullable NSString *)title inView:(nullable UIView *)inView;

/** 隐藏HUD */
+ (void)hideHUD;
+ (void)hideHUDInView:(nullable UIView *)inView;

@end

NS_ASSUME_NONNULL_END
