//
//  SMRGeneralButton.m
//  Gucci
//
//  Created by 丁治文 on 2019/1/23.
//  Copyright © 2019 sumrise. All rights reserved.
//

#import "SMRGeneralButton.h"
#import "SMRUIAdapter.h"
#import "UIColor+SMRTransform.h"
#import "UIFont+SMRAdapter.h"
#import "SMRUtils+UIImage.h"

@implementation SMRGeneralButton

+ (UIColor *)buttonColor:(SMRGeneralButtonColor)color {
    switch (color) {
        case SMRGeneralButtonColorOrange: { return [UIColor smr_generalOrangeColor];} break;
        case SMRGeneralButtonColorBlack: { return [UIColor smr_alertBlackColor];} break;
        case SMRGeneralButtonColorWhite: { return [UIColor smr_whiteColor];} break;
        case SMRGeneralButtonColorRed: { return [UIColor smr_generalRedColor];} break;
        // 默认颜色
        default: { return [UIColor smr_generalOrangeColor];} break;
    }
    return nil;
}

+ (UIColor *)buttonTitleColor:(SMRGeneralButtonColor)color {
    switch (color) {
        case SMRGeneralButtonColorOrange: { return [UIColor smr_whiteColor];} break;
        case SMRGeneralButtonColorBlack: { return [UIColor smr_whiteColor];} break;
        case SMRGeneralButtonColorWhite: { return [UIColor smr_alertBlackColor];} break;
        case SMRGeneralButtonColorRed: { return [UIColor smr_whiteColor];} break;
        // 默认颜色
        default: { return [UIColor smr_whiteColor];} break;
    }
    return nil;
}

+ (UIColor *)buttonBorderColor:(SMRGeneralButtonColor)color {
    switch (color) {
        case SMRGeneralButtonColorOrange: { return [UIColor smr_generalOrangeColor];} break;
        case SMRGeneralButtonColorBlack: { return [UIColor smr_darkGrayColor];} break;
        case SMRGeneralButtonColorWhite: { return [UIColor smr_whiteColor];} break;
        case SMRGeneralButtonColorRed: { return [UIColor smr_generalRedColor];} break;
        // 默认颜色
        default: { return [UIColor smr_generalOrangeColor];} break;
    }
    return nil;
}

+ (UIColor *)buttonBorderTitleColor:(SMRGeneralButtonColor)color {
    switch (color) {
        case SMRGeneralButtonColorOrange: { return [UIColor smr_generalOrangeColor];} break;
        case SMRGeneralButtonColorBlack: { return [UIColor smr_alertBlackColor];} break;
        case SMRGeneralButtonColorWhite: { return [UIColor smr_whiteColor];} break;
        case SMRGeneralButtonColorRed: { return [UIColor smr_generalRedColor];} break;
        // 默认颜色
        default: { return [UIColor smr_generalOrangeColor];} break;
    }
    return nil;
}

