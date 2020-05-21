//
//  SMRWebConfig.m
//  SMRBaseCoreDemo
//
//  Created by 丁治文 on 2019/5/6.
//  Copyright © 2019 sumrise. All rights reserved.
//

#import "SMRWebConfig.h"
#import "SMRRouterCenter.h"
#import "SMRUtils+Validate.h"
#import "SMRLog.h"

#pragma mark - SMRWKScriptMessageHandler

NSString * const kWebHandlerForWeb = @"webController";
NSString * const kWebHandlerForUserContent = @"userContentController";
NSString * const kWebHandlerForMessage = @"message";

@implementation SMRWKScriptMessageHandler

+ (instancetype)handlerWithName:(NSString *)name
                            web:(SMRWebController *)webController
                         target:(nonnull NSString *)target
                         action:(nonnull NSString *)action {
    SMRWKScriptMessageHandler *handler = [[SMRWKScriptMessageHandler alloc] init];
    handler.webController = webController;
    handler.name = name;
    handler.target = target;
    handler.action = action;
    return handler;
}

+ (instancetype)handlerWithName:(NSString *)name
                            web:(SMRWebController *)webController
                        recived:(SMRWKScriptMessageRecivedBlock)recivedBlock {
    SMRWKScriptMessageHandler *handler = [[SMRWKScriptMessageHandler alloc] init];
    handler.webController = webController;
    handler.name = name;
    handler.recivedBlock = recivedBlock;
    return handler;
}

+ (instancetype)handlerWithWebController:(SMRWebController *)webController
                                    name:(NSString *)name
                            recivedBlock:(SMRWKScriptMessageRecivedBlock)recivedBlock {
    SMRWKScriptMessageHandler *handler = [[SMRWKScriptMessageHandler alloc] init];
    handler.webController = webController;
    handler.name = name;
    handler.recivedBlock = recivedBlock;
    return handler;
}

- (void)dealloc {
    _recivedBlock = nil;
}

- (void)userContentController:(WKUserContentController *)userContentController
      didReceiveScriptMessage:(WKScriptMessage *)message {
    if (self.recivedBlock) {
        self.recivedBlock(self.webController, userContentController, message);
    } else {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[kWebHandlerForWeb] = self.webController;
        params[kWebHandlerForUserContent] = userContentController;
        params[kWebHandlerForMessage] = message;
        [SMRRouterCenter performWithTarget:self.target action:self.action params:params];
    }
}

@end

#pragma mark - SMRJSParam

@implementation SMRJSParam

+ (instancetype)param {
    SMRJSParam *param = [[SMRJSParam alloc] init];
    return param;
}

- (void)addString:(NSString *)stringValue format:(NSString *)format {
    self.formats[format] = [NSString stringWithFormat:@"'%@'", stringValue ?: @""];
}
- (void)addInt:(NSInteger)intValue format:(NSString *)format {
    self.formats[format] = [NSString stringWithFormat:@"%@", @(intValue)];
}

- (NSString *)fillWithJSString:(NSString *)jsString {
    if (!jsString) {
        return nil;
    }
    
    __block NSString *rtn = jsString;
    NSString *regex = @"\\(([^)]+)\\)";
    NSString *ps = [SMRUtils matchFirstGroupsInString:jsString regex:regex].lastObject;
    NSArray<NSString *> *params = [ps componentsSeparatedByString:@","];
    [params enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        rtn = [rtn stringByReplacingOccurrencesOfString:obj withString:self.formats[obj]?:@"''"];
    }];
    return rtn;
}

- (NSMutableDictionary<NSString *, NSString *> *)formats {
    if (!_formats) {
        _formats = [NSMutableDictionary dictionary];
    }
    return _formats;
}

@end

#pragma mark - SMRWebConfig

@implementation SMRWebConfig

+ (SMRWebConfig *)shareConfig {
    static SMRWebConfig *_shareWebConfig = nil;
    static dispatch_once_t onceTokenWebConfig;
    dispatch_once(&onceTokenWebConfig, ^{
        _shareWebConfig = [[SMRWebConfig alloc] init];
    });
    return _shareWebConfig;
}

@end
