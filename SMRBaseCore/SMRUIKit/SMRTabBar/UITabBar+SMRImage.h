//
//  UITabBar+SMRImage.h
//  SMRBaseCoreDemo
//
//  Created by 丁治文 on 2019/5/31.
//  Copyright © 2019 sumrise. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITabBar (SMRImage)

/**
 显示tabBar上的动态图
 
 @param image         未选中的动态图, duration为此动态图的duration
 @param imageSize     未选中的动态图大小
 @param repeatTime    重复次数, 0为无限重复
 @param index         item位置(0~4)
 */
- (void)showAnimatedImage:(UIImage *)image imageSize:(CGSize)imageSize repeatTime:(NSInteger)repeatTime atIndex:(NSInteger)index;

/**
 隐藏tabBar上的动态图
 
 @param index item位置(0~4)
 */
- (void)hideAnimatedImageViewAtItemIndex:(NSInteger)index;

/**
 隐藏tabBar上所有的动态图
 */
- (void)hideAllAniatedImageView;

/**
 tabBar的动态图的imageView
 
 @param index item位置(0~4)
 @return tabBar的动态图
 */
- (UIImageView *)animatedImageViewAtItemIndex:(NSInteger)index;

@end
