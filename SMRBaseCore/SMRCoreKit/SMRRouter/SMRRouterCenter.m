//
//  SMRRouterCenter.m
//  SMRRouterDemo
//
//  Created by 丁治文 on 2018/10/2.
//  Copyright © 2018年 sumrise.com. All rights reserved.
//

#import "SMRRouterCenter.h"
#import <objc/runtime.h>

@interface SMRRouterCenter ()

@property (nonatomic, strong) NSMutableDictionary *cachedTarget;

@end

@implementation SMRRouterCenter
@synthesize config = _config;

+ (instancetype)sharedCenter {
    static SMRRouterCenter *_sharedRouterCenter = nil;
    static dispatch_once_t onceTokenRouterCenter;
    dispatch_once(&onceTokenRouterCenter, ^{
        _sharedRouterCenter = [[SMRRouterCenter alloc] init];
    });
    return _sharedRouterCenter;
}
- (void)startWithConfig:(SMRRouterConfig *)config {
    _config = config;
    [config settingInit];
}

#pragma mark - Base Deals

- (BOOL)canResponseTarget:(NSString *)targetName action:(NSString *)actionName {
    NSObject *target = self.cachedTarget[targetName];
    if (target == nil) {
        Class targetClass = NSClassFromString(targetName);
        target = [[targetClass alloc] init];
    }
    NSString *actionStr = [actionName stringByReplacingOccurrencesOfString:@":" withString:@""];
    NSString *actionStrWithParam = [actionStr stringByAppendingString:@":"];
    SEL action = NSSelectorFromString(actionName);
    SEL actionWithParam = NSSelectorFromString(actionStrWithParam);
    BOOL canResponse = [target respondsToSelector:action] || [target respondsToSelector:actionWithParam];
    return canResponse;
}

- (id)performTarget:(NSString *)targetName action:(NSString *)actionName params:(NSDictionary *)params shouldCacheTargetWithKey:(NSString *)shouldCacheTargetWithKey {
    if (!targetName || !actionName) {
        return nil;
    }
    
    NSObject *target = self.cachedTarget[shouldCacheTargetWithKey];
    if (target == nil) {
        Class targetClass = NSClassFromString(targetName);
        target = [[targetClass alloc] init];
    }
    if (shouldCacheTargetWithKey) {
        [self cacheTarget:target withKey:shouldCacheTargetWithKey];
    }
    
    NSString *actionStr = [actionName stringByReplacingOccurrencesOfString:@":" withString:@""];
    NSString *actionStrWithParam = [actionStr stringByAppendingString:@":"];
    SEL action = NSSelectorFromString(actionName);
    SEL actionWithParam = NSSelectorFromString(actionStrWithParam);
    if ([target respondsToSelector:actionWithParam]) {
        // 带参数的
        return [self safePerformAction:actionWithParam target:target params:params];
    } else if ([target respondsToSelector:action]) {
        // 不带参数的
        return [self safePerformAction:action target:target params:nil];
    } else {
        // 未找到正确的Action,判定为无响应
        [self releaseCachedTargetWithKey:shouldCacheTargetWithKey];
        return nil;
    }
}

- (void)cacheTarget:(NSObject *)target withKey:(NSString *)key {
    self.cachedTarget[key] = target;
}

- (void)releaseCachedTargetWithKey:(NSString *)key {
    if (key) {
        [self.cachedTarget removeObjectForKey:key];
    }
}

#pragma mark - private methods

- (NSString *)safeCacheKeyWithTargetName:(NSString *)targetName key:(NSString *)key {
    return [NSString stringWithFormat:@"%@%@", targetName?targetName:@"", key?key:@""];
}

- (id)safePerformAction:(SEL)action target:(NSObject *)target params:(NSDictionary *)params {
    NSMethodSignature* methodSig = [target methodSignatureForSelector:action];
    if(methodSig == nil) {
        return nil;
    }
    const char* retType = [methodSig methodReturnType];
    
    if (strcmp(retType, @encode(void)) == 0) {
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSig];
        [invocation setArgument:&params atIndex:2];
        [invocation setSelector:action];
        [invocation setTarget:target];
        [invocation invoke];
        return nil;
    }
    
    if (strcmp(retType, @encode(NSInteger)) == 0) {
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSig];
        [invocation setArgument:&params atIndex:2];
        [invocation setSelector:action];
        [invocation setTarget:target];
        [invocation invoke];
        NSInteger result = 0;
        [invocation getReturnValue:&result];
        return @(result);
    }
    
    if (strcmp(retType, @encode(BOOL)) == 0) {
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSig];
        [invocation setArgument:&params atIndex:2];
        [invocation setSelector:action];
        [invocation setTarget:target];
        [invocation invoke];
        BOOL result = 0;
        [invocation getReturnValue:&result];
        return @(result);
    }
    
    if (strcmp(retType, @encode(CGFloat)) == 0) {
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSig];
        [invocation setArgument:&params atIndex:2];
        [invocation setSelector:action];
        [invocation setTarget:target];
        [invocation invoke];
        CGFloat result = 0;
        [invocation getReturnValue:&result];
        return @(result);
    }
    
    if (strcmp(retType, @encode(NSUInteger)) == 0) {
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSig];
        [invocation setArgument:&params atIndex:2];
        [invocation setSelector:action];
        [invocation setTarget:target];
        [invocation invoke];
        NSUInteger result = 0;
        [invocation getReturnValue:&result];
        return @(result);
    }
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    return [target performSelector:action withObject:params];
#pragma clang diagnostic pop
}

