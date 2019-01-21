//
//  UIImage+SMR.m
//  SMRBaseCoreDemo
//
//  Created by 丁治文 on 2019/1/21.
//  Copyright © 2019 sumrise. All rights reserved.
//

#import "UIImage+SMR.h"

@implementation UIImage (SMR)

+ (UIImage *)smr_imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0, 0, 1, 1);
    // 画布
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    // 画笔颜色
    [color setFill];
    UIRectFill(rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (UIImage *)smr_imageWithChangeToColor:(UIColor *)color {
    CGRect bounds = CGRectMake(0, 0, self.size.width, self.size.height);
    // 画布
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0f);
    // 画笔颜色
    [color setFill];
    UIRectFill(bounds);
    // 第一次绘制(覆盖,保留灰度信息)
    [self drawInRect:bounds blendMode:kCGBlendModeOverlay alpha:1.0f];
    // 第二次绘制(保留透明信息)
    [self drawInRect:bounds blendMode:kCGBlendModeDestinationIn alpha:1.0f];
    // 获取图片
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (UIImage *)smr_imageWithChangeToSize:(CGSize)size {
    // 画布
    UIGraphicsBeginImageContext(size);
    // 改变尺寸
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    // 获取图片
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
