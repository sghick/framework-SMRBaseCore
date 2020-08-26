//
//  UIView+SMRBadge.m
//  SMRBaseCoreDemo
//
//  Created by Tinswin on 2020/7/26.
//  Copyright © 2020 sumrise. All rights reserved.
//

#import "UIView+SMRBadge.h"
#import "PureLayout.h"

@implementation SMRBadgeItem

@end

@implementation UIView (SMRBadge)

- (SMRBadgeView *)badgeViewWithParentView:(UIView *)parentView badgeItem:(SMRBadgeItem *)badgeItem tag:(NSInteger)tag {
    SMRBadgeView *badgeView = [self viewWithTag:tag];
    if (!badgeView || ![badgeView isKindOfClass:[SMRBadgeView class]]) {
        badgeView = [[SMRBadgeView alloc] init];
        badgeView.tag = tag;
        [parentView addSubview:badgeView];
        
        badgeView.needsRemoveLayouts = [badgeView autoPinEdgesToSuperviewEdges];
    }
    if (badgeItem) {
        badgeView.badgeTextFont = badgeItem.textFont;
        badgeView.badgeTextColor = badgeItem.textColor;
        badgeView.badgeBackgroundColor = badgeItem.backgroundColor;
        badgeView.minWidth = badgeItem.minWidth;
        badgeView.badgeOffset = badgeItem.badgeOffset;
        badgeView.animation = badgeItem.animation;
        badgeView.alignment = badgeItem.alignment;
        badgeView.anchor = badgeItem.anchor;
    }
    return badgeView;
}

- (void)showBadgeTextWithCount:(NSInteger)count maxCount:(NSInteger)maxCount alingment:(SMRBadgeAlignment)alingment badgeItem:(SMRBadgeItem *)badgeItem {
    badgeItem.alignment = alingment;
    [self showBadgeTextWithCount:count maxCount:maxCount badgeItem:badgeItem];
}

- (void)showBadgeText:(NSString *)text alingment:(SMRBadgeAlignment)alingment badgeItem:(nullable SMRBadgeItem *)badgeItem {
    badgeItem.alignment = alingment;
    [self showBadgeText:text badgeItem:badgeItem];
}

- (void)showBadgeTextWithCount:(NSInteger)count maxCount:(NSInteger)maxCount badgeItem:(SMRBadgeItem *)badgeItem {
    NSString *badgeText = nil;
    if (count > maxCount) {
        badgeText = [NSString stringWithFormat:@"%@+", @(maxCount)];
    } else if (count > 0) {
        badgeText = [NSString stringWithFormat:@"%@", @(count)];
    } else {
        badgeText = nil;
    }
    [self showBadgeText:badgeText badgeItem:badgeItem];
}

- (void)showBadgeText:(NSString *)text badgeItem:(SMRBadgeItem *)badgeItem {
    if (text.length) {
        SMRBadgeView *badgeView = [self badgeViewWithParentView:self badgeItem:badgeItem tag:kTagForDefaultSMRBadgeText];
        badgeView.badgeText = text;
    } else {
        [self removeBadge];
    }
}

- (void)removeBadge {
    SMRBadgeView *badgeView = [self viewWithTag:kTagForDefaultSMRBadgeText];
    if (badgeView && [badgeView isKindOfClass:[SMRBadgeView class]]) {
        [badgeView.needsRemoveLayouts autoRemoveConstraints];
        [badgeView removeFromSuperview];
    }
}

@end
