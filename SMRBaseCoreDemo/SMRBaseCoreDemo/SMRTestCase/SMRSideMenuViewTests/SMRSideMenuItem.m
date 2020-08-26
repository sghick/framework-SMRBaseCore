//
//  SMRSideMenuItem.m
//  SMRBaseCoreDemo
//
//  Created by Tinswin on 2020/4/27.
//  Copyright © 2020 sumrise. All rights reserved.
//

#import "SMRSideMenuItem.h"
#import "SMRBaseCore.h"
#import <PureLayout.h>
#import <SDWebImage.h>

@implementation SMRSideMenuItemParams

@end

@interface SMRSideMenuItem ()

@property (strong, nonatomic) UIImageView *iconView;
@property (strong, nonatomic) UILabel *titleLabel;

@property (assign, nonatomic) BOOL didLoadLayout;

@end

@implementation SMRSideMenuItem

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews {
    [self addSubview:self.titleLabel];
    [self addSubview:self.iconView];
    
    [self setNeedsUpdateConstraints];
}

- (void)updateConstraints {
    if (!self.didLoadLayout) {
        self.didLoadLayout = YES;
        [self.iconView autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
        [self.iconView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10];
        [self.iconView autoSetDimensionsToSize:CGSizeMake(16, 16)];
        
        [self.titleLabel autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
        [self.titleLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.iconView withOffset:10];
        [self.titleLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10];
    }
    [super updateConstraints];
}

#pragma mark - Setters

- (void)setTitleColor:(UIColor *)titleColor {
    _titleColor = titleColor;
    self.titleLabel.textColor = titleColor;
}

- (void)setTitleFont:(UIFont *)titleFont {
    _titleFont = titleFont;
    self.titleLabel.font = titleFont;
}

- (void)setTitle:(NSString *)title {
    _title = title;
    self.titleLabel.text = title;
}

- (void)setIcon:(NSString *)icon {
    _icon = icon;
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:icon]];
}

- (void)setBadge:(NSString *)badge {
    _badge = badge;
//    SMRBadgeItem *item = [[SMRBadgeItem alloc] init];
//    item.textFont = [UIFont smr_systemFontOfSize:9];
//    item.textColor = [UIColor smr_whiteColor];
//    item.backgroundColor = [UIColor smr_generalOrangeColor];
//    [self.iconView showBadgeText:badge alingment:SMRBadgeAlignmentTopRight badgeItem:item];

//    dispatch_async(dispatch_get_main_queue(), ^{
//        [self setNeedsLayout];
//        [self layoutIfNeeded];
//        UIView *badgeView = [self.iconView viewWithTag:kTagForDefaultSMRBadgeText];
//        badgeView.left = 10;
//    });
}

#pragma mark - Getters

- (UIImageView *)iconView {
    if (!_iconView) {
        _iconView = [[UIImageView alloc] init];
    }
    return _iconView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
    }
    return _titleLabel;
}

#pragma mark - Uitls

+ (NSArray<UIView *> *)menuItemsWithParams:(NSArray<SMRSideMenuItemParams *> *)params {
    NSMutableArray *items = [NSMutableArray array];
    for (SMRSideMenuItemParams *obj in params) {
        SMRSideMenuItem *item = [[SMRSideMenuItem alloc] init];
        item.titleFont = [UIFont systemFontOfSize:13];
        item.titleColor = [UIColor smr_generalBlackColor];
        item.title = obj.title;
        item.icon = obj.icon;
        item.badge = obj.badge;
        [items addObject:item];
    }
    return items;
}

@end
