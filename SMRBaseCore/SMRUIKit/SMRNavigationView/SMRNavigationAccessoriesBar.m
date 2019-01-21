//
//  SMRNavigationAccessoriesBar.m
//  SMRBaseCoreDemo
//
//  Created by 丁治文 on 2019/1/21.
//  Copyright © 2019 sumrise. All rights reserved.
//

#import "SMRNavigationAccessoriesBar.h"
#import "PureLayout.h"

static NSString * const kTagForLeftViews = @"kTagForLeftViews";
static NSString * const kTagForRightViews = @"kTagForRightViews";
static NSString * const kTagForCenterViews = @"kTagForCenterViews";

@implementation SMRNavigationAccessoriesBar

- (void)setLeftViews:(nullable NSArray<UIView *> *)leftViews {
    _leftViews = leftViews;
    _leftView = leftViews.firstObject;
    [self removeSubviewsWithTag:kTagForLeftViews];
    [self addSubviews:leftViews tag:kTagForLeftViews];
    __block UIView *lastView = nil;
    __block CGSize viewSize = self.leftViewSize;
    [self addLayoutConstraints:^{
        for (UIView *leftView in leftViews) {
            if (lastView) {
                [leftView autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:lastView];
            } else {
                [leftView autoPinEdgeToSuperviewEdge:ALEdgeLeft];
            }
            [leftView autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
            [leftView autoSetDimensionsToSize:viewSize];
            
            lastView = leftView;
        }
    } tag:kTagForLeftViews];
}

- (void)setRightViews:(nullable NSArray<UIView *> *)rightViews {
    _rightViews = rightViews;
    _rightView = rightViews.firstObject;
    [self removeSubviewsWithTag:kTagForRightViews];
    [self addSubviews:rightViews tag:kTagForRightViews];
    __block UIView *lastView = nil;
    __block CGSize viewSize = self.rightViewSize;
    [self addLayoutConstraints:^{
        for (UIView *rightView in rightViews) {
            if (lastView) {
                [rightView autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:lastView];
            } else {
                [rightView autoPinEdgeToSuperviewEdge:ALEdgeRight];
            }
            [rightView autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
            [rightView autoSetDimensionsToSize:viewSize];
            
            lastView = rightView;
        }
    } tag:kTagForRightViews];
}

- (void)setLeftView:(nullable UIView *)leftView {
    _leftView = leftView;
    self.leftViews = leftView ? @[leftView] : nil;
}

- (void)setRightView:(nullable UIView *)rightView {
    _rightView = rightView;
    self.rightViews = rightView ? @[rightView] : nil;
}

- (void)setCenterView:(UIView *)centerView {
    _centerView = centerView;
    [self removeSubviewsWithTag:kTagForCenterViews];
    if (centerView) {
        [self addSubviews:@[centerView] tag:kTagForCenterViews];
        [self addLayoutConstraints:^{
            [centerView autoCenterInSuperview];
        } tag:kTagForCenterViews];
    }
}

@end
