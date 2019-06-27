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

- (UIView *)setSafeAreaViewWithColor:(UIColor *)color height:(CGFloat)height {
    if (height == 0) {
        return nil;
    }
    UIView *view = [self safeAreaView];
    if (view) {
        view.backgroundColor = color;
        return view;
    }
    view = [[UIView alloc] init];
    view.backgroundColor = color;
    view.tag = kTagForSMRAdapterBottomView;
    [self addSubview:view];
    
    [view autoPinEdgeToSuperviewEdge:ALEdgeBottom];
    [view autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [view autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [view autoSetDimension:ALDimensionHeight toSize:height];
    return view;
}

- (UIView *)safeAreaView {
    UIView *view = [self viewWithTag:kTagForSMRAdapterBottomView];
    return view;
}

- (void)bringSafeAreaViewToFront {
    UIView *view = [self safeAreaView];
    if (view) {
        [self bringSubviewToFront:view];
    }
}

- (void)updateSafeAreaViewColor:(UIColor *)color {
    UIView *view = [self safeAreaView];
    if (view) {
        view.backgroundColor = color;
    }
}

@end
