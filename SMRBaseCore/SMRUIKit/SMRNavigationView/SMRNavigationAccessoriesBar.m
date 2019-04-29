//
//  SMRNavigationAccessoriesBar.m
//  SMRBaseCoreDemo
//
//  Created by 丁治文 on 2019/1/21.
//  Copyright © 2019 sumrise. All rights reserved.
//

#import "SMRNavigationAccessoriesBar.h"
#import "PureLayout.h"
#import "SMRAdapter.h"

static NSString * const kTagForLeftViews = @"kTagForLeftViews";
static NSString * const kTagForRightViews = @"kTagForRightViews";
static NSString * const kTagForCenterViews = @"kTagForCenterViews";

@implementation SMRNavigationAccessoriesBar

- (instancetype)init {
    self = [super init];
    if (self) {
        _leftMargin = 20;
        _rightMargin = 20;
        _space = 10;
    }
    return self;
}

- (void)setLeftViews:(nullable NSArray<UIView *> *)leftViews {
    _leftViews = leftViews;
    _leftView = leftViews.firstObject;
    [self removeSubviewsWithTag:kTagForLeftViews];
    [self addSubviews:leftViews tag:kTagForLeftViews];
    __block UIView *lastView = nil;
    __block CGSize viewSize = self.leftViewSize;
    typeof(self) weakSelf = self;
    [self addLayoutConstraints:^{
        for (UIView *leftView in leftViews) {
            if (lastView) {
                [leftView autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:lastView withOffset:weakSelf.space];
            } else {
                [leftView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:weakSelf.leftMargin];
            }
            [leftView autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
            // 优先使用view的size
            CGSize useSize = CGSizeEqualToSize(leftView.frame.size, CGSizeZero) ? viewSize : leftView.frame.size;
            // 如未设置size,则自适应
            if (!CGSizeEqualToSize(useSize, CGSizeZero)) {
                [leftView autoSetDimensionsToSize:useSize];
            }
            
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
    typeof(self) weakSelf = self;
    [self addLayoutConstraints:^{
        for (UIView *rightView in rightViews) {
            if (lastView) {
                [rightView autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:lastView withOffset:-weakSelf.space];
            } else {
                [rightView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:weakSelf.rightMargin];
            }
            [rightView autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
            // 优先使用view的size
            CGSize useSize = CGSizeEqualToSize(rightView.frame.size, CGSizeZero) ? viewSize : rightView.frame.size;
            // 如未设置size,则自适应
            if (!CGSizeEqualToSize(useSize, CGSizeZero)) {
                [rightView autoSetDimensionsToSize:useSize];
            }
            
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
            [centerView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:[SMRUIAdapter value:45] relation:NSLayoutRelationGreaterThanOrEqual];
            [centerView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:[SMRUIAdapter value:45] relation:NSLayoutRelationGreaterThanOrEqual];
        } tag:kTagForCenterViews];
    }
}

- (void)removeViewFromLeftViews:(UIView *)view {
    NSMutableArray *leftViews = [self.leftViews mutableCopy];
    [leftViews removeObject:view];
    _leftViews = [leftViews copy];
}

- (void)removeViewFromRightViews:(UIView *)view {
    NSMutableArray *rightViews = [self.rightViews mutableCopy];
    [rightViews removeObject:view];
    _rightViews = [rightViews copy];
}

@end
