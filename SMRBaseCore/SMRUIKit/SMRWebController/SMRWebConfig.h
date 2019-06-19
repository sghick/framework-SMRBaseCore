//
//  SMRWebConfig.h
//  SMRBaseCoreDemo
//
//  Created by 丁治文 on 2019/5/6.
//  Copyright © 2019 sumrise. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN

@class SMRWebController;
@class SMRNavigationView;
@protocol SMRWebNavigationViewConfig <NSObject>

@optional
/** 返回一个自定义的navigationView */
- (SMRNavigationView *)navigationViewOfWebController:(SMRWebController *)webController;

@end

@class SMRWebController;
typedef void(^SMRWKScriptMessageRecivedBlock)(SMRWebController *webController, WKUserContentController *userContentController, WKScriptMessage *message);

/** 定义和处理js调用oc的方法 */
@interface SMRWKScriptMessageHandler : NSObject <WKScriptMessageHandler>

@property (weak  , nonatomic) SMRWebController *webController;

@property (copy  , nonatomic) NSString *name;
@property (copy  , nonatomic) SMRWKScriptMessageRecivedBlock recivedBlock;

+ (instancetype)handlerWithWebController:(SMRWebController *)webController
                                    name:(NSString *)name
                            recivedBlock:(SMRWKScriptMessageRecivedBlock)recivedBlock;

@end

@protocol SMRWebJSRegisterConfig <NSObject>

@optional
- (NSArray<SMRWKScriptMessageHandler *> *)messageHandlersWithWebController:(SMRWebController *)webController;

@end

@protocol SMRWebReplaceConfig <NSObject>

@optional
/** YES为url有参数需要替换 */
- (BOOL)replaceUrl:(NSString *)url completionBlock:(void (^)(NSString *url))completionBlock;
/** 根据具体情况设置对应的UA */
- (NSString *)customUserAgentWithWebController:(SMRWebController *)webController url:(NSURL *)url;
/** 需要加载的cookie */
- (NSArray<NSHTTPCookie *> *)customUserCookiesWithWebController:(SMRWebController *)webController url:(NSURL *)url;
/** 可在这里注入的JS代码 */
- (void)customJSTextToInvokeWithWebController:(SMRWebController *)webController url:(NSURL *)url;

@end

@interface SMRWebConfig : NSObject

@property (strong, nonatomic) id<SMRWebNavigationViewConfig> webNavigationViewConfig;
@property (strong, nonatomic) id<SMRWebJSRegisterConfig> webJSRegisterConfig;
@property (strong, nonatomic) id<SMRWebReplaceConfig> webReplaceConfig;

+ (SMRWebConfig *)shareConfig;

@end

NS_ASSUME_NONNULL_END
