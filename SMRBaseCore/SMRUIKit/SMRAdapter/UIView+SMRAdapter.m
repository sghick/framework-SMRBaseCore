//
//  UIView+SMRAdapter.m
//  SMRBaseCoreDemo
//
//  Created by 丁治文 on 2019/2/18.
//  Copyright © 2019 sumrise. All rights reserved.
//

#import "UIView+SMRAdapter.h"
#import "SMRUIAdapter.h"
#import "PureLayout.h"

@implementation UIView (SMRAdapter)

- (UIView *)setSafeAreaViewWithColor:(UIColor *)color {
    return [self setSafeAreaViewWithColor:color height:BOTTOM_HEIGHT];
}

- (UIView *)setSafeAreaViewWithColor:(UIColor *)color fromBottomOfView:(UIView *)fromBottomOfView {
    NSArray<NSLayoutConstraint *> *layouts = nil;
    return [self setSafeAreaViewWithColor:color orFromBottomOfView:fromBottomOfView orHeight:0 layouts:&layouts];
}

- (UIView *)setSafeAreaViewWithColor:(UIColor *)color fromBottomOfView:(UIView *)fromBottomOfView layouts:(NSArray<NSLayoutConstraint *> *__autoreleasing *)layouts {
    return [self setSafeAreaViewWithColor:color orFromBottomOfView:fromBottomOfView orHeight:0 layouts:layouts];
}

- (UIView *)setSafeAreaViewWithColor:(UIColor *)color height:(CGFloat)height {
    NSArray<NSLayoutConstraint *> *layouts = nil;
    return [self setSafeAreaViewWithColor:color orFromBottomOfView:nil orHeight:height layouts:&layouts];
}

- (UIView *)setSafeAreaViewWithColor:(UIColor *)color height:(CGFloat)height layouts:(NSArray<NSLayoutConstraint *> **)layouts {
    return [self setSafeAreaViewWithColor:color orFromBottomOfView:nil orHeight:height layouts:layouts];
}

- (UIView *)setSafeAreaViewWithColor:(UIColor *)color
                  orFromBottomOfView:(UIView *)orFromBottomOfView
                            orHeight:(CGFloat)orHeight
                             layouts:(NSArray<NSLayoutConstraint *> **)layouts {
    if (!orFromBottomOfView && (orHeight == 0)) {
        return nil;
    }
    UIView *view = [self viewWithTag:kTagForSMRAdapterBottomView];
    if (view) {
        view.backgroundColor = color;
        return view;
    }
    view = [[UIView alloc] init];
    view.backgroundColor = color;
    view.tag = kTagForSMRAdapterBottomView;
    [self addSubview:view];
    
    *layouts = [NSLayoutConstraint autoCreateAndInstallConstraints:^{
        [view autoPinEdgeToSuperviewEdge:ALEdgeBottom];
        [view autoPinEdgeToSuperviewEdge:ALEdgeLeft];
        [view autoPinEdgeToSuperviewEdge:ALEdgeRight];
        if (orFromBottomOfView) {
            NSAssert(orFromBottomOfView.superview, @"请为它设置一个父类");
            [view autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:orFromBottomOfView];
        } else {
            [view autoSetDimension:ALDimensionHeight toSize:orHeight];
        }
    }];
    
    return view;
}

- (void)updateSafeAreaViewColor:(UIColor *)color {
    UIView *view = [self viewWithTag:kTagForSMRAdapterBottomView];
    if (view) {
        view.backgroundColor = color;
    }
}

@end
