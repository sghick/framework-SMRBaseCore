//
//  SMRRouterCenter.h
//  SMRRouterDemo
//
//  Created by 丁治文 on 2018/10/2.
//  Copyright © 2018年 sumrise.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMRRouterConfig.h"

NS_ASSUME_NONNULL_BEGIN

@class SMRRouterConfig;
@interface SMRRouterCenter : NSObject

@property (strong, nonatomic, readonly) SMRRouterConfig *config;

/// 单例对象
+ (instancetype)sharedCenter;
/// 若有自定义的config,请调用此方法替换config,否则使用的是默认的config
- (void)startWithConfig:(SMRRouterConfig *)config;

#pragma mark - Native Deals
/// 判断是否能响应相应的target-action
+ (BOOL)canResponseTarget:(NSString *)target action:(NSString *)action;
/// native调用时的接口, 返回action中的返回值
+ (id)performWithTarget:(NSString *)target action:(NSString *)action params:(nullable NSDictionary *)params;
+ (id)performWithTarget:(NSString *)target action:(NSString *)action params:(nullable NSDictionary *)params shouldCacheTarget:(BOOL)shouldCacheTarget;
+ (void)releaseCachedTargetWithTagetName:(NSString *)tagetName;

/// 主动加缓存
+ (void)cacheTarget:(NSObject *)target withCacheKey:(NSString *)cacheKey;
/// 释放target
+ (void)releaseCachedTarget:(NSObject *)target withCacheKey:(NSString *)cacheKey;

#pragma mark - URL Deals
/// scheme://target/action?param1=a&param2=b
+ (BOOL)canResponseWithUrl:(NSURL *)url;
+ (id)performWithUrl:(NSURL *)url params:(nullable NSDictionary *)params;
+ (id)performWithUrl:(NSURL *)url params:(nullable NSDictionary *)params shouldCacheTarget:(BOOL)shouldCacheTarget;

@end

NS_ASSUME_NONNULL_END

