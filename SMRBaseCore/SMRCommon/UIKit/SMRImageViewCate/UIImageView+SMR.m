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
    // 是否要原图
    CGFloat scale = fitWidth/asset.pixelWidth;
    CGSize size = CGSizeMake(scale*asset.pixelWidth, scale*asset.pixelHeight);
    // 从asset中获得图片
    [[PHImageManager defaultManager] requestImageForAsset:asset
                                               targetSize:size
                                              contentMode:PHImageContentModeDefault
                                                  options:options
                                            resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                                                self.image = result;
                                            }];
}

- (void)smr_setImageWithVideoURL:(NSURL *)videoURL atTime:(NSTimeInterval)time {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.image = [UIImage smr_imageForVideoURL:videoURL atTime:time];
    });
}

@end
