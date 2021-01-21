//
//  SMRWebController.h
//  SMRBaseCoreDemo
//
//  Created by Tinswin on 2019/2/15.
//  Copyright © 2019年 sumrise. All rights reserved.
//

/**
 WKWebController推荐阅读了解:https://www.cnblogs.com/hero11223/p/9168377.html
 */

#import "SMRNavFatherController.h"

NS_ASSUME_NONNULL_BEGIN

/** web中的各个参数的定制,推荐继承本对象,并在被继承的config中定义和使用其子类 */
@interface SMRWebControllerParameter : NSObject

@property (copy  , nonatomic) NSString *navTitle;

@end

@class WKWebView, WKWebViewConfiguration, WKUserContentController, SMRWebControllerParameter;
@interface SMRWebController : SMRNavFatherController

@property (strong, nonatomic, readonly) WKWebView *webView;
@property (strong, nonatomic, readonly) UIProgressView *progressView;
@property (strong, nonatomic, readonly) WKWebViewConfiguration *config;
@property (strong, nonatomic, readonly) WKUserContentController *userController;

@property (assign, nonatomic) BOOL autoAdjustTabBarByMainPage; // default:NO
@property (strong, nonatomic) SMRWebControllerParameter *webParameter;
@property (copy  , nonatomic) NSString *url;

- (void)reloadWeb;

+ (void)filterUrl:(NSString *)url
  completionBlock:(void (^)(NSString *url, BOOL allowLoad))completionBlock;

@end

NS_ASSUME_NONNULL_END
