//
//  UIImageView+SMR.h
//  SMRBaseCoreDemo
//
//  Created by 丁治文 on 2019/8/5.
//  Copyright © 2019 sumrise. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class PHAsset;
@class PHImageRequestOptions;
@interface UIImageView (SMR)

/** 设置动图 */
- (void)smr_setAnimatedImage:(UIImage *)animatedImage;
- (void)smr_setAnimatedImage:(UIImage *)animatedImage repeatCount:(NSInteger)repeatCount;

/** 默认高清图 */
- (void)smr_setImageWithAsset:(PHAsset *)asset;
- (void)smr_setImageWithAsset:(PHAsset *)asset fitWidth:(CGFloat)fitWidth;
- (void)smr_setImageWithAsset:(PHAsset *)asset options:(PHImageRequestOptions *)options fitWidth:(CGFloat)fitWidth;

/** 设置视频某一帧的图片 */
- (void)bds_setImageWithVideoURL:(NSURL *)videoURL atTime:(NSTimeInterval)time;

@end

NS_ASSUME_NONNULL_END
