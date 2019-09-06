//
//  UIView+SMRBadge.m
//  Hermes
//
//  Created by 丁治文 on 2019/7/10.
//  Copyright © 2019 ibaodashi. All rights reserved.
//

#import "UIView+SMRBadge.h"
#import "JSBadgeView.h"

@implementation SMRBadgeItem

@end

@implementation UIView (SMRBadge)

- (JSBadgeView *)badgeViewWithParentView:(UIView *)parentView alingment:(SMRBadgeAlignment)alingment badgeItem:(SMRBadgeItem *)badgeItem tag:(NSInteger)tag {
    JSBadgeView *badgeView = [self viewWithTag:tag];
    if (!badgeView || ![badgeView isKindOfClass:[JSBadgeView class]]) {
        JSBadgeViewAlignment jsalingment = (JSBadgeViewAlignment)alingment;
        badgeView = [[JSBadgeView alloc] initWithParentView:parentView alignment:jsalingment];
    }
    if (badgeItem) {
        badgeView.badgeTextFont = badgeItem.textFont;
        badgeView.badgeTextColor = badgeItem.textColor;
        badgeView.badgeBackgroundColor = badgeItem.backgroundColor;
    }
    return badgeView;
}

- (void)showBadgeText:(NSString *)text alingment:(SMRBadgeAlignment)alingment badgeItem:(SMRBadgeItem *)badgeItem {
    JSBadgeView *badgeView = [self badgeViewWithParentView:self alingment:alingment badgeItem:badgeItem tag:kTagForDefaultSMRBadgeText];
    badgeView.badgeText = text;
}

- (void)removeBadge {
    JSBadgeView *badgeView = [self viewWithTag:kTagForDefaultSMRBadgeText];
    if (badgeView && [badgeView isKindOfClass:[JSBadgeView class]]) {
        [badgeView removeFromSuperview];
    }
}

@end
