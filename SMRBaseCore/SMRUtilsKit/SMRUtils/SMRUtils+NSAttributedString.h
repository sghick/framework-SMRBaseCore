//
//  SMRUtils+NSAttributedString.h
//  SMRBaseCoreDemo
//
//  Created by 丁治文 on 2019/2/14.
//  Copyright © 2019 sumrise. All rights reserved.
//

#import "SMRUtils.h"

NS_ASSUME_NONNULL_BEGIN

@interface SMRUtils (NSAttributedString)

/** 创建一套属性字符串 */
+ (NSMutableAttributedString *)attributedStringFromString:(NSString *)string
                                              stringColor:(UIColor *)stringColor
                                               stringFont:(UIFont *)stringFont
                                              lineSpacing:(CGFloat)lineSpacing
                                           underlineStyle:(NSUnderlineStyle)underlineStyle
                                       strikethroughStyle:(NSUnderlineStyle)strikethroughStyle
                                           baseLineOffset:(CGFloat)baseLineOffset;

/** 创建一套属性字符串,并进行标记 */
+ (NSMutableAttributedString *)attributedStringFromString:(NSString *)string
                                              stringColor:(UIColor *)stringColor
                                               stringFont:(UIFont *)stringFont
                                              lineSpacing:(CGFloat)lineSpacing
                                               markString:(NSString *)markString
                                                markColor:(UIColor *)markColor
                                                 markFont:(UIFont *)markFont
                                       markUnderlineStyle:(NSUnderlineStyle)markUnderlineStyle
                                   markStrikethroughStyle:(NSUnderlineStyle)markStrikethroughStyle
                                       markBaseLineOffset:(CGFloat)markBaseLineOffset;

/** 标记属性字符串 */
+ (NSMutableAttributedString *)attributedStringFromString:(NSString *)string
                                               markString:(NSString *)markString
                                                markColor:(UIColor *)markColor
                                                 markFont:(UIFont *)markFont
                                           underlineStyle:(NSUnderlineStyle)underlineStyle
                                       strikethroughStyle:(NSUnderlineStyle)strikethroughStyle
                                           baseLineOffset:(CGFloat)baseLineOffset;

/** 标记属性字符串 */
+ (NSMutableAttributedString *)attributedStringFromAttributedString:(NSAttributedString *)attributedString
                                                         markString:(NSString *)markString
                                                          markColor:(UIColor *)markColor
                                                           markFont:(UIFont *)markFont
                                                     underlineStyle:(NSUnderlineStyle)underlineStyle
                                                 strikethroughStyle:(NSUnderlineStyle)strikethroughStyle
                                                     baseLineOffset:(CGFloat)baseLineOffset;

@end

NS_ASSUME_NONNULL_END
