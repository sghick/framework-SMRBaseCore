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
    [self smr_setImageWithAsset:asset options:options fitWidth:fitWidth resultHandler:nil completionHandlder:nil];
}

- (void)smr_setImageWithAsset:(PHAsset *)asset
                      options:(PHImageRequestOptions *)options
                     fitWidth:(CGFloat)fitWidth
                resultHandler:(void (^)(UIImage *_Nullable result, NSDictionary *_Nullable info))resultHandler
           completionHandlder:(void (^)(PHImageRequestID requestID))completionHandlder {
    CGFloat scale = fitWidth/asset.pixelWidth;
    CGSize size = CGSizeMake(scale*asset.pixelWidth, scale*asset.pixelHeight);
    // 从asset中获得图片
    [self.class smr_requestImageForAsset:asset
                              targetSize:size
                             contentMode:PHImageContentModeDefault
                                 options:options
                           resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        self.image = result;
        if (resultHandler) {
            resultHandler(result, info);
        }
    } completionHandlder:completionHandlder];
}

+ (void)smr_requestImageForAsset:(PHAsset *)asset
                      targetSize:(CGSize)targetSize
                     contentMode:(PHImageContentMode)contentMode
                         options:(nullable PHImageRequestOptions *)options
                   resultHandler:(void (^)(UIImage *_Nullable result, NSDictionary *_Nullable info))resultHandler
              completionHandlder:(void (^)(PHImageRequestID requestID))completionHandlder {
    dispatch_async(dispatch_queue_create("image.view.asset", NULL), ^{
        PHImageRequestID requestID =
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
        if (completionHandlder) {
            completionHandlder(requestID);
        }
    });
}

- (void)smr_setImageWithVideoURL:(NSURL *)videoURL atTime:(NSTimeInterval)time {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.image = [UIImage smr_imageForVideoURL:videoURL atTime:time];
    });
}

@end
