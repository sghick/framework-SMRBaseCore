//
//  SMRTarget.m
//  SMRRouterDemo
//
//  Created by 丁治文 on 2018/10/4.
//  Copyright © 2018年 sumrise.com. All rights reserved.
//

#import "SMRTarget.h"
#import "SMRNavigator.h"
#import "SMRRouterCenter.h"

@implementation SMRTarget

/// excute any
- (id)action:(NSDictionary *)params {
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
        NSLog(@"unknow obj class or selector:%@,%@", obj_class, selector);
        return nil;
    }
}

- (void)actionOpen:(NSDictionary *)params {
    id obj = [self action:params];
    if ([obj isKindOfClass:[UIViewController class]]) {
        UIViewController *controller = (UIViewController *)obj;
        [SMRNavigator pushOrPresentToViewController:controller animated:YES];
    } else {
        NSLog(@"unknow view controller to open");
    }
}

@end


#pragma mark - SMROpen

NSString * const k_perform_open = @"k_perform_open";
@implementation SMRTarget (SMROpen)

- (void)supportedActionWithParams:(NSDictionary *)params
                 toOpenController:(UIViewController *)controller
                  openActionBlock:(void (^)(UIViewController *))openActionBlock
              openPathActionBlock:(void (^)(UIViewController *))openPathActionBlock {
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

@end


#pragma mark - SMRLastURL

NSString * const k_perform_last_url = @"k_perform_last_url";
@implementation SMRTarget (SMRLastURL)

- (void)supportedLastURLActionWithParams:(NSDictionary *)params {
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
- (void)supportedResetRoot:(NSDictionary *)params {
    // 如果传了tab参数,则进行tab切换
    NSString *tab = params[k_change_tab];
    if (tab) {
        [SMRNavigator resetToRootViewControllerWithCompletion:nil];
        [SMRNavigator changeRootTabNavigationControllerWithTab:tab.intValue];
    }
}

@end
