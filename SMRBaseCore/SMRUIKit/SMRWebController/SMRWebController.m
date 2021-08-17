//
//  SMRWebController.m
//  SMRBaseCoreDemo
//
//  Created by Tinswin on 2019/2/15.
//  Copyright © 2019年 sumrise. All rights reserved.
//

#import "SMRWebController.h"
#import <WebKit/WebKit.h>
#import "SMRAdapter.h"
#import "SMRRouterCenter+SMROpen.h"
#import "SMRWebConfig.h"
#import "NSURL+BaseCore.h"

/** 允许所有请求通过 */
@implementation NSURLRequest (SMRWebViewController)

+ (BOOL)allowsAnyHTTPSCertificateForHost:(NSString *)host {
    return YES;
}

@end

@implementation NSHTTPCookie (SMRWebViewController)

- (NSString *)javaScriptValue {
    NSMutableArray<NSString *> *pairs = [NSMutableArray array];
    NSMutableDictionary *dict = [self.properties mutableCopy];
    dict[dict[NSHTTPCookieName]] = dict[NSHTTPCookieValue];
    dict[NSHTTPCookieName] = nil;
    dict[NSHTTPCookieValue] = nil;
    [dict enumerateKeysAndObjectsUsingBlock:^(NSHTTPCookiePropertyKey  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [pairs addObject:[NSString stringWithFormat:@"%@=%@", key, obj]];
    }];
    return [NSString stringWithFormat:@"document.cookie='%@", [pairs componentsJoinedByString:@";"]];
}

+ (NSString *)javaScriptValueWithCookies:(NSArray<NSHTTPCookie *> *)cookies {
    if (!cookies.count) {
        return nil;
    }
    NSString *str = @"";
    for (NSHTTPCookie *cookie in cookies) {
        str = [str stringByAppendingString:[cookie javaScriptValue]];
    }
    return str;
}

@end

@implementation SMRWebControllerParameter

@end

@interface SMRWebController () <
WKUIDelegate,
WKNavigationDelegate>

@property (strong, nonatomic) NSArray<SMRWKScriptMessageHandler *> *messageHandlers;

@end

@implementation SMRWebController

@synthesize webView = _webView;
@synthesize progressView = _progressView;
@synthesize config = _config;
@synthesize userController = _userController;

