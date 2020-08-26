//
//  UIView+SMRBadge.h
//  SMRBaseCoreDemo
//
//  Created by Tinswin on 2020/7/26.
//  Copyright © 2020 sumrise. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMRBadgeView.h"

NS_ASSUME_NONNULL_BEGIN

static NSInteger const kTagForDefaultSMRBadgeText = 384723;

@interface SMRBadgeItem : NSObject

@property (strong, nonatomic) UIColor *textColor;
@property (strong, nonatomic) UIFont *textFont;
@property (strong, nonatomic) UIColor *backgroundColor;
@property (assign, nonatomic) CGFloat minWidth;
@property (assign, nonatomic) CGPoint badgeOffset;
@property (strong, nonatomic) CAAnimation *animation;
@property (assign, nonatomic) SMRBadgeAlignment alignment;
@property (assign, nonatomic) SMRBadgeAnchor anchor;

@end

@interface UIView (SMRBadge)

- (void)showBadgeTextWithCount:(NSInteger)count maxCount:(NSInteger)maxCount badgeItem:(nullable SMRBadgeItem *)badgeItem;
- (void)showBadgeTextWithCount:(NSInteger)count maxCount:(NSInteger)maxCount alingment:(SMRBadgeAlignment)alingment badgeItem:(nullable SMRBadgeItem *)badgeItem __deprecated_msg("即将废弃");
- (void)showBadgeText:(NSString *)text badgeItem:(nullable SMRBadgeItem *)badgeItem;
- (void)showBadgeText:(NSString *)text alingment:(SMRBadgeAlignment)alingment badgeItem:(nullable SMRBadgeItem *)badgeItem __deprecated_msg("即将废弃");
- (void)removeBadge;

@end

NS_ASSUME_NONNULL_END
