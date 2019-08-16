//
//  UIImageView+SMR.h
//  SMRBaseCoreDemo
//
//  Created by 丁治文 on 2019/8/5.
//  Copyright © 2019 sumrise. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImageView (SMR)

/** 设置动图 */
- (void)smr_setAnimatedImage:(UIImage *)animatedImage;
- (void)smr_setAnimatedImage:(UIImage *)animatedImage repeatCount:(NSInteger)repeatCount;

/** 默认高清图 */
- (void)smr_setImageWithAsset:(PHAsset *)asset;
- (void)smr_setImageWithAsset:(PHAsset *)asset minWidth:(CGFloat)minWidth;
- (void)smr_setImageWithAsset:(PHAsset *)asset options:(PHImageRequestOptions *)options minWidth:(CGFloat)minWidth;

@end

NS_ASSUME_NONNULL_END