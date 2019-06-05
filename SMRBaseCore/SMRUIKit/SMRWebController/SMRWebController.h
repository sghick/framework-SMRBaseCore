//
//  SMRWebController.h
//  SMRBaseCoreDemo
//
//  Created by 丁治文 on 2019/3/26.
//  Copyright © 2019 sumrise. All rights reserved.
//

#import "SMRNavFatherController.h"

NS_ASSUME_NONNULL_BEGIN

@class WKWebView, SMRWebParameter;
@interface SMRWebController : SMRNavFatherController

@property (strong, nonatomic, readonly) WKWebView *webView;
@property (strong, nonatomic) SMRWebParameter *webParameter;
@property (copy  , nonatomic) NSString *url;

+ (void)filterUrl:(NSString *)url
  completionBlock:(void (^)(NSString *url, BOOL allowLoad))completionBlock;

@end

NS_ASSUME_NONNULL_END
