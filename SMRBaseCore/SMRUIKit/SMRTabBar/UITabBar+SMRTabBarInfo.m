//
//  UITabBar+SMRTabBarInfo.m
//  SMRBaseCoreDemo
//
//  Created by 丁治文 on 2019/5/31.
//  Copyright © 2019 sumrise. All rights reserved.
//

#import "UITabBar+SMRTabBarInfo.h"

@implementation UITabBar (TabBarInfo)

#pragma mark - UITabBarButton & UITabBarButtonLabel

- (UIButton *)tabBarButtonAtIndex:(NSUInteger)index {
    
    NSArray<UIButton *> *tabBarButtonArray = [self tabBarButtonsArray];
    if (index > tabBarButtonArray.count - 1) {
        return nil;
    }
    
    return tabBarButtonArray[index];
}

- (UIImageView *)tabBarSwappableImageViewAtIndex:(NSUInteger)index {
    
    UIButton *tabBarButton = [self tabBarButtonAtIndex:index];
    if (!tabBarButton) {
        return nil;
    }
    
    return [self tabBarSwappableImageViewAtTabBarButton:tabBarButton];
}

- (UILabel *)tabBarButtonLabelAtIndex:(NSUInteger)index {
    
    UIButton *tabBarButton = [self tabBarButtonAtIndex:index];
    if (!tabBarButton) {
        return nil;
    }
    
    return [self tabBarButtonLabelAtTabBarButton:tabBarButton];
}

- (UIImageView *)tabBarSwappableImageViewAtTabBarButton:(UIButton *)tabBarButton {
    
    __block UIImageView *tabBarSwappableImageView = nil;
    [tabBarButton.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:NSClassFromString(@"UITabBarSwappableImageView")]) {
            tabBarSwappableImageView = obj;
            *stop = YES;
        }
    }];
    return tabBarSwappableImageView;
}

- (UILabel *)tabBarButtonLabelAtTabBarButton:(UIButton *)tabBarButton {
    
    __block UILabel *tabBarButtonLabel = nil;
    [tabBarButton.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:NSClassFromString(@"UITabBarButtonLabel")]) {
            tabBarButtonLabel = obj;
            *stop = YES;
        }
    }];
    return tabBarButtonLabel;
}

- (NSArray<UIButton *> *)tabBarButtonsArray {
    
    NSMutableArray<UIButton *> *tabBarButtonsArray = [NSMutableArray array];
    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
            [tabBarButtonsArray addObject:obj];
        }
    }];
    
    [tabBarButtonsArray sortUsingComparator:^NSComparisonResult(UIView *  _Nonnull obj1, UIView *  _Nonnull obj2) {
        return obj1.frame.origin.x > obj2.frame.origin.x;
    }];
    
    return tabBarButtonsArray;
}

@end
