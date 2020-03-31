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
#import "SMRUIKitBundle.h"

@interface SMRAlertViewButton ()

@property (assign, nonatomic) BOOL didLoadLayout;

@end

@implementation SMRAlertViewButton

- (instancetype)initWithButtons:(NSArray<UIView *> *)buttons {
    return [self initWithButtons:buttons space:0];
}

- (instancetype)initWithButtons:(NSArray<UIView *> *)buttons space:(CGFloat)space {
    return [self initWithButtons:buttons height:[SMRAlertViewButton generalHeightOfButton] space:space];
}

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
        [buttons.firstObject autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:-0.5];
        [buttons.firstObject autoAlignAxisToSuperviewAxis:ALAxisVertical];
        [buttons.firstObject autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self];
        [buttons.firstObject autoSetDimension:ALDimensionHeight toSize:height];
    }
    if (buttons.count == 2) {
        [self addSubview:buttons.firstObject];
        [self addSubview:buttons.lastObject];
        
        [buttons.firstObject autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:-0.5];
        [buttons.firstObject autoPinEdgeToSuperviewEdge:ALEdgeLeft];
        [buttons.firstObject autoConstrainAttribute:ALAttributeRight toAttribute:ALAttributeVertical ofView:self withOffset:-space/2.0];
        [buttons.firstObject autoSetDimension:ALDimensionHeight toSize:height];
        
        [buttons.lastObject autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:-0.5];
        [buttons.lastObject autoPinEdgeToSuperviewEdge:ALEdgeRight];
        [buttons.lastObject autoConstrainAttribute:ALAttributeLeft toAttribute:ALAttributeVertical ofView:self withOffset:space/2.0];
        [buttons.lastObject autoSetDimension:ALDimensionHeight toSize:height];
    }
}

+ (CGFloat)generalHeightOfButton {
    return [SMRAlertViewButton generalHeightOfButtonWithStyle:[SMRBaseCoreConfig sharedInstance].alertViewStyle];
}

+ (CGFloat)generalHeightOfButtonWithStyle:(SMRAlertViewStyle)style {
    return [SMRUIAdapter value:50];
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
            UIImage *image = [SMRUIKitBundle imageNamed:@"alert_left_btn@3x"];
            [btn setBackgroundImage:image forState:UIControlStateNormal];
            return btn;
        }
            break;
        case SMRAlertViewStyleOrange : {
            SMRGeneralButton *btn = [SMRGeneralButton rectButtonWithTitle:title target:target action:action];
            [btn setRectButtonEnumColor:SMRGeneralButtonColorWhite];
            UIImage *image = [SMRUIKitBundle imageNamed:@"alert_left_btn@3x"];
            [btn setBackgroundImage:image forState:UIControlStateNormal];
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
