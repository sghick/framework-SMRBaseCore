//
//  SMRNetCache.m
//  SMRNetworkDemo
//
//  Created by 丁治文 on 2018/10/7.
//  Copyright © 2018年 sumrise.com. All rights reserved.
//

#import "SMRNetCache.h"
#import "YYDiskCache.h"

static NSString *const kSMRNetCacheName = @"SMRNetCache";

@implementation SMRNetCachePolicy

+ (instancetype)policyWithIdentifier:(NSString *)identifier cacheKey:(NSString *)cacheKey {
    return [self policyWithIdentifier:identifier cacheKey:cacheKey callBackIfCacheNil:YES];
}

+ (instancetype)policyWithIdentifier:(NSString *)identifier cacheKey:(NSString *)cacheKey callBackIfCacheNil:(BOOL)callBackIfCacheNil {
    SMRNetCachePolicy *policy = [[SMRNetCachePolicy alloc] init];
    policy.identifier = identifier;
    policy.cacheKey = cacheKey;
    policy.callBackIfCacheNil = callBackIfCacheNil;
    return policy;
}

@end

@interface SMRNetCache ()

@property (strong, nonatomic) YYDiskCache *yydiskCache;

@end

@implementation SMRNetCache

- (void)addObject:(id)object policy:(SMRNetCachePolicy *)policy {
    if (!policy.identifier || !policy.cacheKey || !object) {
        return;
    }
    // 使用policy.cacheKey作为读取时的key
    NSDictionary *cacheDict =@{policy.cacheKey:object};
    [self.yydiskCache setObject:cacheDict forKey:policy.identifier];
}

- (id)objectWithPolicy:(SMRNetCachePolicy *)policy {
    if (!policy.identifier || !policy.cacheKey) {
        return nil;
    }
    NSDictionary *cacheDict = (NSDictionary *)[self.yydiskCache objectForKey:policy.identifier];
    if ([cacheDict isKindOfClass:[NSDictionary class]]) {
        // 使用policy.cacheKey作为读取时的key
        id obj = cacheDict[policy.cacheKey];
        return obj;
    }
    return nil;
}

- (void)objectWithPolicy:(SMRNetCachePolicy *)policy resultBlock:(void (^)(SMRNetCachePolicy *, id))resultBlock {
    if (!policy.identifier || !policy.cacheKey) {
        return;
    }
    [self.yydiskCache objectForKey:policy.identifier withBlock:^(NSString * _Nonnull key, id<NSCoding>  _Nullable object) {
        NSDictionary *cacheDict = (NSDictionary *)object;
        if ([cacheDict isKindOfClass:[NSDictionary class]]) {
            // 使用policy.cacheKey作为读取时的key
            id content = cacheDict[policy.cacheKey];
            // 如果内容不为空,或者空也回调设置为YES,则回调
            if (content || policy.callBackIfCacheNil) {
                if (resultBlock) {
                    resultBlock(policy, content);
                }
            }
            
        }
    }];
}

- (void)clearCacheWihtPolicy:(SMRNetCachePolicy *)policy {
    if (!policy.identifier) {
        return;
    }
    [self.yydiskCache removeObjectForKey:policy.identifier];
}

- (void)clearAllCaches {
    [self.yydiskCache removeAllObjects];
}

#pragma mark - Path

+ (NSString *)netCachePath {
    NSString *fileDoc = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:kSMRNetCacheName];
    return fileDoc;
}

#pragma mark - Getters

- (YYDiskCache *)yydiskCache {
    if (!_yydiskCache) {
        _yydiskCache = [[YYDiskCache alloc] initWithPath:[SMRNetCache netCachePath]];
        _yydiskCache.name = kSMRNetCacheName;
    }
    return _yydiskCache;
}

@end
