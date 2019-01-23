//
//  SMRRouterCenter+SMROpen.m
//  SMRRouterDemo
//
//  Created by 丁治文 on 2018/10/12.
//  Copyright © 2018 sumrise.com. All rights reserved.
//

#import "SMRRouterCenter+SMROpen.h"
#import "SMRRouter.h"
#import "SMRTarget.h"

@implementation SMRRouterCenter (SMROpen)

#pragma mark - Native Deals

+ (id)fetchObjectWithTarget:(NSString *)target action:(NSString *)action params:(nullable NSDictionary *)params {
    return [self p_performWithTarget:target action:action params:params openType:SMRTargetOpenTypeNone];
}
+ (id)openWithTarget:(NSString *)target action:(NSString *)action params:(nullable NSDictionary *)params {
    return [self p_performWithTarget:target action:action params:params openType:SMRTargetOpenTypeOpen];
}
+ (id)openPathWithTarget:(NSString *)target action:(NSString *)action params:(nullable NSDictionary *)params {
    return [self p_performWithTarget:target action:action params:params openType:SMRTargetOpenTypeOpenPath];
}

+ (id)p_performWithTarget:(NSString *)target action:(NSString *)action params:(nullable NSDictionary *)params openType:(SMRTargetOpenType)openType {
    NSMutableDictionary *nativeParams = params?[params mutableCopy]:[NSMutableDictionary dictionary];
    if (![nativeParams.allKeys containsObject:k_perform_open]) {
        nativeParams[k_perform_open] = @(openType);
    }
    return [self performWithTarget:target action:action params:nativeParams];
}

#pragma mark - URL Deals

+ (id)fetchObjectWithUrl:(NSURL *)url params:(nullable NSDictionary *)params {
    return [self p_performWithUrl:url params:params openType:SMRTargetOpenTypeNone];
}
+ (id)openWithUrl:(NSURL *)url params:(nullable NSDictionary *)params {
    return [self p_performWithUrl:url params:params openType:SMRTargetOpenTypeOpen];
}
+ (id)openPathWithUrl:(NSURL *)url params:(nullable NSDictionary *)params {
    return [self p_performWithUrl:url params:params openType:SMRTargetOpenTypeOpenPath];
}

+ (id)p_performWithUrl:(NSURL *)url params:(nullable NSDictionary *)params openType:(SMRTargetOpenType)openType {
    SMRURLParserItem *item = [[SMRRouterCenter sharedCenter].config.urlProvider.parser parserWithUrl:url additionParams:params];
    if (![item.params.allKeys containsObject:k_perform_open]) {
        url = [url smr_URLByAppendParam:k_perform_open value:[NSString stringWithFormat:@"%@", @(openType)]];
    }
    return [self performWithUrl:url params:params];
}

@end
