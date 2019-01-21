//
//  SMRNetCache.h
//  SMRNetworkDemo
//
//  Created by 丁治文 on 2018/10/7.
//  Copyright © 2018年 sumrise.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SMRNetCachePolicy : NSObject

@property (copy  , nonatomic) NSString *identifier;         ///< identifier标识一个cache
@property (copy  , nonatomic) NSString *cacheKey;           ///< cacheKey相匹配时才取出cache
@property (assign, nonatomic) BOOL callBackIfCacheNil;      ///< 如果cache为空才回调,设置为NO则不回调

+ (instancetype)policyWithIdentifier:(NSString *)identifier cacheKey:(NSString *)cacheKey;///< callBackIfCacheNil:YES
+ (instancetype)policyWithIdentifier:(NSString *)identifier cacheKey:(NSString *)cacheKey callBackIfCacheNil:(BOOL)callBackIfCacheNil;

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
- (void)objectWithPolicy:(SMRNetCachePolicy *)policy resultBlock:(void (^)(SMRNetCachePolicy *policy, id object))resultBlock;

/**
 清除指定的缓存
 */
- (void)clearCacheWihtPolicy:(SMRNetCachePolicy *)policy;

/**
 清除所有的缓存
 */
- (void)clearAllCaches;

@end