#pragma mark - Getters And Setters

- (SMRRouterConfig *)config {
    if (!_config) {
        _config = [[SMRRouterConfig alloc] init];
        [_config settingInit];
    }
    return _config;
}

- (NSMutableDictionary *)cachedTarget {
    if (_cachedTarget == nil) {
        _cachedTarget = [[NSMutableDictionary alloc] init];
    }
    return _cachedTarget;
}

#pragma mark - Native Deals

+ (BOOL)canResponseTarget:(NSString *)target action:(NSString *)action {
    SMRRouterCenter *center = [SMRRouterCenter sharedCenter];
    return [center canResponseTarget:target action:action];
}
+ (id)performWithTarget:(NSString *)target action:(NSString *)action params:(nullable NSDictionary *)params {
    return [self performWithTarget:target action:action params:params shouldCacheTarget:NO];
}
+ (id)performWithTarget:(NSString *)target action:(NSString *)action params:(nullable NSDictionary *)params shouldCacheTarget:(BOOL)shouldCacheTarget {
    return [self p_performWithTarget:target action:action params:params shouldCacheTargetWithKey:shouldCacheTarget?target:nil];
}
+ (void)releaseCachedTargetWithTagetName:(NSString *)tagetName {
    if (!tagetName) {
        return;
    }
    SMRRouterCenter *center = [SMRRouterCenter sharedCenter];
    [center releaseCachedTargetWithKey:tagetName];
}

+ (void)cacheTarget:(NSObject *)target withCacheKey:(NSString *)cacheKey {
    if (!target) {
        return;
    }
    SMRRouterCenter *center = [SMRRouterCenter sharedCenter];
    [center cacheTarget:target withKey:[NSString stringWithFormat:@"%@%@", NSStringFromClass(target.class), cacheKey ?: cacheKey]];
}
+ (void)releaseCachedTarget:(NSObject *)target withCacheKey:(NSString *)cacheKey {
    if (!target) {
        return;
    }
    SMRRouterCenter *center = [SMRRouterCenter sharedCenter];
    [center releaseCachedTargetWithKey:[NSString stringWithFormat:@"%@%@", NSStringFromClass(target.class), cacheKey ?: cacheKey]];
}

+ (id)p_performWithTarget:(NSString *)target action:(NSString *)action params:(nullable NSDictionary *)params shouldCacheTargetWithKey:(NSString *)cacheKey {
    SMRRouterCenter *center = [SMRRouterCenter sharedCenter];
    return [center performTarget:target action:action params:params shouldCacheTargetWithKey:cacheKey];;
}

#pragma mark - URL Deals
+ (BOOL)canResponseWithUrl:(NSURL *)url {
    SMRRouterCenter *center = [SMRRouterCenter sharedCenter];
    if (![self p_checkSchemeResponsableWithConfig:center.config url:url]) {
        return NO;
    }
    
    SMRURLParserItem *parserItem = [center.config.urlProvider.parser parserWithUrl:url additionParams:nil];
    return [SMRRouterCenter canResponseTarget:parserItem.target action:parserItem.action];
}
+ (id)performWithUrl:(NSURL *)url params:(nullable NSDictionary *)params {
    return [self performWithUrl:url params:params shouldCacheTarget:NO];
}
+ (id)performWithUrl:(NSURL *)url params:(nullable NSDictionary *)params shouldCacheTarget:(BOOL)shouldCacheTarget {
    SMRRouterCenter *center = [SMRRouterCenter sharedCenter];
    if (![self p_checkSchemeResponsableWithConfig:center.config url:url]) {
        return nil;
    }
    
    SMRURLParserItem *parserItem = [center.config.urlProvider.parser parserWithUrl:url additionParams:params];
    return [SMRRouterCenter performWithTarget:parserItem.target action:parserItem.action params:parserItem.params shouldCacheTarget:shouldCacheTarget];
}

/// private
+ (BOOL)p_checkSchemeResponsableWithConfig:(SMRRouterConfig *)config url:(NSURL *)url {
    BOOL canResponse = YES;
    if (config.urlProvider.urlValideBlock) {
        canResponse = config.urlProvider.urlValideBlock(url);
    }
    return canResponse;
}

@end
