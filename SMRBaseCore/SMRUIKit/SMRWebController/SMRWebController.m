//
//  SMRWebController.m
//  SMRBaseCoreDemo
//
//  Created by 丁治文 on 2019/3/26.
//  Copyright © 2019 sumrise. All rights reserved.
//

#import "SMRWebController.h"
#import <WebKit/WebKit.h>
#import "SMRAdapter.h"
#import "SMRRouterCenter+SMROpen.h"
#import "SMRWebConfig.h"
#import "NSURL+SMRRouter.h"
#import "SMRUIKitBundle.h"

@interface SMRWebController () <
WKUIDelegate,
WKNavigationDelegate>

@property (strong, nonatomic) UIProgressView *progressView;
@property (strong, nonatomic) WKWebViewConfiguration *config;
@property (strong, nonatomic) UIButton *shareBtn;
@property (strong, nonatomic) WKUserContentController *userController;
@property (strong, nonatomic) NSArray<SMRWKScriptMessageHandler *> *messageHandlers;

@end

@implementation SMRWebController

@synthesize webView = _webView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.webView];
    [self.view addSubview:self.progressView];
    [self addScriptMessageHandlers];
}

- (SMRNavigationView *)navigationViewInitialization {
    if ([[SMRWebConfig shareConfig].navigationViewConfig respondsToSelector:@selector(navigationViewOfWebController:)]) {
        return [[SMRWebConfig shareConfig].navigationViewConfig navigationViewOfWebController:self];
    }
    return [super navigationViewInitialization];
}

#pragma mark - 交互相关(注册js方法,以便web通过js调用)

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

#pragma mark - WKNavigationDelegate

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    self.progressView.hidden = NO;
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [self hiddenProgressView];
}

//  页面加载失败时调用 ( 【web视图加载内容时】发生错误)
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(nonnull NSError *)error {
    [self hiddenProgressView];
}

// 【web视图导航过程中发生错误】时调用。
- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    [self hiddenProgressView];
    // 如果请求被取消
    if (error.code == NSURLErrorCancelled) {
        return;
    }
}

// 当Web视图的Web内容进程终止时调用。
- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView {
    self.progressView.alpha = 0.0f;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqual:@"estimatedProgress"] && object == self.webView) {
        self.progressView.hidden = NO;
        [self.progressView setProgress:self.webView.estimatedProgress animated:YES];
        if (self.webView.estimatedProgress  >= 1.0f) {
            [self hiddenProgressView];
        }
    } else if ([keyPath isEqual:@"title"] && object == self.webView) {
        self.title = self.webView.title;
    } else{
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)hiddenProgressView {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.progressView.hidden = YES;
    });
}

#pragma mark -  WKUIDelegate

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    NSURL *url = navigationAction.request.URL;
    
    id<SMRWebReplaceConfig> replaceConfig = [SMRWebConfig shareConfig].webReplaceConfig;
    if ([replaceConfig respondsToSelector:@selector(replaceUrl:completionBlock:)]) {
        if ([replaceConfig replaceUrl:url.absoluteString completionBlock:^(NSString * _Nonnull url) {
            [webView loadRequest:[NSURLRequest requestWithURL:[NSURL smr_URLWithString:url]]];
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
        [SMRRouterCenter openWithUrl:url params:nil];
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }
    
    // 为其它链接(跳转打电话、AppStore等)
    if ([[UIApplication sharedApplication] openURL:url]) {
        decisionHandler(WKNavigationActionPolicyCancel);
    } else {
        decisionHandler(WKNavigationActionPolicyAllow);
    }
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

- (void)dealloc {
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
    [self.webView removeObserver:self forKeyPath:@"title"];
    [self removeScriptMessageHandlers];
}

#pragma mark - Utils

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

#pragma mark - lazy

- (WKUserContentController *)userController {
    if (!_userController) {
        _userController = [[WKUserContentController alloc] init];
    }
    return _userController;
}

- (WKWebViewConfiguration *)config {
    if (!_config) {
        _config = [[WKWebViewConfiguration alloc] init];
        _config.userContentController = self.userController;
    }
    return _config;
}

- (WKWebView *)webView {
    if (!_webView) {
        _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, self.navigationView.bottom, SCREEN_WIDTH, SCREEN_HEIGHT - self.navigationView.bottom - BOTTOM_HEIGHT) configuration:self.config];
        _webView.UIDelegate = self;
        _webView.navigationDelegate = self;
        _webView.allowsBackForwardNavigationGestures = YES;
        NSURL *url = [NSURL URLWithString:self.url];
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
        [_webView loadRequest:request];
        [_webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:nil];
        [_webView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:nil];
    }
    return _webView;
}

- (UIProgressView *)progressView {
    if (!_progressView) {
        _progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, self.navigationView.bottom, [UIScreen mainScreen].bounds.size.width, 0)];
        _progressView.tintColor = [UIColor blueColor];
        _progressView.trackTintColor = [UIColor clearColor];
    }
    return _progressView;
}

- (SMRWebParameter *)webParameter {
    if (!_webParameter) {
        _webParameter = [[SMRWebParameter alloc] init];
    }
    return _webParameter;
}

@end
