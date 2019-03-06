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
+ (void)toast:(NSString *)toast inView:(UIView *)inView;

/** 展示HUD */
+ (void)showHUD;
+ (void)showHUDInView:(UIView *)inView;

/** 隐藏HUD */
+ (void)hideHUD;
+ (void)hideHUDInView:(UIView *)inView;

@end

NS_ASSUME_NONNULL_END
