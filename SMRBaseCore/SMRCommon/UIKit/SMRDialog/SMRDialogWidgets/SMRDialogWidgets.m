//
//  SMRDialogWidgets.m
//  Hermes
//
//  Created by Tinswin on 2021/3/27.
//  Copyright © 2021 ibaodashi. All rights reserved.
//

#import "SMRDialogWidgets.h"
#import "PureLayout.h"

@implementation SMRDialogWidget

+ (instancetype)child:(UIView *)child insets:(UIEdgeInsets)insets {
    return [[self alloc] initWithChild:child insets:insets];
}

- (instancetype)initWithChild:(UIView *)child insets:(UIEdgeInsets)insets {
    self = [super init];
    if (self) {
        _insets = insets;
        _child = child;
        [self p_createSubviewsWithChild:child insets:(UIEdgeInsets)insets];
    }
    return self;
}

- (void)p_createSubviewsWithChild:(UIView *)child insets:(UIEdgeInsets)insets {
    if (!child) {
        return;
    }
    [self addSubview:child];
    [child autoPinEdgesToSuperviewEdgesWithInsets:insets];
}

@end