- (void)dealloc {
    [self removeScriptMessageHandlers];
    [self removeObserverForProperties];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self addObserverForProperties];
        [self addScriptMessageHandlers];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.webView];
    [self.view addSubview:self.progressView];
    self.navigationView.title = self.webParameter.navTitle;
    [self reloadWeb];
    
    id<SMRWebNavigationViewConfig> navigationViewConfig = [SMRWebConfig shareConfig].webNavigationViewConfig;
    if ([navigationViewConfig respondsToSelector:@selector(webViewDidLoad:)]) {
        [navigationViewConfig webViewDidLoad:self];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    id<SMRWebNavigationViewConfig> navigationViewConfig = [SMRWebConfig shareConfig].webNavigationViewConfig;
    if ([navigationViewConfig respondsToSelector:@selector(webViewWillAppear:)]) {
        [navigationViewConfig webViewWillAppear:self];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    id<SMRWebNavigationViewConfig> navigationViewConfig = [SMRWebConfig shareConfig].webNavigationViewConfig;
    if ([navigationViewConfig respondsToSelector:@selector(webViewWillDisappear:)]) {
        [navigationViewConfig webViewWillDisappear:self];
    }
}

- (SMRNavigationView *)navigationViewInitialization {
    id<SMRWebNavigationViewConfig> navigationViewConfig = [SMRWebConfig shareConfig].webNavigationViewConfig;
    if ([navigationViewConfig respondsToSelector:@selector(navigationViewOfWebController:)]) {
        return [navigationViewConfig navigationViewOfWebController:self];
    }
    return [super navigationViewInitialization];
}

- (void)navigationView:(SMRNavigationView *)nav didBackBtnTouched:(UIButton *)sender {
    if (self.webView.canGoBack) {
        [self.webView goBack];
    } else {
        [super navigationView:nav didBackBtnTouched:sender];
    }
}

- (void)navigationView:(SMRNavigationView *)nav didCloseBtnTouched:(UIButton *)sender {
    [super navigationView:nav didBackBtnTouched:sender];
}

#pragma mark - Observer

- (void)removeObserverForProperties {
    [_webView removeObserver:self forKeyPath:NSStringFromSelector(@selector(canGoBack))];
    [_webView removeObserver:self forKeyPath:@"estimatedProgress"];
    [_webView removeObserver:self forKeyPath:@"title"];
}

- (void)addObserverForProperties {
    [self.webView addObserver:self forKeyPath:NSStringFromSelector(@selector(canGoBack)) options:NSKeyValueObservingOptionNew context:nil];
    [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:nil];
    [self.webView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:NSStringFromSelector(@selector(canGoBack))] && object == self.webView) {
        NSNumber *canGoBack = change[NSKeyValueChangeNewKey];
        if (self.isMainPage) {
            self.navigationView.backBtnHidden = !canGoBack.boolValue;
        } else {
            self.navigationView.closeBtnShow = canGoBack.boolValue;
        }
        if (self.isMainPage && self.autoAdjustTabBarByMainPage) {
            if (canGoBack.boolValue) {
                // 自动隐藏TabBar
                [UIView animateWithDuration:0.25 animations:^{
                    self.tabBarController.tabBar.top = SCREEN_HEIGHT;
                }];
                // Web设置全屏
                CGFloat webHeight = SCREEN_HEIGHT - self.navigationView.bottom - BOTTOM_HEIGHT;
                self.webView.frame = CGRectMake(0, self.navigationView.bottom, SCREEN_WIDTH, webHeight);
            } else {
                // 自动显示TabBar
                [UIView animateWithDuration:0.25 animations:^{
                    self.tabBarController.tabBar.top = SCREEN_HEIGHT - BOTTOMWITHTABBAR_HEIGHT;
                }];
                // Web设置非全屏
                CGFloat webHeight = SCREEN_HEIGHT - self.navigationView.bottom - BOTTOMWITHTABBAR_HEIGHT;
                self.webView.frame = CGRectMake(0, self.navigationView.bottom, SCREEN_WIDTH, webHeight);
            }
        }
    } else if ([keyPath isEqual:@"estimatedProgress"] && object == self.webView) {
        if (!self.progressViewHidden) {
            self.progressView.hidden = NO;
        }
        [self.progressView setProgress:self.webView.estimatedProgress animated:YES];
        if (self.webView.estimatedProgress  >= 1.0f) {
            [self p_hiddenProgressView];
        }
    } else if ([keyPath isEqual:@"title"] && object == self.webView) {
        self.title = self.webView.title;
    } else{
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark - JS-Native(交互相关,注册js方法,以便web通过js调用)

/// 添加需要交互使用的方法的方法名
- (void)addScriptMessageHandlers {
    [self removeScriptMessageHandlers];
    
    if ([[SMRWebConfig shareConfig].webJSRegisterConfig respondsToSelector:@selector(messageHandlersWithWebController:)]) {
        self.messageHandlers = [[SMRWebConfig shareConfig].webJSRegisterConfig messageHandlersWithWebController:self];
    }
    for (SMRWKScriptMessageHandler *handler in self.messageHandlers) {
        [self.userController addScriptMessageHandler:handler name:handler.name];
    }
}

/// 移除需要交互使用的方法的方法名
- (void)removeScriptMessageHandlers {
    for (SMRWKScriptMessageHandler *handler in self.messageHandlers) {
        [self.userController removeScriptMessageHandlerForName:handler.name];
    }
}

#pragma mark - URLReplace

#pragma mark - UserAgent

- (NSString *)userAgentWithWebView:(WKWebView *)webView url:(NSURL *)url {
    id<SMRWebReplaceConfig> replaceConfig = [SMRWebConfig shareConfig].webReplaceConfig;
    if ([replaceConfig respondsToSelector:@selector(customUserAgentWithWebController:url:)]) {
        return [replaceConfig customUserAgentWithWebController:self url:url];
    }
    return nil;
}

- (void)p_fillUserAgentWithWebView:(WKWebView *)webView url:(NSURL *)url {
    id<SMRWebReplaceConfig> replaceConfig = [SMRWebConfig shareConfig].webReplaceConfig;
    if ([replaceConfig respondsToSelector:@selector(customUserAgentWithWebController:url:)]) {
        NSString *userAgent = [replaceConfig customUserAgentWithWebController:self url:url];
        if (userAgent) {
            // >= iOS9,设置UA
            if (@available(iOS 9.0, *)) {
                webView.customUserAgent = userAgent;
            } else {
                // Fallback on earlier versions
                [[NSUserDefaults standardUserDefaults] registerDefaults:@{@"UserAgent":userAgent}];
            }
        }
    }
}

#pragma mark - Cookies

- (NSArray<NSHTTPCookie *> *)userCookiesWithWebView:(WKWebView *)webView url:(NSURL *)url {
    id<SMRWebReplaceConfig> replaceConfig = [SMRWebConfig shareConfig].webReplaceConfig;
    if ([replaceConfig respondsToSelector:@selector(customUserCookiesWithWebController:url:)]) {
        return [replaceConfig customUserCookiesWithWebController:self url:url];
    }
    return nil;
}

- (void)p_fillUserCookiesWithWebView:(WKWebView *)webView request:(NSMutableURLRequest *)request {
    NSArray<NSHTTPCookie *> *cookies = [self userCookiesWithWebView:webView url:request.URL];
    NSDictionary *cookieHeaders = [NSHTTPCookie requestHeaderFieldsWithCookies:cookies];
    [cookieHeaders enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [request addValue:obj forHTTPHeaderField:key];
    }];
    
    // 将cookie保存在NSHTTPCookieStorage中
    NSHTTPCookieStorage *cookieStore = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    [cookies enumerateObjectsUsingBlock:^(NSHTTPCookie * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [cookieStore setCookie:obj];
    }];
    
//    // 给webView注入cookie
//    if (@available(iOS 11.0, *)) {
//        WKHTTPCookieStore *cookieStore = self.webView.configuration.websiteDataStore.httpCookieStore;
//        [cookies enumerateObjectsUsingBlock:^(NSHTTPCookie * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//            [cookieStore setCookie:obj completionHandler:nil];
//        }];
//    } else {
//        NSDictionary *cookieHeaders = [NSHTTPCookie requestHeaderFieldsWithCookies:cookies];
//        [cookieHeaders enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
//            [request addValue:obj forHTTPHeaderField:key];
//        }];
//    }
}

- (void)p_fillUserCookiesWithWebView:(WKWebView *)webView url:(NSURL *)url content:(WKUserContentController *)content {
    NSArray<NSHTTPCookie *> *cookies = [self userCookiesWithWebView:webView url:url];
    /** 给webView注入cookie */
    NSString *cookieStr = [NSHTTPCookie javaScriptValueWithCookies:cookies];
    WKUserScript *cookieScript = [[WKUserScript alloc] initWithSource:cookieStr injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:NO];
    [content addUserScript:cookieScript];
}

- (BOOL)p_canLoadRequest:(NSURLRequest *)request {
    id<SMRWebNavigationViewConfig> navigationViewConfig = [SMRWebConfig shareConfig].webNavigationViewConfig;
    if ([navigationViewConfig respondsToSelector:@selector(canLoadRequest:web:)]) {
        return [navigationViewConfig canLoadRequest:request web:self];
    }
    return YES;
}

#pragma mark - JSInvoke

- (void)p_fillJSWithWebView:(WKWebView *)webView url:(NSURL *)url {
    id<SMRWebReplaceConfig> replaceConfig = [SMRWebConfig shareConfig].webReplaceConfig;
    if ([replaceConfig respondsToSelector:@selector(customJSTextToInvokeWithWebController:url:)]) {
        [replaceConfig customJSTextToInvokeWithWebController:self url:url];
    }
}

#pragma mark - WKNavigationDelegate

/**
 在发送请求之前，决定是否跳转(1)
 */
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    // web回调
    id<SMRWebNavigationViewConfig> navigationViewConfig = [SMRWebConfig shareConfig].webNavigationViewConfig;
    if ([navigationViewConfig respondsToSelector:@selector(webView:decidePolicyForNavigationAction:decisionHandler:)]) {
        [navigationViewConfig webView:webView decidePolicyForNavigationAction:navigationAction decisionHandler:decisionHandler];
    }
    
    NSURL *url = navigationAction.request.URL;
    // 设置UA
    [self p_fillUserAgentWithWebView:webView url:url];
    // 加载cookie
//    // 通过 document.cookie 设置 Cookie 解决后续页面(同域)Ajax、iframe 请求的 Cookie 问题; [document.cookie()无法跨域设置 cookie]
//    [self p_fillUserCookiesWithWebView:webView url:url content:self.userController];
    
    // 替换参数
    id<SMRWebReplaceConfig> replaceConfig = [SMRWebConfig shareConfig].webReplaceConfig;
    if ([replaceConfig respondsToSelector:@selector(replaceUrl:completionBlock:)]) {
        if ([replaceConfig replaceUrl:url.absoluteString completionBlock:^(NSString * _Nonnull url) {
            NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL smr_URLWithString:url]];
            if ([self p_canLoadRequest:request]) {
                [webView loadRequest:request];
            }
        }] == YES) {
            decisionHandler(WKNavigationActionPolicyCancel);
            return;
        } else {
            // 没有做参数的替换,可以继续往下执行
        }
    }
    
    // 为web链接
    if ([url.absoluteString hasPrefix:@"http"]) {
        decisionHandler(WKNavigationActionPolicyAllow);
        return;
    }
    
    // 为navtive链接
    if ([SMRRouterCenter canResponseWithUrl:url]) {
        // 判断如果当前返回栈中无内容(302跳转不会入栈),则关闭当前web
        if (!webView.backForwardList.currentItem) {
            [self popOrDismissViewControllerAnimated:NO];
        }
        [SMRRouterCenter openWithUrl:url params:nil];
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }
    
    // 为其它链接(跳转打电话、AppStore等)
    if ([[UIApplication sharedApplication] openURL:url]) {
        // 判断如果当前返回栈中无内容(302跳转不会入栈),则关闭当前web
        if (!webView.backForwardList.currentItem) {
            [self popOrDismissViewControllerAnimated:NO];
        }
        decisionHandler(WKNavigationActionPolicyCancel);
    } else {
        decisionHandler(WKNavigationActionPolicyAllow);
    }
}

