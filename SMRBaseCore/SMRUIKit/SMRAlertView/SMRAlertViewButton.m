//
//  SMRAlertViewButton.m
//  SMRBaseCoreDemo
//
//  Created by 丁治文 on 2019/2/14.
//  Copyright © 2019 sumrise. All rights reserved.
//

#import "SMRAlertViewButton.h"
#import "SMRAdapter.h"
#import "SMRMatrixCalculator.h"
#import "PureLayout.h"

@interface SMRAlertViewButton ()

@property (assign, nonatomic) BOOL didLoadLayout;

@end

@implementation SMRAlertViewButton

- (instancetype)initWithButtons:(NSArray<UIView *> *)buttons height:(CGFloat)height space:(CGFloat)space {
    self = [super init];
    if (self) {
        [self createSubviewsWithButtons:buttons height:height space:space];
    }
    return self;
}

- (void)createSubviewsWithButtons:(NSArray<UIView *> *)buttons height:(CGFloat)height space:(CGFloat)space {
    if (buttons.count == 0) {
        return;
    }
    if (buttons.count == 1) {
        [self addSubview:buttons.firstObject];
        [buttons.firstObject autoCenterInSuperview];
        [buttons.firstObject autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self];
        [buttons.firstObject autoSetDimension:ALDimensionHeight toSize:height];
    }
    if (buttons.count == 2) {
        [self addSubview:buttons.firstObject];
        [self addSubview:buttons.lastObject];
        
        CGFloat onepix = 1/[UIScreen mainScreen].scale;
        [buttons.firstObject autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
        [buttons.firstObject autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:-onepix];
        [buttons.firstObject autoConstrainAttribute:ALAttributeRight toAttribute:ALAttributeVertical ofView:self withOffset:-space/2.0];
        [buttons.firstObject autoSetDimension:ALDimensionHeight toSize:height];
        
        [buttons.lastObject autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
        [buttons.lastObject autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:-onepix];
        [buttons.lastObject autoConstrainAttribute:ALAttributeLeft toAttribute:ALAttributeVertical ofView:self withOffset:space/2.0];
        [buttons.lastObject autoSetDimension:ALDimensionHeight toSize:height];
    }
}

+ (UIButton *)whiteButtonWithTitle:(NSString *)title target:(id)target action:(SEL)action deepColor:(BOOL)deepColor {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:(deepColor ? [UIColor redColor] : [UIColor blackColor]) forState:UIControlStateNormal];
    [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    button.backgroundColor = (deepColor ? [UIColor whiteColor] : [UIColor whiteColor]);
    button.titleLabel.font = [UIFont smr_systemFontOfSize:15.0];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    button.layer.borderColor = (deepColor ? [UIColor smr_colorWithHexRGB:@"#979797"].CGColor : [UIColor smr_colorWithHexRGB:@"#979797"].CGColor);
    button.layer.borderWidth = 1.0/[UIScreen mainScreen].scale;
    return button;
}

+ (UIButton *)orangeButtonWithTitle:(NSString *)title target:(id)target action:(SEL)action deepColor:(BOOL)deepColor {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:(deepColor ? [UIColor whiteColor] : [UIColor blackColor]) forState:UIControlStateNormal];
    [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    button.backgroundColor = (deepColor ? [UIColor smr_colorWithHexRGB:@"#F19722"] : [UIColor whiteColor]);
    button.titleLabel.font = [UIFont smr_systemFontOfSize:15.0];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    button.layer.borderColor = (deepColor ? [UIColor smr_colorWithHexRGB:@"#F19722"].CGColor : [UIColor smr_colorWithHexRGB:@"#979797"].CGColor);
    button.layer.borderWidth = 1.0/[UIScreen mainScreen].scale;
    return button;
}

@end
