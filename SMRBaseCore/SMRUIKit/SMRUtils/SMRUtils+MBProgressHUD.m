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

@interface MBProgressHUD ()

- (MBProgressHUD *)smr_HUDForView;
- (BOOL)hasFinished;

@end

static NSInteger kTagForHUD = 599036;

@implementation MBProgressHUD (SMR)

+ (instancetype)smr_showHUDAddedTo:(UIView *)view animated:(BOOL)animated {
    MBProgressHUD *hud = [self smr_HUDForView:view];
    hud = hud ?: [self showHUDAddedTo:view animated:animated];
    hud.tag = kTagForHUD;
    return hud;
}

+ (MBProgressHUD *)smr_HUDForView:(UIView *)view {
    NSEnumerator *subviewsEnum = [view.subviews reverseObjectEnumerator];
    for (UIView *subview in subviewsEnum) {
        if ([subview isKindOfClass:self]) {
            MBProgressHUD *hud = (MBProgressHUD *)subview;
            if ((hud.tag == kTagForHUD) && (hud.hasFinished == NO)) {
                return hud;
            }
        }
    }
    return nil;
}

@end

@implementation SMRUtils (MBProgressHUD)

+ (void)toast:(NSString *)toast {
    [self toast:toast inView:nil];
}

+ (void)toast:(NSString *)toast inView:(UIView *)inView {
    if (!toast.length) {
        return;
    }
    UIView *view = inView ?: [UIApplication sharedApplication].delegate.window;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.label.numberOfLines = 0;
    hud.label.text = toast;
    hud.userInteractionEnabled = NO;
    [hud hideAnimated:YES afterDelay:2.f];
}

+ (void)showHUD {
    [self showHUDWithTitle:nil inView:nil];
}

+ (void)showHUDInView:(UIView *)inView {
    [self showHUDWithTitle:nil inView:inView];
}

+ (void)showHUDWithTitle:(NSString *)title {
    [self showHUDWithTitle:title inView:nil];
}

+ (void)showHUDWithTitle:(NSString *)title inView:(UIView *)inView {
    UIView *view = inView ?: [UIApplication sharedApplication].delegate.window;
    MBProgressHUD *hud = [MBProgressHUD smr_showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.label.text = title;
}

+ (void)hideHUD {
    [self hideHUDInView:nil];
}

+ (void)hideHUDInView:(UIView *)inView {
    UIView *view = inView ?: [UIApplication sharedApplication].delegate.window;
    MBProgressHUD *hud = [MBProgressHUD smr_HUDForView:view];
    [hud hideAnimated:YES];
}

@end
