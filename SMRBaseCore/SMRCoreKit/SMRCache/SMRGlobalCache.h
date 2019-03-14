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
+ (instancetype)cacheWithName:(NSString *)name;

- (void)cacheImage:(UIImage *)image key:(NSString *)key;
- (UIImage *)imageWithKey:(NSString *)key;
- (void)removeImageWithKey:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