/**
 页面开始加载(2)
*/
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    if (!self.progressViewHidden) {
        self.progressView.hidden = NO;
    }
    // web回调
    id<SMRWebNavigationViewConfig> navigationViewConfig = [SMRWebConfig shareConfig].webNavigationViewConfig;
    if ([navigationViewConfig respondsToSelector:@selector(webView:didStartProvisionalNavigation:)]) {
        [navigationViewConfig webView:webView didStartProvisionalNavigation:navigation];
    }
}

/**
 在收到响应后，决定是否跳转(3)
 */
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler {
    id<SMRWebNavigationViewConfig> navigationViewConfig = [SMRWebConfig shareConfig].webNavigationViewConfig;
    if ([navigationViewConfig respondsToSelector:@selector(webView:decidePolicyForNavigationResponse:decisionHandler:)]) {
        [navigationViewConfig webView:webView decidePolicyForNavigationResponse:navigationResponse decisionHandler:decisionHandler];
    } else {
        decisionHandler(WKNavigationResponsePolicyAllow);
    }
}

/**
 当内容开始返回(4)
 */
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
    id<SMRWebNavigationViewConfig> navigationViewConfig = [SMRWebConfig shareConfig].webNavigationViewConfig;
    if ([navigationViewConfig respondsToSelector:@selector(webView:didCommitNavigation:)]) {
        [navigationViewConfig webView:webView didCommitNavigation:navigation];
    }
}

