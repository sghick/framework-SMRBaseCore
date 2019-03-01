//
//  SMRUtils+UIImage.m
//  SMRBaseCoreDemo
//
//  Created by 丁治文 on 2019/2/14.
//  Copyright © 2019 sumrise. All rights reserved.
//

#import "SMRUtils+UIImage.h"

@implementation SMRUtils (UIImage)

+ (UIImage *)transformViewToImage:(UIView *)view {
    CGSize size = view.frame.size;
    if ([view isKindOfClass:[UIScrollView class]]) {
        assert(0);
    }
    
    UIGraphicsBeginImageContextWithOptions(size, NO, 2);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *combinationImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return combinationImage;
}

+ (UIImage *)transformScrollViewToImage:(UIScrollView *)scrollView {
    UIImage *image = nil;
    CGPoint savedContentOffset = scrollView.contentOffset;
    CGRect savedFrame = scrollView.frame;
    scrollView.contentOffset = CGPointZero;
    
    UIGraphicsBeginImageContextWithOptions(scrollView.contentSize, NO, 2);
    scrollView.frame = CGRectMake(0, 0, scrollView.contentSize.width, scrollView.contentSize.height);
    CGSize size = CGSizeMake(scrollView.frame.size.width*2, scrollView.frame.size.height*2);
    [scrollView setContentSize:size];
    [scrollView.layer renderInContext:UIGraphicsGetCurrentContext()];
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    scrollView.contentOffset = savedContentOffset;
    scrollView.frame = savedFrame;
    return image;
}

+ (UIImage *)createImageWithColor:(UIColor *)color {
    return [self createImageWithColor:color rect:CGRectMake(0, 0, 1, 1)];
}
+ (UIImage *)createImageWithColor:(UIColor *)color rect:(CGRect)rect {
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    [color setFill];
    UIRectFill(rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (UIImage *)changeImage:(UIImage *)image toColor:(UIColor *)toColor {
    CGRect bounds = CGRectMake(0, 0, image.size.width, image.size.height);
    UIGraphicsBeginImageContextWithOptions(image.size, NO, 0.0f);
    [toColor setFill];
    UIRectFill(bounds);
    // 第一次绘制(覆盖,保留灰度信息)
    [image drawInRect:bounds blendMode:kCGBlendModeOverlay alpha:1.0f];
    // 第二次绘制(保留透明信息)
    [image drawInRect:bounds blendMode:kCGBlendModeDestinationIn alpha:1.0f];
    UIImage *retImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return retImage;
}

+ (UIImage *)changeImage:(UIImage *)image toSize:(CGSize)toSize {
    UIGraphicsBeginImageContext(toSize);
    [image drawInRect:CGRectMake(0, 0, toSize.width, toSize.height)];
    UIImage *retImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return retImage;
}

+ (UIImage *)changeImage:(UIImage *)image toFitSize:(CGSize)toFitSize {
    CGSize toSize = toFitSize;
    CGFloat whPer = image.size.width/image.size.height;
    CGFloat whFitPer = toFitSize.width/toFitSize.height;
    if (whPer >= whFitPer) {
        toSize.height = toFitSize.width/whPer;
    } else {
        toSize.width = toFitSize.height*whPer;
    }
    return [self changeImage:image toSize:toSize];
}

@end
