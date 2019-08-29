//
//  SMRNavigationAccessoriesBar.m
//  SMRBaseCoreDemo
//
//  Created by 丁治文 on 2019/1/21.
//  Copyright © 2019 sumrise. All rights reserved.
//

#import "SMRNavigationAccessoriesBar.h"
#import <objc/runtime.h>
#import "PureLayout.h"
#import "SMRUIAdapter.h"

@implementation UIView (SMRNavigationAccessories)

// nav_accessories_space
static const char SMRAccessoriesSpacePropertyKey = '\0';
- (void)setNav_accessories_space:(CGFloat)nav_accessories_space {
    if (nav_accessories_space != self.nav_accessories_space) {
        objc_setAssociatedObject(self, &SMRAccessoriesSpacePropertyKey, @(nav_accessories_space), OBJC_ASSOCIATION_RETAIN);
    }
}

- (CGFloat)nav_accessories_space {
    NSNumber *nav_accessories_space = objc_getAssociatedObject(self, &SMRAccessoriesSpacePropertyKey);
    return nav_accessories_space.doubleValue;
}

@end

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
                CGFloat space = leftView.nav_accessories_space ?: weakSelf.space;
                [leftView autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:lastView withOffset:space];
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
                CGFloat space = rightView.nav_accessories_space ?: weakSelf.space;
                [rightView autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:lastView withOffset:-space];
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
    [self setCenterView:centerView margin:[SMRUIAdapter value:65]];
}

- (void)setCenterView:(UIView *)centerView margin:(CGFloat)margin {
    _centerView = centerView;
    [self removeSubviewsWithTag:kTagForCenterViews];
    if (centerView) {
        [self addSubviews:@[centerView] tag:kTagForCenterViews];
        [self addLayoutConstraints:^{
            [centerView autoCenterInSuperview];
            [centerView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:margin relation:NSLayoutRelationGreaterThanOrEqual];
            [centerView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:margin relation:NSLayoutRelationGreaterThanOrEqual];
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
