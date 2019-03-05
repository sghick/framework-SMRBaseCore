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

- (void)toast:(NSString *)toast {
    if (!toast.length) {
        return;
    }
    UIView *view = [SMRNavigator getMainwindowTopController].view.window;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.label.text = toast;
    hud.offset = CGPointMake(0.f, MBProgressMaxOffset);
    [hud hideAnimated:YES afterDelay:2.f];
}

- (void)showHUD {
    UIView *view = [SMRNavigator getMainwindowTopController].view.window;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
}

- (void)hideHUD {
    UIView *view = [SMRNavigator getMainwindowTopController].view.window;
    MBProgressHUD *hud = [MBProgressHUD HUDForView:view];
    if (!hud) {
        hud = [MBProgressHUD HUDForView:view.window];
    }
    [hud hideAnimated:YES];
}

@end
