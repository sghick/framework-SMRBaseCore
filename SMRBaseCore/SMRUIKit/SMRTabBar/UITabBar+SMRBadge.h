//
//  UITabBar+SMRBadge.h
//  SMRBaseCoreDemo
//
//  Created by 丁治文 on 2019/5/31.
//  Copyright © 2019 sumrise. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSUInteger const SMRTabBarBadgeStartTag       = 8801000;
static NSUInteger const SMRTabBarBadgeTextStartTag   = 8802000;
static NSUInteger const SMRTabBarBadgeNumberStartTag = 8803000;

@interface UITabBar (SMRBadge)

/**
 显示普通小红点
 
 @param index tabBar的索引位置(0~4)
 */
- (void)showBadgeAtItemIndex:(NSUInteger)index;

/**
 显示带数值的小红点
 
 @param number 要显示的数值
 @param index tabBar的索引位置(0~4)
 */
- (void)showBadgeNumber:(NSInteger)number atItemIndex:(NSUInteger)index;

/**
 显示带文本的小红点
 
 @param badgeText 要显示的文本
 @param index tabBar的索引位置(0~4)
 */
- (void)showBadgeText:(NSString *)badgeText atItemIndex:(NSUInteger)index;

/**
 隐藏普通小红点
 
 @param index tabBar的索引位置(0~4)
 */
- (void)hideBadgeAtItemIndex:(NSUInteger)index;

/**
 隐藏带数值的小红点
 
 @param index tabBar的索引位置(0~4)
 */
- (void)hideBadgeNumberAtItemIndex:(NSUInteger)index;

/**
 隐藏带文本的小红点
 
 @param index tabBar的索引位置(0~4)
 */
- (void)hideBadgeTextAtItemIndex:(NSUInteger)index;

/**
 隐藏当前索引位置下的所有情况的红点
 
 @param index tabBar的索引位置(0~4)
 */
- (void)hideAllBadgeAtItemIndex:(NSUInteger)index;

/**
 隐藏所有情况的红点
 */
- (void)hideAllBadge;

@end