+ (instancetype)defaultButtonWithTitle:(NSString *)title
                                target:(id)target
                                action:(SEL)action
                           normalColor:(nullable UIColor *)normalColor
                          disableColor:(UIColor *)disableColor
                            titleColor:(nullable UIColor *)titleColor
                                  font:(nonnull UIFont *)font
                          cornerRadius:(CGFloat)cornerRadius {
    SMRGeneralButton *btn = [SMRGeneralButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    btn.titleLabel.font = font;
    if (normalColor) {
        [btn setBackgroundImage:[SMRUtils createImageWithColor:normalColor] forState:UIControlStateNormal];
    }
    [btn setBackgroundImage:[SMRUtils createImageWithColor:disableColor] forState:UIControlStateDisabled];
    if (titleColor) {
        [btn setTitleColor:titleColor forState:UIControlStateNormal];
    }
    if (cornerRadius) {
        btn.layer.cornerRadius = cornerRadius;
        btn.clipsToBounds = YES;
    }
    return btn;
}

#pragma mark - DefaultButton

+ (instancetype)defaultButtonWithTitle:(NSString *)title target:(id)target action:(SEL)action {
    SMRGeneralButton *btn = [self roundButtonWithTitle:title target:target action:action];
    return btn;
}

+ (instancetype)redButtonWithTitle:(NSString *)title target:(id)target action:(SEL)action {
    SMRGeneralButton *btn = [self roundButtonWithTitle:title target:target action:action];
    [btn setRoundButtonEnumColor:SMRGeneralButtonColorRed];
    return btn;
}

+ (instancetype)whiteButtonWithTitle:(NSString *)title target:(id)target action:(SEL)action {
    SMRGeneralButton *btn = [self roundButtonWithTitle:title target:target action:action];
    [btn setRoundButtonEnumColor:SMRGeneralButtonColorWhite];
    return btn;
}

#pragma mark - RoundButton 圆角

/// 设置背景和字体颜色
- (void)setRoundButtonEnumColor:(SMRGeneralButtonColor)color {
    [self setRoundButtonColor:[self.class buttonColor:color]
                   titleColor:[self.class buttonTitleColor:color]];
}
- (void)setRoundButtonColor:(nullable UIColor *)color titleColor:(nullable UIColor *)titleColor {
    if (color) {
        [self setBackgroundImage:[SMRUtils createImageWithColor:color] forState:UIControlStateNormal];
    }
    if (titleColor) {
        [self setTitleColor:titleColor forState:UIControlStateNormal];
    }
}
+ (instancetype)roundButtonWithTitle:(nullable NSString *)title target:(id)target action:(SEL)action {
    return [self roundButtonWithTitle:title
                                 font:[UIFont smr_boldSystemFontOfSize:15]
                               target:target
                               action:action];
}
+ (instancetype)roundButtonWithTitle:(nullable NSString *)title font:(nullable UIFont *)font target:(id)target action:(SEL)action {
    return [self defaultButtonWithTitle:title
                                 target:target
                                 action:action
                            normalColor:[self.class buttonColor:SMRGeneralButtonColorDefaul]
                           disableColor:[UIColor smr_disableGrayColor]
                             titleColor:[self.class buttonTitleColor:SMRGeneralButtonColorDefaul]
                                   font:font
                           cornerRadius:6];
}

#pragma mark - RectButton

- (void)setRectButtonEnumColor:(SMRGeneralButtonColor)color {
    [self setRectButtonColor:[self.class buttonColor:color]
                  titleColor:[self.class buttonTitleColor:color]];
}

- (void)setRectButtonColor:(nullable UIColor *)color titleColor:(nullable UIColor *)titleColor {
    if (color) {
        [self setBackgroundImage:[SMRUtils createImageWithColor:color] forState:UIControlStateNormal];
    }
    if (titleColor) {
        [self setTitleColor:titleColor forState:UIControlStateNormal];
    }
}

+ (instancetype)rectButtonWithTitle:(NSString *)title target:(id)target action:(SEL)action {
    return [self rectButtonWithTitle:title
                                font:[UIFont smr_boldSystemFontOfSize:15]
                              target:target
                              action:action];
}

+ (instancetype)rectButtonWithTitle:(NSString *)title font:(UIFont *)font target:(id)target action:(SEL)action {
    return [self defaultButtonWithTitle:title
                                 target:target
                                 action:action
                            normalColor:[self.class buttonColor:SMRGeneralButtonColorDefaul]
                           disableColor:[UIColor smr_disableGrayColor]
                             titleColor:[self.class buttonTitleColor:SMRGeneralButtonColorDefaul]
                                   font:font
                           cornerRadius:0];
}

#pragma mark - BorderButton

- (void)setBorderButtonEnumColor:(SMRGeneralButtonColor)color {
    [self setBorderButtonColor:[self.class buttonBorderColor:color]
                    titleColor:[self.class buttonBorderTitleColor:color]];
}

- (void)setBorderButtonColor:(nullable UIColor *)color titleColor:(nullable UIColor *)titleColor {
    if (color) {
        self.layer.borderColor = color.CGColor;
    }
    if (titleColor) {
        [self setTitleColor:titleColor forState:UIControlStateNormal];
    }
}

+ (instancetype)borderButtonWithTitle:(NSString *)title target:(id)target action:(SEL)action {
    return [self borderButtonWithTitle:title
                                  font:[UIFont smr_boldSystemFontOfSize:15]
                                target:target
                                action:action];
}

+ (instancetype)borderButtonWithTitle:(NSString *)title font:(UIFont *)font target:(id)target action:(SEL)action {
    return [self borderButtonWithColor:[self.class buttonColor:SMRGeneralButtonColorDefaul]
                                  font:font
                                 title:title
                                target:target
                                action:action];
}

+ (instancetype)borderButtonWithColor:(UIColor *)color font:(nullable UIFont *)font title:(nullable NSString *)title target:(id)target action:(SEL)action {
    SMRGeneralButton *btn = [SMRGeneralButton buttonWithType:UIButtonTypeCustom];
    title ? [btn setTitle:title forState:UIControlStateNormal] : NULL;
    color ? [btn setTitleColor:color forState:UIControlStateNormal] : NULL;
    btn.titleLabel.font = font;
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    btn.layer.cornerRadius = 6;
    color ? (btn.layer.borderColor = color.CGColor) : NULL;
    btn.layer.borderWidth = 0.5;
    return btn;
}

@end
