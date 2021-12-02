//
//  UIImageView+SMR.m
//  SMRBaseCoreDemo
//
//  Created by 丁治文 on 2019/8/5.
//  Copyright © 2019 sumrise. All rights reserved.
//

#import "UIImageView+SMR.h"
#import <Photos/Photos.h>
#import "UIImage+SMRAdapter.h"
#import "SMRGlobalCache.h"

@implementation SMRPHAssetResult

+ (instancetype)result:(UIImage *)image info:(NSDictionary *)info {
    SMRPHAssetResult *result = [[SMRPHAssetResult alloc] init];
    result.image = image;
    result.info = info;
    return result;
}

- (BOOL)isInCloud {
    return [self.info[PHImageResultIsInCloudKey] boolValue];
}

- (BOOL)isDegraded {
    return [self.info[PHImageResultIsDegradedKey] boolValue];
}

- (PHImageRequestID)requestID {
    return [self.info[PHImageResultRequestIDKey] intValue];
}

- (BOOL)isCancelled {
    return [self.info[PHImageCancelledKey] boolValue];
}

- (NSError *)error {
    return self.info[PHImageErrorKey];
}

@end

@implementation UIImageView (SMR)

- (void)smr_setAnimatedImage:(UIImage *)animatedImage {
    [self smr_setAnimatedImage:animatedImage repeatCount:0];
}

- (void)smr_setAnimatedImage:(UIImage *)animatedImage repeatCount:(NSInteger)repeatCount {
    if (animatedImage.images.count == 0) {
        self.image = animatedImage;
    } else {
        self.image = animatedImage.images.firstObject;
        self.animationImages = animatedImage.images;
        self.animationDuration = animatedImage.duration;
        self.animationRepeatCount = repeatCount;
        [self startAnimating];
    }
}

- (void)smr_setImageWithAsset:(PHAsset *)asset {
    [self smr_setImageWithAsset:asset fitWidth:asset.pixelWidth];
}

- (void)smr_setImageWithAsset:(PHAsset *)asset fitWidth:(CGFloat)fitWidth {
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    // 异步设置
    options.resizeMode = PHImageRequestOptionsResizeModeFast;
    options.networkAccessAllowed = YES;
    // 设置图片
    [self smr_setImageWithAsset:asset options:options fitWidth:fitWidth];
}

- (void)smr_setImageWithAsset:(PHAsset *)asset options:(PHImageRequestOptions *)options fitWidth:(CGFloat)fitWidth {
    [self smr_setImageWithAsset:asset options:options fitWidth:fitWidth resultHandler:nil];
}

- (void)smr_setImageWithAsset:(PHAsset *)asset
                      options:(PHImageRequestOptions *)options
                     fitWidth:(CGFloat)fitWidth
                resultHandler:(void (^)(UIImage *_Nullable result, NSDictionary *_Nullable info))resultHandler {
    UIImage *cache = [SMRGlobalCache.defaultUnnecessaryCache imageWithKey:asset.localIdentifier];
    if (cache) {
        self.image = cache;
        if (resultHandler) {
            resultHandler(cache, nil);
        }
        return;
    }
    
    CGFloat scale = fitWidth/asset.pixelWidth;
    CGSize targetSize = CGSizeMake(scale*asset.pixelWidth, scale*asset.pixelHeight);
    // 从asset中获得图片
    [self.class smr_requestImageForAsset:asset
                              targetSize:targetSize
                             contentMode:PHImageContentModeDefault
                                 options:options
                           resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        self.image = result;
        [SMRGlobalCache.defaultUnnecessaryCache setImageToMemory:result forKey:asset.localIdentifier];
        if (resultHandler) {
            resultHandler(result, info);
        }
    }];
}

+ (void)smr_requestImageForAsset:(PHAsset *)asset
                      targetSize:(CGSize)targetSize
                     contentMode:(PHImageContentMode)contentMode
                         options:(nullable PHImageRequestOptions *)options
                   resultHandler:(void (^)(UIImage *_Nullable result, NSDictionary *_Nullable info))resultHandler {
    dispatch_async(dispatch_queue_create("view.view.asset.request", NULL), ^{
        [PHImageManager.defaultManager requestImageForAsset:asset
                                                 targetSize:targetSize
                                                contentMode:contentMode
                                                    options:options
                                              resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (resultHandler) {
                    resultHandler(result, info);
                }
            });
        }];
    });
}

+ (void)smr_requestImageForAssets:(NSArray<PHAsset *> *)assets
                         fitWidth:(CGFloat)fitWidth
                      contentMode:(PHImageContentMode)contentMode
                          options:(PHImageRequestOptions *)options
                      targetCount:(NSInteger)targetCount
                    resultHandler:(BOOL (^)(SMRPHAssetResult *result))resultHandler
                   resultHandlers:(void (^)(NSArray<SMRPHAssetResult *> * _Nonnull))resultHandlers {
    dispatch_async(dispatch_queue_create("view.view.asset.request", NULL), ^{
        NSMutableArray *results = [@[] mutableCopy];
        for (PHAsset *asset in assets) {
            CGFloat scale = fitWidth ? (fitWidth/asset.pixelWidth) : 1;
            CGSize targetSize = CGSizeMake(scale*asset.pixelWidth, scale*asset.pixelHeight);
            [PHImageManager.defaultManager requestImageForAsset:asset
                                                     targetSize:targetSize
                                                    contentMode:contentMode
                                                        options:options
                                                  resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                SMRPHAssetResult *rst = [SMRPHAssetResult result:result info:info];
                BOOL use = YES;
                if (resultHandler) {
                    use = resultHandler(rst);
                }
                if (use) {
                    [results addObject:rst];
                }
            }];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if (resultHandlers) {
                resultHandlers(results);
            }
        });
    });
}

- (void)smr_setImageWithVideoURL:(NSURL *)videoURL atTime:(NSTimeInterval)time {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.image = [UIImage smr_imageForVideoURL:videoURL atTime:time];
    });
}

@end