/**
 页面加载完成(5)
 */
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [self p_hiddenProgressView];
    // JS注入时机
    [self p_fillJSWithWebView:webView url:webView.URL];
    // web回调
    id<SMRWebNavigationViewConfig> navigationViewConfig = [SMRWebConfig shareConfig].webNavigationViewConfig;
    if ([navigationViewConfig respondsToSelector:@selector(webView:didFinishNavigation:)]) {
        [navigationViewConfig webView:webView didFinishNavigation:navigation];
    }
}

/**
 页面加载失败(6)
 */
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(nonnull NSError *)error {
    [self p_hiddenProgressView];
    // web回调
    id<SMRWebNavigationViewConfig> navigationViewConfig = [SMRWebConfig shareConfig].webNavigationViewConfig;
    if ([navigationViewConfig respondsToSelector:@selector(webView:didFailProvisionalNavigation:withError:)]) {
        [navigationViewConfig webView:webView didFailProvisionalNavigation:navigation withError:error];
    }
}

/**
 接收到服务器跳转请求之后调用(7)
 */
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation {
    // web回调
    id<SMRWebNavigationViewConfig> navigationViewConfig = [SMRWebConfig shareConfig].webNavigationViewConfig;
    if ([navigationViewConfig respondsToSelector:@selector(webView:didReceiveServerRedirectForProvisionalNavigation:)]) {
        [navigationViewConfig webView:webView didReceiveServerRedirectForProvisionalNavigation:navigation];
    }
}

