//
//  SMRWebConfig.m
//  SMRBaseCoreDemo
//
//  Created by 丁治文 on 2019/5/6.
//  Copyright © 2019 sumrise. All rights reserved.
//

#import "SMRWebConfig.h"

@implementation SMRWKScriptMessageHandler

+ (instancetype)handlerWithWebController:(SMRWebController *)webController name:(NSString *)name recivedBlock:(SMRWKScriptMessageRecivedBlock)recivedBlock {
    SMRWKScriptMessageHandler *handler = [[SMRWKScriptMessageHandler alloc] init];
    handler.webController = webController;
    handler.name = name;
    handler.recivedBlock = recivedBlock;
    return handler;
}

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    if (self.recivedBlock) {
        self.recivedBlock(self.webController, userContentController, message);
    } else {
        NSLog(@"%@:有人用js调了我, 但是你却没有定义我 @ _ @", message.name);
    }
}

@end

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
