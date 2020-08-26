//
//  SMRUtils+NSAttributedString.m
//  SMRBaseCoreDemo
//
//  Created by 丁治文 on 2019/2/14.
//  Copyright © 2019 sumrise. All rights reserved.
//

#import "SMRUtils+NSAttributedString.h"

@implementation SMRUtils (NSAttributedString)

+ (NSMutableAttributedString *)attributedStringFromString:(NSString *)string
                                              stringColor:(UIColor *)stringColor
                                               stringFont:(UIFont *)stringFont
                                              lineSpacing:(CGFloat)lineSpacing
                                           underlineStyle:(NSUnderlineStyle)underlineStyle
                                       strikethroughStyle:(NSUnderlineStyle)strikethroughStyle
                                           baseLineOffset:(CGFloat)baseLineOffset {
    if (string == nil) {
        NSMutableAttributedString *rtnAttr = [[NSMutableAttributedString alloc] init];
        return rtnAttr;
    }
    NSRange range = NSMakeRange(0, string.length);
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:string];
    if (stringColor) {
        [attr addAttribute:NSForegroundColorAttributeName value:stringColor range:range];
    }
    if (stringFont) {
        [attr addAttribute:NSFontAttributeName value:stringFont range:range];
    }
    if (lineSpacing != 0) {
        NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:lineSpacing];
        [attr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:range];
    }
    if (underlineStyle != NSUnderlineStyleNone) {
        [attr addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInt:underlineStyle] range:range];
    }
    if (strikethroughStyle != NSUnderlineStyleNone) {
        [attr addAttribute:NSStrikethroughStyleAttributeName value:[NSNumber numberWithInt:strikethroughStyle] range:range];
    }
    if (baseLineOffset != 0) {
        [attr addAttribute:NSBaselineOffsetAttributeName value:[NSNumber numberWithFloat:baseLineOffset] range:range];
    }
    return attr;
}

+ (NSMutableAttributedString *)attributedStringFromString:(NSString *)string
                                              stringColor:(UIColor *)stringColor
                                               stringFont:(UIFont *)stringFont
                                              lineSpacing:(CGFloat)lineSpacing
                                               markString:(NSString *)markString
                                                markColor:(UIColor *)markColor
                                                 markFont:(UIFont *)markFont
                                       markUnderlineStyle:(NSUnderlineStyle)markUnderlineStyle
                                   markStrikethroughStyle:(NSUnderlineStyle)markStrikethroughStyle
                                       markBaseLineOffset:(CGFloat)markBaseLineOffset {
    NSAttributedString *baseAttr = [self attributedStringFromString:string
                                                        stringColor:stringColor
                                                         stringFont:stringFont
                                                        lineSpacing:lineSpacing
                                                     underlineStyle:NSUnderlineStyleNone
                                                 strikethroughStyle:NSUnderlineStyleNone
                                                     baseLineOffset:0];
    return [self attributedStringFromAttributedString:baseAttr
                                           markString:markString
                                            markColor:markColor
                                             markFont:markFont
                                       underlineStyle:markUnderlineStyle
                                   strikethroughStyle:markStrikethroughStyle
                                       baseLineOffset:markBaseLineOffset];
}

+ (NSMutableAttributedString *)attributedStringFromString:(NSString *)string
                                               markString:(NSString *)markString
                                                markColor:(UIColor *)markColor
                                                 markFont:(UIFont *)markFont
                                           underlineStyle:(NSUnderlineStyle)underlineStyle
                                       strikethroughStyle:(NSUnderlineStyle)strikethroughStyle
                                           baseLineOffset:(CGFloat)baseLineOffset {
    return [self attributedStringFromAttributedString:[[NSAttributedString alloc] initWithString:string ? string : @""]
                                           markString:markString
                                            markColor:markColor
                                             markFont:markFont
                                       underlineStyle:underlineStyle
                                   strikethroughStyle:strikethroughStyle
                                       baseLineOffset:baseLineOffset];
}


+ (NSMutableAttributedString *)attributedStringFromAttributedString:(NSAttributedString *)attributedString
                                                         markString:(NSString *)markString
                                                          markColor:(UIColor *)markColor
                                                           markFont:(UIFont *)markFont
                                                     underlineStyle:(NSUnderlineStyle)underlineStyle
                                                 strikethroughStyle:(NSUnderlineStyle)strikethroughStyle
                                                     baseLineOffset:(CGFloat)baseLineOffset {
    if (attributedString == nil) {
        NSMutableAttributedString *rtnAttr = [[NSMutableAttributedString alloc] init];
        return rtnAttr;
    }
    NSMutableAttributedString *rtnAttr = [[NSMutableAttributedString alloc] initWithAttributedString:attributedString];
    if (markString == nil) {
        return rtnAttr;
    }
    NSRange range = [attributedString.string rangeOfString:markString];
    if (range.location != NSNotFound) {
        if (markColor) {
            [rtnAttr addAttribute:NSForegroundColorAttributeName value:markColor range:range];
        }
        if (markFont) {
            [rtnAttr addAttribute:NSFontAttributeName value:markFont range:range];
        }
        if (underlineStyle != NSUnderlineStyleNone) {
            [rtnAttr addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInt:underlineStyle] range:range];
        }
        if (strikethroughStyle != NSUnderlineStyleNone) {
            [rtnAttr addAttribute:NSStrikethroughStyleAttributeName value:[NSNumber numberWithInt:strikethroughStyle] range:range];
        }
        if (baseLineOffset != 0) {
            [rtnAttr addAttribute:NSBaselineOffsetAttributeName value:[NSNumber numberWithFloat:baseLineOffset] range:range];
        }
    }
    return rtnAttr;
}

@end
