//
//  SMRGlobalCache.m
//  SMRBaseCoreDemo
//
//  Created by 丁治文 on 2019/3/14.
//  Copyright © 2019 sumrise. All rights reserved.
//

#import "SMRGlobalCache.h"
#import "SDImageCache.h"

@interface SMRGlobalCache ()

@property (strong, nonatomic) NSMutableDictionary *allCaches;

@property (copy  , nonatomic) NSString *name;
@property (strong, nonatomic) SDImageCache *imageCache;

@end

@implementation SMRGlobalCache

+ (instancetype)globalCache {
    static SMRGlobalCache *_sheredGlobalCache = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sheredGlobalCache = [[SMRGlobalCache alloc] init];
    });
    return _sheredGlobalCache;
}

+ (instancetype)defaultCache {
    return [self cacheWithName:@"SMRGlobalCache"];
}

+ (instancetype)cacheWithName:(NSString *)name {
    SMRGlobalCache *cache = [SMRGlobalCache globalCache].allCaches[name];
    if (!cache) {
        cache = [[SMRGlobalCache alloc] init];
        cache.name = name;
        [[SMRGlobalCache globalCache].allCaches setObject:cache forKey:name];
    }
    return cache;
}

#pragma mark - CacheForImage

- (void)cacheImage:(UIImage *)image key:(NSString *)key {
    [self.imageCache storeImage:image forKey:key completion:nil];
}
- (UIImage *)imageWithKey:(NSString *)key {
    return [self.imageCache imageFromDiskCacheForKey:key];
}
- (void)removeImageWithKey:(NSString *)key {
    [self.imageCache removeImageForKey:key withCompletion:nil];
}

#pragma mark - Getters

- (NSMutableDictionary *)allCaches {
    if (!_allCaches) {
        _allCaches =[NSMutableDictionary dictionary];
    }
    return _allCaches;
}

- (SDImageCache *)imageCache {
    if (!_imageCache) {
        _imageCache = [[SDImageCache alloc] initWithNamespace:self.name diskCacheDirectory:nil];
    }
    return _imageCache;
}

@end
