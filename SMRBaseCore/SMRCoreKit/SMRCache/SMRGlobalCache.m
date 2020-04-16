//
//  SMRGlobalCache.m
//  SMRBaseCoreDemo
//
//  Created by 丁治文 on 2019/3/14.
//  Copyright © 2019 sumrise. All rights reserved.
//

#import "SMRGlobalCache.h"
#import "SDImageCache.h"
#import "YYDiskCache.h"
#import "SMRLog.h"

@interface SMRGlobalCache ()

@property (strong, nonatomic) NSMutableDictionary *allCaches;

@property (copy  , nonatomic) NSString *name;
@property (strong, nonatomic) SDImageCache *imageCache;
@property (strong, nonatomic) YYDiskCache *diskCache;

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

+ (instancetype)defaultUnnecessaryCache {
    return [self cacheWithName:@"SMRGlobalCacheUnnecessary" unnecessary:YES];
}

+ (instancetype)cacheWithName:(NSString *)name {
    return [self p_cacheWithName:name unnecessary:NO];
}

+ (instancetype)cacheWithName:(NSString *)name unnecessary:(BOOL)unnecessary {
    return [self p_cacheWithName:name unnecessary:unnecessary];
}

+ (instancetype)p_cacheWithName:(NSString *)name unnecessary:(BOOL)unnecessary {
    if (!name) {
        NSAssert(nil, @"SMRGlobalCache name 不能为空");
        return nil;
    }
    SMRGlobalCache *cache = [SMRGlobalCache globalCache].allCaches[name];
    if (!cache) {
        cache = [[SMRGlobalCache alloc] init];
        cache.name = name;
        [[SMRGlobalCache globalCache].allCaches setObject:cache forKey:name];
        // fix: 兼容SD老版本的缓存位置改变的问题
        [self fix_sdwebview_caches_path_changedWithName:name];
        // 仅每次启动的首次设置有效
        [self p_updateCacheInfo:name unnecessary:@(unnecessary)];
    }
    return cache;
}

+ (NSString *)directorInRootCaches {
    NSString *fileDoc = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    return fileDoc;
}

+ (NSString *)directorInGlobalCaches:(NSString *)cacheNames {
    NSString *fileDoc = [self directorInRootCaches];
    fileDoc = [fileDoc stringByAppendingPathComponent:@"com.basecore.SMRGlobalCache"];
    fileDoc = [fileDoc stringByAppendingPathComponent:cacheNames];
    return fileDoc;
}

+ (void)fix_sdwebview_caches_path_changedWithName:(NSString *)name {
    NSString *cachesDirectory = [self directorInRootCaches];
    NSString *oldPath = [cachesDirectory stringByAppendingFormat:@"/%@/com.hackemist.SDWebImageCache.%@", name, name];
    NSString *newPath = [cachesDirectory stringByAppendingFormat:@"/com.hackemist.SDImageCache/%@", name];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:oldPath]) {
        [fileManager createDirectoryAtPath:newPath withIntermediateDirectories:YES attributes:nil error:nil];
        NSError *error = nil;
        NSArray *contents = [fileManager contentsOfDirectoryAtPath:oldPath error:&error];
        for(NSString *sourceFileName in contents) {
            NSString *sourceFile = [oldPath stringByAppendingPathComponent:sourceFileName];
            NSString *destFile = [newPath stringByAppendingPathComponent:sourceFileName];
            if (![fileManager moveItemAtPath:sourceFile toPath:destFile error:&error]) {
                base_core_log(@"Error: %@", error);
            }
        }
        [fileManager removeItemAtPath:oldPath error:nil];
    }
}

#pragma mark - Meta Caches

static NSString *const kSMRGlobalMetaCacheName = @"SMRGlobalMetaCache";
static NSString *const kMetaCache = @"kMetaCache";

+ (NSArray<NSString *> *)p_allCacheNames {
    SMRGlobalCache *gcache = [SMRGlobalCache cacheWithName:kSMRGlobalMetaCacheName];
    NSDictionary *status = (NSDictionary *)[gcache objectForKey:kMetaCache];
    return status.allKeys;
}

+ (NSArray<NSString *> *)p_unnecessaryCacheNames {
    SMRGlobalCache *gcache = [SMRGlobalCache cacheWithName:kSMRGlobalMetaCacheName];
    NSDictionary *status = (NSDictionary *)[gcache objectForKey:kMetaCache];
    NSMutableArray *mnames = [NSMutableArray array];
    [status enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if (((NSNumber *)obj).boolValue) {
            [mnames addObject:key];
        }
    }];
    return [mnames copy];
}

