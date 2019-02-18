//
//  UIView+SMRAdapter.h
//  SMRBaseCoreDemo
//
//  Created by 丁治文 on 2019/2/18.
//  Copyright © 2019 sumrise. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (SMRAdapter)

- (UIView *)addSafeAreaViewWithColor:(UIColor *)color height:(CGFloat)height {
    return [self addSafeAreaViewWithColor:color height:height layouts:nil];
}

- (UIView *)addSafeAreaViewWithColor:(UIColor *)color height:(CGFloat)height layouts:(NSArray<NSLayoutConstraint *> * _Nullable *)layouts {
    UIView *view = [self viewWithTag:kTagForBDSAdapterBottomView];
    if (view) {
        view.backgroundColor = color;
        return view;
    }
    view = [[UIView alloc] init];
    view.backgroundColor = color;
    view.tag = kTagForBDSAdapterBottomView;
    [self addSubview:view];
    
    *layouts = [NSLayoutConstraint autoCreateAndInstallConstraints:^{
        [view autoPinEdgeToSuperviewEdge:ALEdgeBottom];
        [view autoPinEdgeToSuperviewEdge:ALEdgeLeft];
        [view autoPinEdgeToSuperviewEdge:ALEdgeRight];
        [view autoSetDimension:ALDimensionHeight toSize:height];
    }];
    
    return view;
}

- (void)updateSafeAreaViewColor:(UIColor *)color {
    UIView *view = [self viewWithTag:kTagForBDSAdapterBottomView];
    if (view) {
        view.backgroundColor = color;
    }
}

@end

NS_ASSUME_NONNULL_END
