//
//  SMRUtils+MBProgressHUD.m
//  SMRBaseCoreDemo
//
//  Created by 丁治文 on 2019/3/5.
//  Copyright © 2019 sumrise. All rights reserved.
//

#import "SMRUtils+MBProgressHUD.h"
#import "MBProgressHUD.h"
#import "SMRNavigator.h"

@implementation SMRUtils (MBProgressHUD)

+ (void)toast:(NSString *)toast {
    UIView *view = [UIApplication sharedApplication].delegate.window;
    [self toast:toast inView:view];
}

+ (void)toast:(NSString *)toast inView:(UIView *)inView {
    if (!toast.length) {
        return;
    }
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:inView animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.label.text = toast;
    hud.offset = CGPointMake(0.f, MBProgressMaxOffset);
    [hud hideAnimated:YES afterDelay:2.f];
}

+ (void)showHUD {
    UIView *view = [UIApplication sharedApplication].delegate.window;
    [self showHUDInView:view];
}

+ (void)showHUDInView:(UIView *)inView {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:inView animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
}

+ (void)hideHUD {
    UIView *view = [UIApplication sharedApplication].delegate.window;
    [self hideHUDInView:view];
}

+ (void)hideHUDInView:(UIView *)inView {
    MBProgressHUD *hud = [MBProgressHUD HUDForView:inView];
    [hud hideAnimated:YES];
}

@end