/**
 数据加载发生错误(8)
 */
- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    [self p_hiddenProgressView];
    // web回调
    id<SMRWebNavigationViewConfig> navigationViewConfig = [SMRWebConfig shareConfig].webNavigationViewConfig;
    if ([navigationViewConfig respondsToSelector:@selector(webView:didFailNavigation:withError:)]) {
        [navigationViewConfig webView:webView didFailNavigation:navigation withError:error];
    } else {
        // 如果请求被取消
        if (error.code == NSURLErrorCancelled) {
            // None
        }
    }
}

/**
 证书验证(9)
 */
- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(nonnull NSURLAuthenticationChallenge *)challenge completionHandler:(nonnull void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential * _Nullable))completionHandler {
    // web回调
    id<SMRWebNavigationViewConfig> navigationViewConfig = [SMRWebConfig shareConfig].webNavigationViewConfig;
    if ([navigationViewConfig respondsToSelector:@selector(webView:didReceiveAuthenticationChallenge:completionHandler:)]) {
        [navigationViewConfig webView:webView didReceiveAuthenticationChallenge:challenge completionHandler:completionHandler];
    } else {
        if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
            NSURLCredential *card = [[NSURLCredential alloc] initWithTrust:challenge.protectionSpace.serverTrust];
            if (completionHandler) {
                completionHandler(NSURLSessionAuthChallengeUseCredential, card);
            }
        }
        else {
            if (completionHandler) {
                completionHandler(NSURLSessionAuthChallengePerformDefaultHandling, nil);
            }
        }
    }
}

/**
 进程被终止时调用(10)
 */
- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView {
    self.progressView.alpha = 0.0f;
    // web回调
    id<SMRWebNavigationViewConfig> navigationViewConfig = [SMRWebConfig shareConfig].webNavigationViewConfig;
    if ([navigationViewConfig respondsToSelector:@selector(webViewWebContentProcessDidTerminate:)]) {
        [navigationViewConfig webViewWebContentProcessDidTerminate:webView];
    }
}


#pragma mark - Progress

- (void)p_hiddenProgressView {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.progressView.hidden = YES;
    });
}

#pragma mark -  WKUIDelegate

- (WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures {
    if (navigationAction.targetFrame == nil) {
        id<SMRWebNavigationViewConfig> navigationViewConfig = [SMRWebConfig shareConfig].webNavigationViewConfig;
        if ([navigationViewConfig respondsToSelector:@selector(webView:createWebViewWithConfiguration:forNavigationAction:windowFeatures:)]) {
            [navigationViewConfig webView:webView createWebViewWithConfiguration:configuration forNavigationAction:navigationAction windowFeatures:windowFeatures];
        } else {
            [webView loadRequest:navigationAction.request];
        }
    }
    return nil;
}

// alert
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message ? : @"" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * action = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }];
    [alertController addAction:action];
    [self presentViewController:alertController animated:YES completion:nil];
}

// confirm
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message ? : @"" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(NO);
    }];
    UIAlertAction * confirmAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(YES);
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:confirmAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

// textInput
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable))completionHandler {
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:prompt message:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.text = defaultText;
    }];
    UIAlertAction * action = [UIAlertAction actionWithTitle:@"完成" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(alertController.textFields[0].text ? : @"");
    }];
    [alertController addAction:action];
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - ReplaceURL

