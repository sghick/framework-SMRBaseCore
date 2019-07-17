//
//  UIView+BDSBadge.h
//  Hermes
//
//  Created by 丁治文 on 2019/7/10.
//  Copyright © 2019 ibaodashi. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

static NSInteger const kTagForDefaultBDSBadgeText = 384723;

typedef NS_ENUM(NSUInteger, BDSBadgeAlignment) {
    BDSBadgeAlignmentTopLeft = 1,
    BDSBadgeAlignmentTopRight,
    BDSBadgeAlignmentTopCenter,
    BDSBadgeAlignmentCenterLeft,
    BDSBadgeAlignmentCenterRight,
    BDSBadgeAlignmentBottomLeft,
    BDSBadgeAlignmentBottomRight,
    BDSBadgeAlignmentBottomCenter,
    BDSBadgeAlignmentCenter,
};

@interface BDSBadgeItem : NSObject

@property (strong, nonatomic) UIColor *textColor;
@property (strong, nonatomic) UIFont *textFont;
@property (strong, nonatomic) UIColor *backgroundColor;
@property (assign, nonatomic) CGFloat minWidth;

@end

@interface UIView (BDSBadge)

- (void)showBadgeText:(NSString *)text alingment:(BDSBadgeAlignment)alingment badgeItem:(BDSBadgeItem *)badgeItem;
- (void)removeBadge;

@end

NS_ASSUME_NONNULL_END
