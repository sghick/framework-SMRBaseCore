//
//  SMRUtils+Jump.m
//  SMRBaseCoreDemo
//
//  Created by 丁治文 on 2019/3/26.
//  Copyright © 2019 sumrise. All rights reserved.
//

#import "SMRUtils+Jump.h"
#import "SMRRouterCenter+SMROpen.h"
#import "SMRWebController.h"
#import "SMRNavigator.h"

@implementation SMRUtils (Jump)

+ (void)jumpToAnyURL:(NSString *)url {
    [self jumpToAnyURL:url webTitle:nil forceToApp:YES];
}

+ (void)jumpToAnyURL:(NSString *)url webTitle:(NSString *)webTitle forceToApp:(BOOL)forceToApp {
    if (!url.length) {
        return;
    }
    // 为web链接
    if ([self checkWebURL:url]) {
        [self jumpToWeb:url title:webTitle];
        return;
    }
    NSURL *jURL = [NSURL URLWithString:url];
    // 为navtive链接
    if ([SMRRouterCenter canResponseWithUrl:jURL]) {
        [SMRRouterCenter openWithUrl:jURL params:nil];
        return;
    }
    // 为其它链接
    if (!forceToApp && [[UIApplication sharedApplication] canOpenURL:jURL]) {
        [[UIApplication sharedApplication] openURL:jURL];
        return;
    } else {
        [[UIApplication sharedApplication] openURL:jURL];
        return;
    }
}

+ (void)jumpToWeb:(NSString *)url title:(nullable NSString *)title {
    [SMRWebController pushWithURL:url title:title];
}

+ (BOOL)checkWebURL:(NSString *)url {
    if ([url hasPrefix:@"http"]) {
        return YES;
    }
    return NO;
}

@end
