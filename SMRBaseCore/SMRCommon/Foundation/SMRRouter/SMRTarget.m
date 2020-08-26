//
//  SMRTarget.m
//  SMRRouterDemo
//
//  Created by 丁治文 on 2018/12/14.
//  Copyright © 2018 sumrise. All rights reserved.
//

#import "SMRTarget.h"
#import "SMRNavigator.h"
#import "SMRRouterCenter.h"
#import "SMRLog.h"

@implementation SMRTarget

/// excute any
- (id)action:(nullable NSDictionary *)params {
    NSString *obj_class = params[@"obj_class"];
    NSString *selector = params[@"selector"];
    NSArray *selector_params = [params[@"selector_params"] componentsSeparatedByString:@","];
    
    Class cls = NSClassFromString(obj_class);
    SEL sel = NSSelectorFromString(selector);
    NSMethodSignature *signature = [cls instanceMethodSignatureForSelector:sel];
    if (signature != nil) {
        NSObject *obj = [[cls alloc] init];
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
        [invocation setTarget:obj];
        [invocation setSelector:sel];
        
        // 必须从2开始，原因为：0 1 两个参数已经被target 和selector占用
        if (selector_params.count > 0) {
            for (int i = 0; i < selector_params.count; i++) {
                id param = selector_params[i];
                [invocation setArgument:&param atIndex:(i + 2)];
            }
        }
        [invocation retainArguments];
        [invocation invoke];
        return obj;
    } else {
        base_core_warning_log(@"unknow obj class or selector:%@,%@", obj_class, selector);
        return nil;
    }
}

- (void)actionOpen:(nullable NSDictionary *)params {
    id obj = [self action:params];
    if ([obj isKindOfClass:[UIViewController class]]) {
        UIViewController *controller = (UIViewController *)obj;
        [SMRNavigator pushOrPresentToViewController:controller animated:YES];
    } else {
        base_core_warning_log(@"unknow view controller to open");
    }
}

@end


#pragma mark - SMROpen

NSString * const k_perform_open = @"k_perform_open";
@implementation SMRTarget (SMROpen)

- (void)supportedActionWithParams:(nullable NSDictionary *)params
                 toOpenController:(nullable UIViewController *)controller
                  openActionBlock:(nullable void (^)(UIViewController *))openActionBlock
              openPathActionBlock:(nullable void (^)(UIViewController *))openPathActionBlock {
    NSString *supported = params[k_perform_open];
    switch (supported.integerValue) {
        case SMRTargetOpenTypeOpen: {
            if (openActionBlock) {
                openActionBlock(controller);
            } else {
                [SMRNavigator pushOrPresentToViewController:controller animated:YES];
            }
        }
            break;
        case SMRTargetOpenTypeOpenPath: {
            if (openPathActionBlock) {
                openPathActionBlock(controller);
            } else {
                [SMRNavigator pushOrPresentToViewController:controller animated:YES];
            }
        }
            break;
            
        default:
            break;
    }
}

- (void)supportedActionWithParams:(nullable NSDictionary *)params
                      toChangeTab:(NSInteger)toChangeTab
                 toOpenController:(nullable UIViewController *)controller
                  openActionBlock:(nullable void (^)(UIViewController *))openActionBlock
              openPathActionBlock:(nullable void (^)(UIViewController *))openPathActionBlock {
    [self supportedActionWithParams:params
                   toOpenController:controller
                    openActionBlock:^(UIViewController *controller) {
                        UINavigationController *main = [SMRNavigator getRootTabNavigationControllerWithTab:toChangeTab];
                        if (main) {
                            // 如果目前控制器存在于目标Tab中,并且为栈顶,直接切换;否则,强行重置切换至对应Tab,并在当前tab打开目标控制器
                            BOOL condition = [main.viewControllers.firstObject isKindOfClass:controller.class];
                            [self p_changeTabIfCondition:condition
                                             toChangeTab:toChangeTab
                                              forceReset:YES controller:controller
                                               openBlock:openActionBlock];
                        } else {
                            // 不切换Tab,仅在当前位置直接打开目标控制器
                            [self p_changeTabIfCondition:NO
                                             toChangeTab:-1
                                              forceReset:NO controller:controller
                                               openBlock:openActionBlock];
                        }
                    }
                openPathActionBlock:^(UIViewController *controller) {
                    UINavigationController *main = [SMRNavigator getRootTabNavigationControllerWithTab:toChangeTab];
                    if (main) {
                        // 如果目前控制器存在于目标Tab中,并且为栈顶,直接切换;否则,强行重置切换至对应Tab,并在当前tab打开目标控制器
                        BOOL condition = [main.viewControllers.firstObject isKindOfClass:controller.class];
                        [self p_changeTabIfCondition:condition
                                         toChangeTab:toChangeTab
                                          forceReset:YES controller:controller
                                           openBlock:openPathActionBlock];
                    } else {
                        // 不切换Tab,仅在当前位置直接打开目标控制器
                        [self p_changeTabIfCondition:NO
                                         toChangeTab:-1
                                          forceReset:NO controller:controller
                                           openBlock:openPathActionBlock];
                    }
                }];
}