+ (void)filterUrl:(NSString *)url
  completionBlock:(void (^)(NSString * _Nonnull, BOOL))completionBlock {
    NSURL *filterUrl = [NSURL smr_URLWithString:url];
    id<SMRWebReplaceConfig> replaceConfig = [SMRWebConfig shareConfig].webReplaceConfig;
    if ([replaceConfig respondsToSelector:@selector(replaceUrl:completionBlock:)]) {
        if ([replaceConfig replaceUrl:filterUrl.absoluteString completionBlock:^(NSString * _Nonnull url) {
            // URL参数替换完成后
            [self filterUrl:url completionBlock:completionBlock];
        }] == YES) {
            return;
        } else {
            // 没有做参数的替换,可以继续往下执行
        }
    }
    
    // 为navtive链接,终止加载web
    if ([SMRRouterCenter canResponseWithUrl:filterUrl]) {
        [SMRRouterCenter openWithUrl:filterUrl params:nil];
        if (completionBlock) {
            completionBlock(filterUrl.absoluteString, NO);
        }
    }
    
    // 可以继续加载web
    if (completionBlock) {
        completionBlock(filterUrl.absoluteString, YES);
    }
}

#pragma mark - Utils

- (void)reloadWeb {
    if (!_url) {
        return;
    }
    NSURL *url = [NSURL smr_URLWithString:self.url];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    // 设置UA
    [self p_fillUserAgentWithWebView:self.webView url:url];
    // 加载cookie
    [self p_fillUserCookiesWithWebView:self.webView request:request];
    [self p_fillUserCookiesWithWebView:self.webView url:request.URL content:self.userController];
    
    // 加载请求
    if ([self p_canLoadRequest:request]) {
        [self.webView loadRequest:request];
    }
}

#pragma mark - Setters

- (void)setProgressViewHidden:(BOOL)progressViewHidden {
    _progressViewHidden = progressViewHidden;
    self.progressView.hidden = progressViewHidden;
}

#pragma mark - Getters

- (WKUserContentController *)userController {
    if (!_userController) {
        _userController = [[WKUserContentController alloc] init];
    }
    return _userController;
}

- (WKWebViewConfiguration *)config {
    if (!_config) {
        _config = [[WKWebViewConfiguration alloc] init];
        _config.processPool = [self.class singleWkProcessPool]; // 保证web的LocalStorage同步
        _config.userContentController = self.userController;
    }
    return _config;
}

+ (WKProcessPool *)singleWkProcessPool {
    static WKProcessPool *sharedPool;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedPool = [[WKProcessPool alloc] init];
    });
    return sharedPool;
}

- (WKWebView *)webView {
    if (!_webView) {
        CGFloat webHeight = SCREEN_HEIGHT - self.navigationView.bottom - BOTTOM_HEIGHT;
        webHeight = self.isMainPage ? (webHeight - 49) : webHeight;
        _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, self.navigationView.bottom, SCREEN_WIDTH, webHeight) configuration:self.config];
        _webView.UIDelegate = self;
        _webView.navigationDelegate = self;
        _webView.allowsBackForwardNavigationGestures = YES;
    }
    return _webView;
}

- (UIProgressView *)progressView {
    if (!_progressView) {
        id<SMRWebNavigationViewConfig> navigationViewConfig = [SMRWebConfig shareConfig].webNavigationViewConfig;
        UIProgressView *progressView = nil;
        if ([navigationViewConfig respondsToSelector:@selector(progressViewForWeb:)]) {
            progressView = [navigationViewConfig progressViewForWeb:self];
        } else {
            progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, self.navigationView.bottom, [UIScreen mainScreen].bounds.size.width, 0)];
            progressView.tintColor = [UIColor smr_colorWithHexRGB:@"#F19722"];
            progressView.trackTintColor = [UIColor clearColor];
            if (@available(iOS 14.0, *)) {
                CGAffineTransform scaleform = CGAffineTransformMakeScale(1, 0.5);
                CGAffineTransform transform = CGAffineTransformTranslate(scaleform, 0, -5);
                progressView.transform = transform;
            }
        }
        _progressView = progressView;
    }
    return _progressView;
}

- (SMRWebControllerParameter *)webParameter {
    if (!_webParameter) {
        _webParameter = [[SMRWebControllerParameter alloc] init];
    }
    return _webParameter;
}

@end
