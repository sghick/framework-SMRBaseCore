//
//  SMRGlobalCache.h
//  SMRBaseCoreDemo
//
//  Created by 丁治文 on 2019/3/14.
//  Copyright © 2019 sumrise. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SMRGlobalCache : NSObject

+ (instancetype)defaultCache;
+ (instancetype)defaultUnnecessaryCache;
+ (instancetype)cacheWithName:(NSString *)name;
/** 仅每次启动的首次调用设置unnecessary状态有效 */
+ (instancetype)cacheWithName:(NSString *)name unnecessary:(BOOL)unnecessary;

/** 所有缓的存数(Bit) */
+ (int32_t)cacheSize;
/** 非必要的缓存数(Bit) */
+ (int32_t)cacheSizeForUnnecessary;
/** 某个缓存块的缓存数(Bit) */
+ (int32_t)cacheSizeWithName:(NSString *)name;

/** 清除所有的缓存 */
+ (void)clearAllCaches;
/** 清除非必要的缓存 */
+ (void)clearUnnecessaryCaches;
/** 清除某个缓存块的缓存 */
+ (void)clearCachesWithName:(NSString *)name;

#pragma mark - CacheForImage 独立缓存
- (NSString *)imageCachePathForKey:(NSString *)key;
- (void)cacheImage:(UIImage *)image key:(NSString *)key __deprecated_msg("已废弃,使用-[SMRGlobalCache setImage:forKey:]");
/** memory and disk */
- (void)setImage:(UIImage *)image forKey:(NSString *)key completion:(nullable void (^)(void))completion;
- (void)setImageToMemory:(UIImage *)image forKey:(NSString *)key;
- (void)setImageToDisk:(UIImage *)image forKey:(NSString *)key completion:(nullable void (^)(void))completion;
- (void)setImageDataToDisk:(NSData *)imageData forKey:(NSString *)key;
/** memory or disk */
- (UIImage *)imageWithKey:(NSString *)key;
/** disk only */
- (NSData *)imageDataWithKey:(NSString *)key;
/** memory and disk */
- (void)removeImageWithKey:(NSString *)key completion:(nullable void (^)(void))completion;
- (void)removeImageFromMemoryWithKey:(NSString *)key;
- (void)removeImageFromDiskWithKey:(NSString *)key;
/** memory and disk */
- (void)removeAllImagesWithCompletion:(nullable void (^)(void))completion;

#pragma mark - CacheForObject 独立缓存
- (void)setObject:(nullable id<NSCoding>)object forKey:(NSString *)key;
- (nullable id<NSCoding>)objectForKey:(NSString *)key;
- (void)objectForKey:(NSString *)key withBlock:(void (^)(NSString *key, id<NSCoding> object))block;
- (void)removeObjectForKey:(NSString *)key;
- (void)removeAllObjects;

@end

NS_ASSUME_NONNULL_END
