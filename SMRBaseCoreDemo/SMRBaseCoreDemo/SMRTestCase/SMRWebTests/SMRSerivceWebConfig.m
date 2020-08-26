//
//  SMRSerivceWebConfig.m
//  SMRBaseCoreDemo
//
//  Created by 丁治文 on 2019/5/22.
//  Copyright © 2019 sumrise. All rights reserved.
//

#import "SMRSerivceWebConfig.h"
#import "SMRAlert.h"
#import "SMRAppInfo.h"
#import "SMRPhoneInfo.h"
#import "SMRNetInfo.h"

@implementation SMRWebParameter

+ (instancetype)webNavigationViewTitle:(NSString *)navTitle {
    SMRWebParameter *webParameter = [[SMRWebParameter alloc] init];
    webParameter.navTitle = navTitle;
    return webParameter;
}

+ (instancetype)shareWithCanShare:(BOOL)canShare shareTitle:(NSString *)shareTitle shareSummary:(NSString *)shareSummary shareImageUrl:(NSString *)shareImageUrl shareUrl:(NSString *)shareUrl {
    SMRWebParameter *webParameter = [[SMRWebParameter alloc] init];
    webParameter.canShare = canShare;
    webParameter.shareTitle = shareTitle;
    webParameter.shareSummary = shareSummary;
    webParameter.shareImageUrl = shareImageUrl;
    webParameter.shareUrl = shareUrl;
    return webParameter;
}

@end

@interface SMRSerivceWebConfig ()

@property (weak  , nonatomic) SMRWebController *webController;

@end

@implementation SMRSerivceWebConfig

+ (instancetype)defaultConfig {
    static SMRSerivceWebConfig *config = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        config = [[SMRSerivceWebConfig alloc] init];
    });
    return config;
}

- (NSArray<SMRWKScriptMessageHandler *> *)messageHandlersWithWebController:(SMRWebController *)webController {
    self.webController = webController;
    return @[[self webShareHandler]];
}

/** js调用oc的分享 */
- (SMRWKScriptMessageHandler *)webShareHandler {
    SMRWKScriptMessageHandler *handler = [SMRWKScriptMessageHandler handlerWithWebController:self.webController name:@"native_share" recivedBlock:^(SMRWebController * _Nonnull webController, WKUserContentController * _Nonnull userContentController, WKScriptMessage * _Nonnull message) {
        __block WKWebView *webView = self.webController.webView;
        SMRAlertView *alert = [SMRAlertView alertViewWithContent:@"请分享"
                                                    buttonTitles:@[@"分享失败", @"分享成功"]
                                                   deepColorType:SMRAlertViewButtonDeepColorTypeSure];
        [alert show];
        alert.cancelButtonTouchedBlock = ^(id  _Nonnull maskView) {
            [maskView hide];
            NSString *callback = [NSString stringWithFormat:@"native_share_finished(%@)", @(0)];
            [webView evaluateJavaScript:callback completionHandler:^(id _Nullable obj, NSError * _Nullable error) {
                NSLog(@"finished0:%@", obj);
            }];
        };
        alert.sureButtonTouchedBlock = ^(id  _Nonnull maskView) {
            [maskView hide];
            NSString *callback = [NSString stringWithFormat:@"native_share_finished(%@)", @(1)];
            [webView evaluateJavaScript:callback completionHandler:^(id _Nullable obj, NSError * _Nullable error) {
                NSLog(@"finished1:%@", obj);
            }];
        };
    }];
    return handler;
}

- (BOOL)replaceUrl:(NSString *)url completionBlock:(void (^)(NSString * _Nonnull))completionBlock {
    // 获取cookie
//    [self.webController.webView evaluateJavaScript:@"document.cookie" completionHandler:^(id _Nullable obj, NSError * _Nullable error) {
//        NSLog(@"cookies:%@", obj);
//    }];
    return NO;
}

- (NSString *)customUserAgentWithWebController:(SMRWebController *)webController url:(NSURL *)url {
    return [SMRAppInfo webPureUserAgentByAppendings:@[[SMRPhoneInfo appUserAgent]]];
}

- (NSArray<NSHTTPCookie *> *)customUserCookiesWithWebController:(SMRWebController *)webController url:(NSURL *)url {
    if (!url.host) {
        return nil;
    }
    
    NSMutableDictionary *cookieProperties = [NSMutableDictionary dictionary];
    cookieProperties[NSHTTPCookieName] = @"name_test2";
    cookieProperties[NSHTTPCookieDomain] = @"/";
    cookieProperties[NSHTTPCookieValue] = @"aaaaaaaa";
    cookieProperties[NSHTTPCookiePath] = @"/";
    cookieProperties[NSHTTPCookieExpires] = [[NSDate date] dateByAddingTimeInterval:60*60*24];
    cookieProperties[NSHTTPCookieVersion] = @"1.0";
    NSHTTPCookie *cookieuser = [NSHTTPCookie cookieWithProperties:cookieProperties];
    
    NSMutableDictionary *cookieProperties2 = [NSMutableDictionary dictionary];
    cookieProperties2[NSHTTPCookieName] = @"name_test";
    cookieProperties2[NSHTTPCookieDomain] = @"/";
    cookieProperties2[NSHTTPCookieValue] = @"bbbbbbbb";
    cookieProperties2[NSHTTPCookiePath] = @"/";
    cookieProperties2[NSHTTPCookieExpires] = [[NSDate date] dateByAddingTimeInterval:60*60*24];
    cookieProperties2[NSHTTPCookieVersion] = @"1.0";
    NSHTTPCookie *cookieuser2 = [NSHTTPCookie cookieWithProperties:cookieProperties2];
    
    NSMutableDictionary *cookieProperties3 = [NSMutableDictionary dictionary];
    cookieProperties3[NSHTTPCookieName] = @"name_test3";
    cookieProperties3[NSHTTPCookieDomain] = @"/";
    cookieProperties3[NSHTTPCookieValue] = @"ccccccc";
    cookieProperties3[NSHTTPCookiePath] = @"/";
    cookieProperties3[NSHTTPCookieExpires] = [[NSDate date] dateByAddingTimeInterval:60*60*24];
    cookieProperties3[NSHTTPCookieVersion] = @"1.0";
    NSHTTPCookie *cookieuser3 = [NSHTTPCookie cookieWithProperties:cookieProperties3];
    
    return @[cookieuser, cookieuser2, cookieuser3];
}

- (void)customJSTextToInvokeWithWebController:(SMRWebController *)webController url:(NSURL *)url {
    WKWebView *webView = webController.webView;
    /** 给webView注入JS */
//    NSString *jsText = @"alert('js invoke here');";
//    [webView evaluateJavaScript:jsText completionHandler:^(id _Nullable result, NSError * _Nullable error) {
//        NSLog(@"JS注入结果:\n\tresult:%@\n\terror:%@", result, error);
//    }];
    // 获取userAgent
    [webView evaluateJavaScript:@"navigator.userAgent" completionHandler:^(id _Nullable obj, NSError * _Nullable error) {
        NSLog(@"userAgent:%@", obj);
    }];
    // 获取cookie
    [webView evaluateJavaScript:@"document.cookie" completionHandler:^(id _Nullable obj, NSError * _Nullable error) {
        NSLog(@"cookies:%@", obj);
    }];
}

@end
