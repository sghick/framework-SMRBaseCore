//
//  SMRNavigationBar.m
//  SMRGeneralUseDemo
//
//  Created by 丁治文 on 2019/1/11.
//  Copyright © 2019 sumrise. All rights reserved.
//

#import "SMRNavigationBar.h"
#import "PureLayout.h"
#import "SMRUIAdapter.h"

@interface SMRNavigationBar ()

@property (nonatomic, strong) NSMutableDictionary *needsToRemoveViews;
@property (nonatomic, strong) NSMutableDictionary *needsToRemoveLayouts;

@end

@implementation SMRNavigationBar

@synthesize item = _item;
@synthesize backgroundImageView = _backgroundImageView;
@synthesize contentView = _contentView;
@synthesize splitLine = _splitLine;

- (instancetype)init {
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), [SMRNavigationBar navigationItem].heightOfNavigation);
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self createBaseNavigationBarSubviews];
    }
    return self;
}

- (void)createBaseNavigationBarSubviews {
    [self addSubview:self.backgroundImageView];
    [self addSubview:self.contentView];
    [self addSubview:self.splitLine];
}

- (void)updateConstraints {
    if (!self.didLoadLayouts) {
        _didLoadLayouts = YES;
        // splitLine
        [self.splitLine autoPinEdgeToSuperviewEdge:ALEdgeLeft];
        [self.splitLine autoPinEdgeToSuperviewEdge:ALEdgeRight];
        [self.splitLine autoPinEdgeToSuperviewEdge:ALEdgeBottom];
        [self.splitLine autoSetDimension:ALDimensionHeight toSize:LINE_HEIGHT];
    }
    [super updateConstraints];
}

- (void)layoutSubviews {
    [super layoutSubviews];

    CGFloat top = self.topOfContentView;
    self.contentView.frame = CGRectMake(0, top, CGRectGetWidth([UIScreen mainScreen].bounds), self.item.heightOfNavigationContent);
    self.backgroundImageView.frame = CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), self.item.heightOfNavigation);
}

/**
 NavigationView的默认参数
 */
+ (SMRNavigationItem *)navigationItem {
    SMRNavigationItem *item = [[SMRNavigationItem alloc] init];
    // default
    item.leftMargin = 20;
    item.rightMargin = 20;
    item.heightOfNavigationContent = 44.0;
    item.heightOfNavigation = item.heightOfNavigationContent + TOPWITHSTATUSBAR_HEIGHT;
    return item;
}

#pragma mark - SMRNavigationBarProtocol

- (CGFloat)topOfContentView {
    return self.item.heightOfNavigation - self.item.heightOfNavigationContent;
}

#pragma mark - ContentViews

- (void)addSubviews:(NSArray *)subviews tag:(nonnull NSString *)tag {
    if (!subviews) {
        return;
    }
    self.needsToRemoveViews[tag] = [subviews arrayByAddingObjectsFromArray:self.needsToRemoveViews[tag]];
    for (UIView *view in subviews) {
        [self.contentView addSubview:view];
    }
}

- (void)addLayoutConstraints:(void(^)(void))constraints tag:(nonnull NSString *)tag {
    NSArray *layouts = [NSLayoutConstraint autoCreateAndInstallConstraints:constraints];
    if (!layouts) {
        return;
    }
    self.needsToRemoveLayouts[tag] = [layouts arrayByAddingObjectsFromArray:self.needsToRemoveLayouts[tag]];
}

- (void)removeSubviewsWithTag:(NSString *)tag {
    // 移除约束
    [self.needsToRemoveLayouts[tag] autoRemoveConstraints];
    // 移除view
    NSArray *views = self.needsToRemoveViews[tag];
    for (UIView *view in views) {
        [view removeFromSuperview];
    }
}

#pragma mark - Setters

- (void)setItem:(SMRNavigationItem *)item {
    _item = item;
    [self setNeedsLayout];
}

#pragma mark - Getters

- (SMRNavigationItem *)item {
    if (!_item) {
        _item = [self.class navigationItem];
    }
    return _item;
}

- (UIImageView *)backgroundImageView {
    if (_backgroundImageView == nil) {
        UIImageView *view = [[UIImageView alloc] init];
        view.frame = CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), self.item.heightOfNavigation);
        view.contentMode = UIViewContentModeScaleToFill;
        _backgroundImageView = view;
    }
    return _backgroundImageView;
}

- (UIView *)contentView {
    if (_contentView == nil) {
        CGFloat top = self.topOfContentView;
        UIView *view = [[UIView alloc] init];
        view.frame = CGRectMake(0, top, CGRectGetWidth([UIScreen mainScreen].bounds), self.item.heightOfNavigationContent);
        _contentView = view;
    }
    return _contentView;
}

- (UIView *)splitLine {
    if (_splitLine == nil) {
        UIView *splitLine = [[UIView alloc] init];
        _splitLine = splitLine;
    }
    return _splitLine;
}

- (NSMutableDictionary *)needsToRemoveViews {
    if (!_needsToRemoveViews) {
        _needsToRemoveViews = [NSMutableDictionary dictionary];
    }
    return _needsToRemoveViews;
}

- (NSMutableDictionary *)needsToRemoveLayouts {
    if (!_needsToRemoveLayouts) {
        _needsToRemoveLayouts = [NSMutableDictionary dictionary];
    }
    return _needsToRemoveLayouts;
}

@end
