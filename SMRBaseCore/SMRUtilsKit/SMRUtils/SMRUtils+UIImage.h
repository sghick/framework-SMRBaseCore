//
//  SMRUtils+UIImage.h
//  SMRBaseCoreDemo
//
//  Created by 丁治文 on 2019/2/14.
//  Copyright © 2019 sumrise. All rights reserved.
//

#import "SMRUtils.h"

NS_ASSUME_NONNULL_BEGIN

@interface SMRUtils (UIImage)

/** 将整个view转换成图片 */
+ (UIImage *)transformViewToImage:(UIView *)view;

/** 将整个scrollView的内容视图转换成图片 */
+ (UIImage *)transformScrollViewToImage:(UIScrollView *)scrollView;

/** 创建一个相应颜色大小的矩形图片(1*1) */
+ (UIImage *)createImageWithColor:(UIColor *)color;
+ (UIImage *)createImageWithColor:(UIColor *)color rect:(CGRect)rect;

/** 改变图片的颜色 */
+ (UIImage *)changeImage:(UIImage *)image toColor:(UIColor *)toColor;

/** 改变图片的尺寸 */
+ (UIImage *)changeImage:(UIImage *)image toSize:(CGSize)toSize;

/** 改变图片的尺寸,并以fit模式缩放 */
+ (UIImage *)changeImage:(UIImage *)image toFitSize:(CGSize)toFitSize;

@end

NS_ASSUME_NONNULL_END
