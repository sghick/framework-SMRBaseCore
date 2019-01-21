//
//  UIImage+SMR.h
//  SMRBaseCoreDemo
//
//  Created by 丁治文 on 2019/1/21.
//  Copyright © 2019 sumrise. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (SMR)

/**
 创建一个相应颜色大小的矩形图片(1*1)
 */
+ (UIImage *)smr_imageWithColor:(UIColor *)color;

/**
 改变图片的颜色
 */
- (UIImage *)smr_imageWithChangeToColor:(UIColor *)color;

/**
 改变图片的尺寸
 */
- (UIImage *)smr_imageWithChangeToSize:(CGSize)size;

/**
 改变图片的尺寸
 
 @param size 目标尺寸
 @param opaque 是否反色,推荐设置:NO
 @param scale 设备屏幕比例([UIScreen mainScreen].scale)
 */
//- (UIImage *)smr_imageWithChangeToSize:(CGSize)size opaque:(BOOL)opaque scale:(CGFloat)scale;

@end

NS_ASSUME_NONNULL_END
