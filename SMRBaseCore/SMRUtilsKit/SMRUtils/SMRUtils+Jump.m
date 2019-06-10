//
//  SMRUtils+Jump.m
//  SMRBaseCoreDemo
//
//  Created by 丁治文 on 2019/3/26.
//  Copyright © 2019 sumrise. All rights reserved.
//

#import "SMRUtils+Jump.h"
#import "SMRRouterCenter+SMROpen.h"
#import "SMRWeb.h"
#import "SMRNavigator.h"

@implementation SMRUtils (Jump)

+ (void)jumpToAnyURL:(NSString *)url {
    SMRWebParameter *params = [[SMRWebParameter alloc] init];
    [self jumpToAnyURL:url webParameter:params forceToApp:YES];
}

+ (void)jumpToAnyURL:(NSString *)url webParameter:(SMRWebParameter *)webParameter {
    [self jumpToAnyURL:url webParameter:webParameter forceToApp:YES];
}

+ (void)jumpToAnyURL:(NSString *)url webParameter:(SMRWebParameter *)webParameter forceToApp:(BOOL)forceToApp {
    if (!url.length) {
        return;
    }
    // 为web链接
    if ([self checkWebURL:url]) {
        [self jumpToWeb:url webParameter:webParameter];
        return;
    }
    NSURL *jURL = [NSURL URLWithString:url];
    // 为navtive链接
    if ([SMRRouterCenter canResponseWithUrl:jURL]) {
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        params[@"webParameter"] = webParameter;
        [SMRRouterCenter openWithUrl:jURL params:params];
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

+ (void)jumpToWeb:(NSString *)url webParameter:(SMRWebParameter *)webParameter {
    [SMRWebController filterUrl:url completionBlock:^(NSString * _Nonnull url, BOOL allowLoad) {
        SMRWebController *web = [[SMRWebController alloc] init];
        web.url = url;
        web.webParameter = webParameter;
        [SMRNavigator pushOrPresentToViewController:web animated:YES];
    }];
    
}

+ (BOOL)checkWebURL:(NSString *)url {
    if ([url hasPrefix:@"http"]) {
        return YES;
    }
    return NO;
}

@end
