//
//  SMRNetCache.h
//  SMRNetworkDemo
//
//  Created by 丁治文 on 2018/10/7.
//  Copyright © 2018年 sumrise.com. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const kSMRNetCacheName; ///< SMRGlobalCache的缓存名字

@interface SMRNetCachePolicy : NSObject

@property (copy  , nonatomic) NSString *identifier;         ///< identifier标识一个cache
@property (copy  , nonatomic) NSString *cacheKey;           ///< cacheKey相匹配时才取出cache

+ (instancetype)policyWithIdentifier:(NSString *)identifier cacheKey:(NSString *)cacheKey;

/** 自动更新identifier */
- (void)appendIdentifierWithParams:(NSDictionary *)params;
- (void)appendIdentifierWithKey:(NSString *)key value:(id)value;

/** 自动更新cacheKey[推荐] */
- (void)appendCacheKeyWithParams:(NSDictionary *)params;
- (void)appendCacheKeyWithKey:(NSString *)key value:(id)value;

@end

@class SMRNetCachePolicy;
@interface SMRNetCache : NSObject

/**
 根据策略添加缓存
 */
- (void)addObject:(id)object policy:(SMRNetCachePolicy *)policy;

/**
 获取缓存
 */
- (id)objectWithPolicy:(SMRNetCachePolicy *)policy;

/**
 清除指定的缓存
 */
- (void)clearCacheWihtPolicy:(SMRNetCachePolicy *)policy;

/**
 清除所有的缓存
 */
- (void)clearAllCaches;

@end
