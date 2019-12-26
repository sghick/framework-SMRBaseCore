//
//  SMRGeneralButton.h
//  Gucci
//
//  Created by 丁治文 on 2019/1/23.
//  Copyright © 2019 ibaodashi. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, SMRGeneralButtonColor) {
    SMRGeneralButtonColorOrange,
    SMRGeneralButtonColorBlack,
    SMRGeneralButtonColorWhite,
    SMRGeneralButtonColorRed,
    
    SMRGeneralButtonColorDefaul = SMRGeneralButtonColorOrange, // 默认
};

@interface SMRGeneralButton : UIButton

/** 按钮背景颜色(填充样式:直角,圆角) */
+ (UIColor *)buttonColor:(SMRGeneralButtonColor)color;
/** 按钮文字颜色(填充样式:直角,圆角) */
+ (UIColor *)buttonTitleColor:(SMRGeneralButtonColor)color;
/** 按钮边框颜色(边框样式:圆角) */
+ (UIColor *)buttonBorderColor:(SMRGeneralButtonColor)color;
/** 按钮文字颜色(边框样式:圆角) */
+ (UIColor *)buttonBorderTitleColor:(SMRGeneralButtonColor)color;

#pragma mark - DefaultButton 默认:圆角
/** 默认按钮:黑色 */
+ (instancetype)defaultButtonWithTitle:(NSString *)title
                                target:(id)target
                                action:(SEL)action;

/** 红色 */
+ (instancetype)redButtonWithTitle:(NSString *)title
                            target:(id)target
                            action:(SEL)action __deprecated_msg("已废弃");

/** 白色 */
+ (instancetype)whiteButtonWithTitle:(NSString *)title
                              target:(id)target
                              action:(SEL)action __deprecated_msg("已废弃");

#pragma mark - RoundButton 圆角

/// 设置背景和字体颜色
- (void)setRoundButtonEnumColor:(SMRGeneralButtonColor)color;
- (void)setRoundButtonColor:(nullable UIColor *)color titleColor:(nullable UIColor *)titleColor;
+ (instancetype)roundButtonWithTitle:(nullable NSString *)title
                              target:(id)target
                              action:(SEL)action;
+ (instancetype)roundButtonWithTitle:(nullable NSString *)title
                                font:(nullable UIFont *)font
                              target:(id)target
                              action:(SEL)action;

#pragma mark - RectButton 直角

/// 设置背景和字体颜色
- (void)setRectButtonEnumColor:(SMRGeneralButtonColor)color;
- (void)setRectButtonColor:(nullable UIColor *)color titleColor:(nullable UIColor *)titleColor;
+ (instancetype)rectButtonWithTitle:(nullable NSString *)title
                             target:(id)target
                             action:(SEL)action;
+ (instancetype)rectButtonWithTitle:(nullable NSString *)title
                               font:(nullable UIFont *)font
                             target:(id)target
                             action:(SEL)action;

#pragma mark - BorderButton 边框

/// 设置边框和字体颜色
- (void)setBorderButtonEnumColor:(SMRGeneralButtonColor)color;
- (void)setBorderButtonColor:(nullable UIColor *)color titleColor:(nullable UIColor *)titleColor;
+ (instancetype)borderButtonWithTitle:(nullable NSString *)title
                               target:(id)target
                               action:(SEL)action;
+ (instancetype)borderButtonWithTitle:(nullable NSString *)title
                                 font:(nullable UIFont *)font
                               target:(id)target
                               action:(SEL)action;

@end

NS_ASSUME_NONNULL_END