/// 仅每次启动的首次调用设置状态有效
+ (void)p_updateCacheInfo:(NSString *)name unnecessary:(nullable NSNumber *)unnecessary {
    SMRGlobalCache *gcache = [SMRGlobalCache cacheWithName:kSMRGlobalMetaCacheName];
    NSDictionary *status = (NSDictionary *)[gcache objectForKey:kMetaCache];
    NSMutableDictionary *mstatus = [status mutableCopy];
    if (!mstatus) {
        mstatus = [NSMutableDictionary dictionary];
    }
    mstatus[name] = unnecessary;
    [gcache setObject:mstatus forKey:kMetaCache];
}

#pragma mark - Utils

- (int32_t)p_cacheSize {
    int32_t size = 0;
    size += self.imageCache.totalDiskSize;
    size += self.diskCache.totalCost;
    return size;
}

- (void)p_clearAllCaches {
    [self removeAllImages];
    [self removeAllObjects];
}

+ (int32_t)cacheSize {
    int32_t size = 0;
    NSArray<NSString *> *names = [self p_allCacheNames];
    for (NSString *name in names) {
        size += [self cacheSizeWithName:name];
    }
    return size;
}

+ (int32_t)cacheSizeForUnnecessary {
    int32_t size = 0;
    NSArray<NSString *> *names = [self p_unnecessaryCacheNames];
    for (NSString *name in names) {
        size += [self cacheSizeWithName:name];
    }
    return size;
}

+ (int32_t)cacheSizeWithName:(NSString *)name {
    SMRGlobalCache *gcache = [SMRGlobalCache cacheWithName:name];
    return [gcache p_cacheSize];
}

+ (void)clearAllCaches {
    NSArray<NSString *> *names = [self p_allCacheNames];
    for (NSString *name in names) {
        [self clearCachesWithName:name];
    }
}

+ (void)clearUnnecessaryCaches {
    NSArray<NSString *> *names = [self p_unnecessaryCacheNames];
    for (NSString *name in names) {
        [self clearCachesWithName:name];
    }
}

+ (void)clearCachesWithName:(NSString *)name {
    SMRGlobalCache *gcache = [SMRGlobalCache cacheWithName:name];
    [gcache p_clearAllCaches];
}

#pragma mark - CacheForImage

- (void)cacheImage:(UIImage *)image key:(NSString *)key {
    [self.imageCache storeImage:image forKey:key completion:nil];
}
- (void)setImage:(UIImage *)image forKey:(NSString *)key {
    [self.imageCache storeImage:image forKey:key completion:nil];
}
- (void)setImageToMemory:(UIImage *)image forKey:(NSString *)key {
    [self.imageCache storeImageToMemory:image forKey:key];
}
- (void)setImageToDisk:(UIImage *)image forKey:(NSString *)key {
    [self.imageCache storeImage:image imageData:nil forKey:key cacheType:SDImageCacheTypeDisk completion:nil];
}
- (void)setImageDataToDisk:(NSData *)imageData forKey:(NSString *)key {
    [self.imageCache storeImageDataToDisk:imageData forKey:key];
}
- (UIImage *)imageWithKey:(NSString *)key {
    return [self.imageCache imageFromCacheForKey:key];
}
- (NSData *)imageDataWithKey:(NSString *)key {
    return [self.imageCache diskImageDataForKey:key];
}
- (void)removeImageWithKey:(NSString *)key {
    [self.imageCache removeImageForKey:key withCompletion:nil];
}
- (void)removeAllImages {
    [self.imageCache clearMemory];
    [self.imageCache clearDiskOnCompletion:nil];
    _imageCache = nil;
}

#pragma mark - CacheForObject

- (void)setObject:(nullable id<NSCoding>)object forKey:(NSString *)key {
    [self.diskCache setObject:object forKey:key];
}
- (nullable id<NSCoding>)objectForKey:(NSString *)key {
    return [self.diskCache objectForKey:key];
}
- (void)objectForKey:(NSString *)key withBlock:(void (^)(NSString *key, id<NSCoding> object))block {
    [self.diskCache objectForKey:key withBlock:block];
}
- (void)removeObjectForKey:(NSString *)key {
    [self.diskCache removeObjectForKey:key];
}
- (void)removeAllObjects {
    [self.diskCache removeAllObjects];
    _diskCache = nil;
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
        _imageCache = [[SDImageCache alloc] initWithNamespace:self.name];
    }
    return _imageCache;
}

- (YYDiskCache *)diskCache {
    if (!_diskCache) {
        _diskCache = [[YYDiskCache alloc] initWithPath:[self.class directorInGlobalCaches:self.name]];
        _diskCache.name = self.name;
    }
    return _diskCache;
}

@end
