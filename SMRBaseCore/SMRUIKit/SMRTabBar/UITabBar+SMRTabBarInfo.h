//
//  UITabBar+SMRTabBarInfo.h
//  SMRBaseCoreDemo
//
//  Created by 丁治文 on 2019/5/31.
//  Copyright © 2019 sumrise. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITabBar (TabBarInfo)

/// 根据 Index 获取 UITabBarButton
- (UIButton *)tabBarButtonAtIndex:(NSUInteger)index;

/// 根据 UITabBarButton 获取 UITabBarButtonLabel
- (UILabel *)tabBarButtonLabelAtTabBarButton:(UIButton *)tabBarButton;
/// 根据 Index 获取 UITabBarButtonLabel
- (UILabel *)tabBarButtonLabelAtIndex:(NSUInteger)index;

/// 根据 UITabBarButton 获取 UITabBarSwappableImageView
- (UIImageView *)tabBarSwappableImageViewAtTabBarButton:(UIButton *)tabBarButton;
/// 根据 Index 获取 UITabBarSwappableImageView
- (UIImageView *)tabBarSwappableImageViewAtIndex:(NSUInteger)index;

/// 获取 UITabBar 上所有的 UITabBarButton
- (NSArray<UIButton *> *)tabBarButtonsArray;

@end
