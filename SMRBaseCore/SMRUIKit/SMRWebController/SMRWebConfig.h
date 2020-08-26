//
//  SMRWebConfig.h
//  SMRBaseCoreDemo
//
//  Created by Tinswin on 2019/4/10.
//  Copyright © 2019年 sumrise. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN

#pragma mark - SMRWKScriptMessageHandler

@class SMRWebController;
typedef void(^SMRWKScriptMessageRecivedBlock)(SMRWebController *webController, WKUserContentController *userContentController, WKScriptMessage *message);

/** target-action 通过router发送的参数的key */
FOUNDATION_EXPORT NSString * const kWebHandlerForWeb;
FOUNDATION_EXPORT NSString * const kWebHandlerForUserContent;
FOUNDATION_EXPORT NSString * const kWebHandlerForMessage;

/** 定义和处理js调用oc的方法 */
@interface SMRWKScriptMessageHandler : NSObject <WKScriptMessageHandler>

@property (weak  , nonatomic) SMRWebController *webController;

@property (copy  , nonatomic) NSString *name;
/** 为nil时,将使用target action 通过router发送消息 */
@property (copy  , nonatomic) __nullable SMRWKScriptMessageRecivedBlock recivedBlock;
@property (copy  , nonatomic) NSString *target;
@property (copy  , nonatomic) NSString *action;

+ (instancetype)handlerWithName:(NSString *)name
                            web:(SMRWebController *)webController
                         target:(NSString *)target
                         action:(NSString *)action;
+ (instancetype)handlerWithName:(NSString *)name
                            web:(SMRWebController *)webController
                        recived:(nullable SMRWKScriptMessageRecivedBlock)recivedBlock;
+ (instancetype)handlerWithWebController:(SMRWebController *)webController
                                    name:(NSString *)name
                            recivedBlock:(SMRWKScriptMessageRecivedBlock)recivedBlock __deprecated_msg("方法已废弃");

@end

#pragma mark - SMRJSParam

/** js方法参数填充 */
@interface SMRJSParam : NSObject

@property (strong, nonatomic) NSMutableDictionary<NSString *, NSString *> *formats;

+ (instancetype)param;

- (void)addString:(NSString *)stringValue format:(NSString *)format;
- (void)addInt:(NSInteger)intValue format:(NSString *)format;

- (NSString *)fillWithJSString:(NSString *)jsString;

@end

#pragma mark - Config Protocols

@class SMRWebController;
@class SMRNavigationView;
@protocol SMRWebNavigationViewConfig <WKNavigationDelegate>

@optional
/** 返回一个自定义的navigationView */
- (SMRNavigationView *)navigationViewOfWebController:(SMRWebController *)web;
- (void)webViewDidLoad:(SMRWebController *)web;
- (void)webViewWillAppear:(SMRWebController *)web;
- (void)webViewWillDisappear:(SMRWebController *)web;
- (BOOL)canLoadRequest:(NSURLRequest *)request web:(SMRWebController *)web; ///< 默认当YES处理

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

#pragma mark - SMRWebConfig

@interface SMRWebConfig : NSObject

@property (strong, nonatomic) id<SMRWebNavigationViewConfig> webNavigationViewConfig;
@property (strong, nonatomic) id<SMRWebJSRegisterConfig> webJSRegisterConfig;
@property (strong, nonatomic) id<SMRWebReplaceConfig> webReplaceConfig;

+ (SMRWebConfig *)shareConfig;

@end

NS_ASSUME_NONNULL_END
