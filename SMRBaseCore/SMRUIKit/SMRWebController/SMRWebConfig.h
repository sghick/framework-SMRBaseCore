//
//  SMRWebConfig.h
//  SMRBaseCoreDemo
//
//  Created by 丁治文 on 2019/5/6.
//  Copyright © 2019 sumrise. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>
#import "SMRWebParameter.h"

NS_ASSUME_NONNULL_BEGIN

@class SMRWebController;
@protocol SMRNavigationViewConfig <NSObject>

- (SMRNavigationView *)navigationViewOfWebController:(SMRWebController *)controller;

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

@class SMRWebController;
@protocol SMRWebJSRegisterConfig <NSObject>

@optional
- (NSArray<SMRWKScriptMessageHandler *> *)messageHandlersWithWebController:(SMRWebController *)webController;

@end

@protocol SMRWebReplaceConfig <NSObject>

@optional
/** YES为url有参数需要替换 */
- (BOOL)replaceUrl:(NSString *)url completionBlock:(void (^)(NSString *url))completionBlock;

@end

@interface SMRWebConfig : NSObject

@property (strong, nonatomic) id<SMRNavigationViewConfig> navigationViewConfig;
@property (strong, nonatomic) id<SMRWebJSRegisterConfig> webJSRegisterConfig;
@property (strong, nonatomic) id<SMRWebReplaceConfig> webReplaceConfig;

+ (SMRWebConfig *)shareConfig;

@end

NS_ASSUME_NONNULL_END
