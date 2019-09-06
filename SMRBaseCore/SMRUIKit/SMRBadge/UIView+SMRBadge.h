//
//  UIView+SMRBadge.h
//  Hermes
//
//  Created by 丁治文 on 2019/7/10.
//  Copyright © 2019 ibaodashi. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

static NSInteger const kTagForDefaultSMRBadgeText = 384723;

typedef NS_ENUM(NSUInteger, SMRBadgeAlignment) {
    SMRBadgeAlignmentTopLeft = 1,
    SMRBadgeAlignmentTopRight,
    SMRBadgeAlignmentTopCenter,
    SMRBadgeAlignmentCenterLeft,
    SMRBadgeAlignmentCenterRight,
    SMRBadgeAlignmentBottomLeft,
    SMRBadgeAlignmentBottomRight,
    SMRBadgeAlignmentBottomCenter,
    SMRBadgeAlignmentCenter,
};

@interface SMRBadgeItem : NSObject

@property (strong, nonatomic) UIColor *textColor;
@property (strong, nonatomic) UIFont *textFont;
@property (strong, nonatomic) UIColor *backgroundColor;
@property (assign, nonatomic) CGFloat minWidth;

@end

@interface UIView (SMRBadge)

- (void)showBadgeText:(NSString *)text alingment:(SMRBadgeAlignment)alingment badgeItem:(SMRBadgeItem *)badgeItem;
- (void)removeBadge;

@end

NS_ASSUME_NONNULL_END
