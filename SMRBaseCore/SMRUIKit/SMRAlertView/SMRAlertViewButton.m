//
//  SMRAlertViewButton.m
//  SMRBaseCoreDemo
//
//  Created by 丁治文 on 2019/2/14.
//  Copyright © 2019 sumrise. All rights reserved.
//

#import "SMRAlertViewButton.h"
#import "SMRMatrixCalculator.h"
#import "SMRAdapter.h"
#import "PureLayout.h"
#import "SMRGeneralButton.h"
#import "SMRBaseCoreConfig.h"
#import "SMRAlertView.h"

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

+ (UIButton *)buttonTitle:(NSString *)title target:(id)target action:(SEL)action function:(SMRAlertViewButtonFunction)function {
    return [self buttonTitle:title target:target action:action style:[SMRBaseCoreConfig sharedInstance].alertViewStyle function:function];
}

+ (UIButton *)buttonTitle:(NSString *)title target:(id)target action:(SEL)action style:(SMRAlertViewStyle)style function:(SMRAlertViewButtonFunction)function {
    switch (function) {
        case SMRAlertViewButtonFunctionSure:
            return [self sureButtonTitle:title target:target action:action style:style];
            break;
        
        case SMRAlertViewButtonFunctionCancel:
            return [self cancelButtonTitle:title target:target action:action style:style];
            break;
        
        case SMRAlertViewButtonFunctionDelete:
            return [self deleteButtonTitle:title target:target action:action style:style];
            break;
        default:
            break;
    }
    return nil;
}

+ (UIButton *)cancelButtonTitle:(NSString *)title target:(id)target action:(SEL)action style:(SMRAlertViewStyle)style {
    switch (style) {
        case SMRAlertViewStyleWhite : {
            SMRGeneralButton *btn = [SMRGeneralButton rectButtonWithTitle:title target:target action:action];
            [btn setRectButtonEnumColor:SMRGeneralButtonColorWhite];
            btn.layer.borderWidth = 1.0/[UIScreen mainScreen].scale;
            btn.layer.borderColor = [UIColor smr_colorWithHexRGB:@"#EBEBEB"].CGColor;
            return btn;
        }
            break;
        case SMRAlertViewStyleOrange : {
            SMRGeneralButton *btn = [SMRGeneralButton rectButtonWithTitle:title target:target action:action];
            [btn setRectButtonEnumColor:SMRGeneralButtonColorWhite];
            btn.layer.borderWidth = 1.0/[UIScreen mainScreen].scale;
            btn.layer.borderColor = [UIColor smr_colorWithHexRGB:@"#EBEBEB"].CGColor;
            return btn;
        }
            break;
            
        default:
            break;
    }
    return nil;
}
+ (UIButton *)sureButtonTitle:(NSString *)title target:(id)target action:(SEL)action style:(SMRAlertViewStyle)style {
    switch (style) {
        case SMRAlertViewStyleWhite : {
            SMRGeneralButton *btn = [SMRGeneralButton rectButtonWithTitle:title target:target action:action];
            [btn setRectButtonEnumColor:SMRGeneralButtonColorBlack];
            return btn;
        }
            break;
        case SMRAlertViewStyleOrange : {
            SMRGeneralButton *btn = [SMRGeneralButton rectButtonWithTitle:title target:target action:action];
            [btn setRectButtonEnumColor:SMRGeneralButtonColorOrange];
            return btn;
        }
            break;
            
        default:
            break;
    }
    return nil;
}

+ (UIButton *)deleteButtonTitle:(NSString *)title target:(id)target action:(SEL)action style:(SMRAlertViewStyle)style {
    switch (style) {
        case SMRAlertViewStyleWhite : {
            SMRGeneralButton *btn = [SMRGeneralButton rectButtonWithTitle:title target:target action:action];
            [btn setRectButtonEnumColor:SMRGeneralButtonColorRed];
            return btn;
        }
            break;
        case SMRAlertViewStyleOrange : {
            SMRGeneralButton *btn = [SMRGeneralButton rectButtonWithTitle:title target:target action:action];
            [btn setRectButtonEnumColor:SMRGeneralButtonColorRed];
            return btn;
        }
            break;
            
        default:
            break;
    }
    return nil;
}

@end
