//
//  SMRNavigator.m
//  SMRRouterDemo
//
//  Created by 丁治文 on 2018/10/2.
//  Copyright © 2018年 sumrise.com. All rights reserved.
//

#import "SMRNavigator.h"

@implementation SMRNavigator

+ (instancetype)sharedNavigator {
    static SMRNavigator *_sharedNavigator = nil;
    static dispatch_once_t onceTokenNavigator;
    dispatch_once(&onceTokenNavigator, ^{
        _sharedNavigator = [[SMRNavigator alloc] init];
    });
    return _sharedNavigator;
}

+ (void)resetToRootViewControllerWithCompletion:(void (^)(void))completion {
    UIViewController *krootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    [krootVC dismissViewControllerAnimated:NO completion:nil];
    if ([krootVC isKindOfClass:[UITabBarController class]]) {
        for (UINavigationController *nav in ((UITabBarController *)krootVC).viewControllers) {
            if ([nav isKindOfClass:[UINavigationController class]]) {
                [nav popToRootViewControllerAnimated:NO];
            }
        }
    } else if ([krootVC isKindOfClass:[UINavigationController class]]) {
        [(UINavigationController *)krootVC popToRootViewControllerAnimated:NO];
    }
    if (completion) {
        completion();
    }
}

+ (UIViewController *)getMainwindowTopController {
    UIViewController *resultVC;
    resultVC = [self p_topViewController:[[UIApplication sharedApplication].delegate.window rootViewController]];
    while (resultVC.presentedViewController) {
        resultVC = [self p_topViewController:resultVC.presentedViewController];
    }
    SMRNavigator *navigator = [SMRNavigator sharedNavigator];
    if (navigator.mainwindowRootControllerBlock) {
        resultVC = navigator.mainwindowRootControllerBlock(resultVC);
    }
    return resultVC;
}

+ (UIViewController *)getKeywindowRootController {
    SMRNavigator *navigator = [SMRNavigator sharedNavigator];
    if (navigator.keywindowRootControllerBlock) {
        return navigator.keywindowRootControllerBlock();
    } else {
        return [self p_keywindowRootViewController];
    }
}
+ (UITabBarController *)getRootTabbarController {
    SMRNavigator *navigator = [SMRNavigator sharedNavigator];
    if (navigator.rootTabbarControllerBlock) {
        return navigator.rootTabbarControllerBlock();
    } else {
        return [self p_rootTabbarController];
    }
}
+ (UINavigationController *)getRootTabNavigationControllerWithTab:(NSInteger)tab {
    SMRNavigator *navigator = [SMRNavigator sharedNavigator];
    if (navigator.rootTabNavigationControllerBlock) {
        return navigator.rootTabNavigationControllerBlock(tab);
    } else {
        return [self p_rootTabNavigationControllerWithTab:tab forceSeleceted:NO];
    }
}
+ (UINavigationController *)changeRootTabNavigationControllerWithTab:(NSInteger)tab {
    SMRNavigator *navigator = [SMRNavigator sharedNavigator];
    if (navigator.changeRootTabNavigationControllerBlock) {
        return navigator.changeRootTabNavigationControllerBlock(tab);
    } else {
        return [self p_rootTabNavigationControllerWithTab:tab forceSeleceted:YES];
    }
}

/// private
+ (UIViewController *)p_topViewController:(UIViewController *)vc {
    if ([vc isKindOfClass:[UINavigationController class]]) {
        return [self p_topViewController:[(UINavigationController *)vc topViewController]];
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        return [self p_topViewController:[(UITabBarController *)vc selectedViewController]];
    } else {
        return vc;
    }
    return nil;
}

/// private
+ (__kindof UIViewController *)p_keywindowRootViewController {
    UIViewController *result;
    // Try to find the root view controller programmically
    // Find the top window (that is not an alert view or other window)
    UIWindow *topWindow = [[UIApplication sharedApplication] keyWindow];
    if (!topWindow || topWindow.windowLevel != UIWindowLevelNormal) {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(topWindow in windows) {
            if (topWindow.windowLevel == UIWindowLevelNormal) break;
        }
    }
    
    UIView *rootView = [topWindow subviews].firstObject;
    id nextResponder = [rootView nextResponder];
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else if ([topWindow respondsToSelector:@selector(rootViewController)] && topWindow.rootViewController != nil)
        result = topWindow.rootViewController;
    else
        NSAssert(NO, @"keyWindow上未找到root.");
    return result;
}
+ (UITabBarController *)p_rootTabbarController {
    UITabBarController *root = [self p_keywindowRootViewController];
    if (root && [root isKindOfClass:[UITabBarController class]]) {
        return root;
    } else {
        return nil;
    }
}
+ (UINavigationController *)p_rootTabNavigationControllerWithTab:(NSInteger)tab forceSeleceted:(BOOL)forceSeleceted {
    UITabBarController *tabbar = [self p_rootTabbarController];
    UINavigationController *root = nil;
    NSArray *roots = tabbar.viewControllers;
    if (roots && (roots.count > tab)) {
        if (forceSeleceted) {
            tabbar.selectedIndex = tab;
        }
        root = roots[tab];
        if (root && [root isKindOfClass:[UINavigationController class]]) {
            return root;
        } else {
            return nil;
        }
    } else {
        return nil;
    }
}

+ (BOOL)pushOrPresentToMainTabViewController:(UIViewController *)controller animated:(BOOL)animated tab:(NSInteger)tab {
    UIViewController *main = [SMRNavigator getRootTabNavigationControllerWithTab:tab];
    if (main) {
        [SMRNavigator resetToRootViewControllerWithCompletion:nil];
        return (BOOL)[SMRNavigator changeRootTabNavigationControllerWithTab:tab];
    } else {
        return [SMRNavigator pushOrPresentToViewController:controller animated:animated];
    }
}
+ (BOOL)pushOrPresentToViewController:(UIViewController *)viewController animated:(BOOL)animated {
    UIViewController *base = [SMRNavigator getMainwindowTopController];
    return [self pushOrPresentToViewController:viewController baseController:base.navigationController?:base animated:YES];
}
+ (BOOL)pushOrPresentToViewController:(UIViewController *)viewController baseController:(UIViewController *)baseController animated:(BOOL)animated {
    if ([self pushToViewController:viewController baseController:(UINavigationController *)baseController animated:animated]) {
        return YES;
    }
    if ([self presentToViewController:viewController baseController:baseController animated:animated]) {
        return YES;
    }
    return NO;
}
+ (BOOL)pushToViewController:(UIViewController *)viewController baseController:(UINavigationController *)baseController animated:(BOOL)animated {
    if (!viewController || ![viewController isKindOfClass:[UIViewController class]] ||
        !baseController || ![baseController isKindOfClass:[UINavigationController class]]) {
        return NO;
    }
    [baseController pushViewController:viewController animated:animated];
    return YES;
}
+ (BOOL)presentToViewController:(UIViewController *)viewController baseController:(UIViewController *)baseController animated:(BOOL)animated {
    if (!viewController || ![viewController isKindOfClass:[UIViewController class]] ||
        !baseController || ![baseController isKindOfClass:[UIViewController class]]) {
        return NO;
    }
    [baseController presentViewController:viewController animated:animated completion:nil];
    return YES;
}

+ (void)popOrDismissViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (!viewController) {
        return;
    }
    if (viewController.navigationController && (viewController.navigationController.viewControllers.count > 1)){
        [viewController.navigationController popViewControllerAnimated:animated];
    } else {
        [viewController dismissViewControllerAnimated:animated completion:nil];
    }
}

@end
