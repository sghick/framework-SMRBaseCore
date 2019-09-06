//
//  SMRWebController.h
//  SMRBaseCoreDemo
//
//  Created by 丁治文 on 2019/3/26.
//  Copyright © 2019 sumrise. All rights reserved.
//

#import "SMRNavFatherController.h"

NS_ASSUME_NONNULL_BEGIN

/** web中的各个参数的定制,推荐继承本对象,并在被继承的config中定义和使用其子类 */
@interface SMRWebControllerParameter : NSObject

@property (copy  , nonatomic) NSString *navTitle;

@end

@class WKWebView, SMRWebControllerParameter;
@interface SMRWebController : SMRNavFatherController

@property (assign, nonatomic) BOOL autoAdjustTabBarByMainPage; // default:NO
@property (strong, nonatomic, readonly) WKWebView *webView;
@property (strong, nonatomic) SMRWebControllerParameter *webParameter;
@property (copy  , nonatomic) NSString *url;

- (void)reloadWeb;

+ (void)filterUrl:(NSString *)url
  completionBlock:(void (^)(NSString *url, BOOL allowLoad))completionBlock;

@end

NS_ASSUME_NONNULL_END