- (void)supportedMainTabActionWithParams:(nullable NSDictionary *)params
                             toChangeTab:(NSInteger)toChangeTab
                        toOpenController:(nullable UIViewController *)controller
                         openActionBlock:(nullable void (^)(UIViewController *))openActionBlock
                     openPathActionBlock:(nullable void (^)(UIViewController *))openPathActionBlock {
    [self supportedActionWithParams:params
                   toOpenController:controller
                    openActionBlock:^(UIViewController *controller) {
                        // 如果目前控制器存在于目标Tab中,直接切换;否则,不切换Tab,仅在当前位置直接打开目标控制器
                        UIViewController *main = [SMRNavigator getRootTabNavigationControllerWithTab:toChangeTab];
                        [self p_changeTabIfCondition:(BOOL)main
                                         toChangeTab:toChangeTab
                                          forceReset:NO controller:controller
                                           openBlock:openActionBlock];
                    }
                openPathActionBlock:^(UIViewController *controller) {
                    // 如果目前控制器存在于目标Tab中,直接切换;否则,不切换Tab,仅在当前位置直接打开目标控制器
                    UIViewController *main = [SMRNavigator getRootTabNavigationControllerWithTab:toChangeTab];
                    [self p_changeTabIfCondition:(BOOL)main
                                     toChangeTab:toChangeTab
                                      forceReset:NO controller:controller
                                       openBlock:openPathActionBlock];
                }];
}

- (void)p_changeTabIfCondition:(BOOL)condition
                   toChangeTab:(NSInteger)toChangeTab
                    forceReset:(BOOL)forceReset
                    controller:(nullable UIViewController *)controller
                     openBlock:(nullable void (^)(UIViewController *controller))openBlock {
    if (condition) {
        [SMRNavigator resetToRootViewControllerWithCompletion:nil];
        [SMRNavigator changeRootTabNavigationControllerWithTab:toChangeTab];
    } else {
        if (openBlock) {
            openBlock(controller);
        } else {
            if (forceReset) {
                [SMRNavigator resetToRootViewControllerWithCompletion:nil];
                [SMRNavigator changeRootTabNavigationControllerWithTab:toChangeTab];
            }
            [SMRNavigator pushOrPresentToViewController:controller animated:YES];
        }
    }
}

@end


#pragma mark - SMRLastURL

NSString * const k_perform_last_url = @"k_perform_last_url";
@implementation SMRTarget (SMRLastURL)

- (void)supportedLastURLActionWithParams:(nullable NSDictionary *)params {
    NSString *lastUrl = params[k_perform_last_url];
    NSURL *url = [NSURL URLWithString:lastUrl];
    if (url) {
        [SMRRouterCenter performWithUrl:url params:nil];
    }
}

@end


#pragma mark - SMRChangeTab

NSString * const k_change_tab = @"k_change_tab";

@implementation SMRTarget (SMRChangeTab)
- (void)supportedResetRoot:(nullable NSDictionary *)params {
    // 如果传了tab参数,则进行tab切换
    NSString *tab = params[k_change_tab];
    if (tab) {
        [SMRNavigator resetToRootViewControllerWithCompletion:nil];
        [SMRNavigator changeRootTabNavigationControllerWithTab:tab.intValue];
    }
}

@end

