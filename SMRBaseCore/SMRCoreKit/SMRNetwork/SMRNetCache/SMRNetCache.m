//
//  SMRNetCache.m
//  SMRNetworkDemo
//
//  Created by 丁治文 on 2018/12/18.
//  Copyright © 2018 sumrise. All rights reserved.
//

#import "SMRNetCache.h"
#import "SMRGlobalCache.h"

NSString *const kSMRNetCacheName = @"SMRNetCache";

@implementation SMRNetCachePolicy

+ (instancetype)policyWithIdentifier:(NSString *)identifier cacheKey:(NSString *)cacheKey {
    SMRNetCachePolicy *policy = [[SMRNetCachePolicy alloc] init];
    policy.identifier = identifier;
    policy.cacheKey = cacheKey;
    return policy;
}

- (void)appendIdentifierWithParams:(NSDictionary *)params {
    [params enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [self appendIdentifierWithKey:key value:obj];
    }];
}
- (void)appendIdentifierWithKey:(NSString *)key value:(id)value {
    NSString *querys = [NSString stringWithFormat:@"%@=%@", key, value];
    if ([self.identifier containsString:@"?"]) {
        self.identifier = [NSString stringWithFormat:@"%@&%@", self.identifier, querys];
    } else {
        self.identifier = [NSString stringWithFormat:@"%@?%@", self.identifier, querys];
    }
}

- (void)appendCacheKeyWithParams:(NSDictionary *)params {
    [params enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [self appendCacheKeyWithKey:key value:obj];
    }];
}
- (void)appendCacheKeyWithKey:(NSString *)key value:(id)value {
    NSString *querys = [NSString stringWithFormat:@"%@=%@", key, value];
    if ([self.cacheKey containsString:@"?"]) {
        self.cacheKey = [NSString stringWithFormat:@"%@&%@", self.cacheKey, querys];
    } else {
        self.cacheKey = [NSString stringWithFormat:@"%@?%@", self.cacheKey, querys];
    }
}

@end

@interface SMRNetCache ()

@property (strong, nonatomic) SMRGlobalCache *diskCache;

@end

@implementation SMRNetCache

- (void)addObject:(id)object policy:(SMRNetCachePolicy *)policy {
    if (!policy.identifier || !policy.cacheKey || !object) {
        return;
    }
    // 使用policy.cacheKey作为读取时的key
    NSDictionary *cacheDict =@{policy.cacheKey:object};
    [self.diskCache setObject:cacheDict forKey:policy.identifier];
}

- (id)objectWithPolicy:(SMRNetCachePolicy *)policy {
    if (!policy.identifier || !policy.cacheKey) {
        return nil;
    }
    NSDictionary *cacheDict = (NSDictionary *)[self.diskCache objectForKey:policy.identifier];
    if ([cacheDict isKindOfClass:[NSDictionary class]]) {
        // 使用policy.cacheKey作为读取时的key
        id obj = cacheDict[policy.cacheKey];
        return obj;
    }
    return nil;
}

- (void)clearCacheWihtPolicy:(SMRNetCachePolicy *)policy {
    if (!policy.identifier) {
        return;
    }
    [self.diskCache removeObjectForKey:policy.identifier];
}

- (void)clearAllCaches {
    [self.diskCache removeAllObjects];
}

#pragma mark - Getters

- (SMRGlobalCache *)diskCache {
    if (!_diskCache) {
        _diskCache = [SMRGlobalCache cacheWithName:kSMRNetCacheName unnecessary:YES];
    }
    return _diskCache;
}

@end
