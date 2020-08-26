//
//  SMRBadgeViewTests.m
//  SMRBaseCoreDemo
//
//  Created by Tinswin on 2020/7/26.
//  Copyright © 2020 sumrise. All rights reserved.
//

#import "SMRBadgeViewTests.h"
#import "UIView+SMRBadge.h"

@implementation SMRBadgeViewTests

- (id)begin {
    [self testBadgeTextAlignment];
    [self testBadgeTextOffset];
    [self testBadgeTextAnchor];
    return self;
}

- (void)testBadgeTextAlignment {
    for (int i = 0; i < SMRBadgeAlignmentCenter + 1; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(20, 100 + ((50 + 10)*i), 100, 50);
        button.backgroundColor = [UIColor greenColor];
        [button setTitle:[NSString stringWithFormat:@"测试按钮%@", @(i)] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(_testBadgeTextAction:) forControlEvents:UIControlEventTouchUpInside];
        SMRBadgeItem *item = [[SMRBadgeItem alloc] init];
        item.backgroundColor = [UIColor smr_generalRedColor];
        item.textFont = [UIFont smr_systemFontOfSize:14];
        item.textColor = [UIColor smr_whiteColor];
        item.alignment = (SMRBadgeAlignment)i;
        [button showBadgeText:[NSString stringWithFormat:@"%@", @(i)] badgeItem:item];
        [[UIApplication sharedApplication].delegate.window addSubview:button];
    }
}

- (void)testBadgeTextOffset {
    for (int i = 0; i < SMRBadgeAlignmentCenter + 1; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(20 + 110, 100 + ((50 + 10)*i), 100, 50);
        button.backgroundColor = [UIColor greenColor];
        [button setTitle:[NSString stringWithFormat:@"测试按钮%@", @(i)] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(_testBadgeTextAction:) forControlEvents:UIControlEventTouchUpInside];
        SMRBadgeItem *item = [[SMRBadgeItem alloc] init];
        item.backgroundColor = [UIColor blueColor];
        item.textFont = [UIFont smr_systemFontOfSize:11];
        item.textColor = [UIColor smr_whiteColor];
        item.badgeOffset = CGPointMake(5, 5);
        item.alignment = (SMRBadgeAlignment)i;
        item.animation = [SMRBadgeView opacityForever_Animation:1.4];
        [button showBadgeText:[NSString stringWithFormat:@"%@", @(i)] badgeItem:item];
        [[UIApplication sharedApplication].delegate.window addSubview:button];
    }
}

- (void)testBadgeTextAnchor {
    for (int i = 0; i < SMRBadgeAnchorBottomLeft + 1; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(20 + 220, 100 + ((50 + 10)*i), 100, 50);
        button.backgroundColor = [UIColor greenColor];
        [button setTitle:[NSString stringWithFormat:@"测试按钮%@", @(i)] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(_testBadgeTextAction:) forControlEvents:UIControlEventTouchUpInside];
        SMRBadgeItem *item = [[SMRBadgeItem alloc] init];
        item.backgroundColor = [UIColor smr_generalOrangeColor];
        item.textFont = [UIFont smr_systemFontOfSize:11];
        item.textColor = [UIColor smr_whiteColor];
        item.anchor = (SMRBadgeAnchor)i;
        
        [button showBadgeText:[NSString stringWithFormat:@"%@", @(i)] badgeItem:item];
        [[UIApplication sharedApplication].delegate.window addSubview:button];
    }
}

- (void)_testBadgeTextAction:(UIButton *)sender {
    [sender removeFromSuperview];
}

@end
