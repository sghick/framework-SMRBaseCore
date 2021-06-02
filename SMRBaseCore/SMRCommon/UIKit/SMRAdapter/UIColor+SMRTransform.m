//
//  UIColor+SMRTransform.m
//  SMRBaseCoreDemo
//
//  Created by Tinswin on 2018/12/21.
//  Copyright © 2018年 sumrise. All rights reserved.
//

#import "UIColor+SMRTransform.h"

@implementation UIColor (SMRTransform)

- (NSString *)smr_colorHexRGBStringWithPrefix:(NSString *)prefix {
    int32_t R, G, B;
    size_t numComponents = CGColorGetNumberOfComponents(self.CGColor);
    if (numComponents == 4) {
        const CGFloat *components = CGColorGetComponents(self.CGColor);
        R = (int32_t)(255*components[0]);
        G = (int32_t)(255*components[1]);
        B = (int32_t)(255*components[2]);
        NSString *rgbStr = [NSString stringWithFormat:@"%@%02X%02X%02X", (prefix ? : @""), R, G, B];
        return rgbStr;
    } else {
        return nil;
    }
}
- (int32_t)smr_colorHexRGBValue {
    int32_t R, G, B;
    size_t numComponents = CGColorGetNumberOfComponents(self.CGColor);
    if (numComponents == 4) {
        const CGFloat *components = CGColorGetComponents(self.CGColor);
        R = (int32_t)(255*components[0]);
        G = (int32_t)(255*components[1]);
        B = (int32_t)(255*components[2]);
        int32_t rgbValue = (R << 16)|(G << 8)|(B << 0);
        return rgbValue;
    } else {
        return 0;
    }
}
- (CGFloat)smr_colorAlpha {
    return CGColorGetAlpha(self.CGColor);
}
- (UIColor *)smr_colorWithAlphaComponent:(CGFloat)alpha {
    return [self colorWithAlphaComponent:alpha];
}

+ (UIColor *)smr_colorWithHexRGB:(NSString *)colorString {
    return [self smr_colorWithHexRGB:colorString alpha:1.0];
}

+ (UIColor *)smr_colorWithHexRGB:(NSString *)colorString alpha:(CGFloat)alpha {
    // 去除空格
    NSString *cString = [[colorString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    //把开头截取
    if ([cString.lowercaseString hasPrefix:@"0x"]) cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"]) cString = [cString substringFromIndex:1];
    if (cString.length != 6) return nil;
    UIColor *result = nil;
    unsigned int colorCode = 0;
    unsigned char R, G, B;
    if (nil != cString) {
        NSScanner *scanner = [NSScanner scannerWithString:cString];
        (void) [scanner scanHexInt:&colorCode]; // ignore error
    }
    R = (unsigned char) (colorCode >> 16);
    G = (unsigned char) (colorCode >> 8);
    B = (unsigned char) (colorCode >> 0); // masks off high bits
    result = [UIColor colorWithRed: (float)R/0xFF green: (float)G/0xFF blue: (float)B/0xFF alpha:alpha];
    return result;
}

+ (UIColor *)smr_colorWithHexRGBValue:(int32_t)hex {
    return [self smr_colorWithHexRGBValue:hex alpha:1.0];
}
+ (UIColor *)smr_colorWithHexRGBValue:(int32_t)hex alpha:(CGFloat)alpha {
    if (hex > 0xFFFFFF) {
        return nil;
    }
    CGFloat red = ((hex >> 16)&0xFF)/255.0;
    CGFloat green = ((hex >> 8)&0xFF)/255.0;
    CGFloat blue = ((hex >> 0)&0xFF)/255.0;
    UIColor *color = [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
    return color;
}

+ (UIColor *)smr_colorWithRed:(NSInteger)red green:(NSInteger)green blue:(NSInteger)blue {
    return [UIColor smr_colorWithRed:red green:green blue:blue alpha:1];
}

+ (UIColor *)smr_colorWithRed:(NSInteger)red green:(NSInteger)green blue:(NSInteger)blue alpha:(CGFloat)alpha {
    return [UIColor colorWithRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:alpha];
}

#pragma mark - GeneralColors

+ (UIColor *)smr_clearColor {
    return [UIColor clearColor];
}

+ (UIColor *)smr_whiteColor {
    return [UIColor whiteColor];
}

+ (UIColor *)smr_generalRedColor {
    return [UIColor smr_colorWithHexRGB:@"#D12920"];
}

+ (UIColor *)smr_deepOrangeColor {
    return [UIColor smr_colorWithHexRGB:@"#E7B02D"];
}

+ (UIColor *)smr_generalOrangeColor {
    return [UIColor smr_colorWithHexRGB:@"#F19722"];
}

+ (UIColor *)smr_generalBlueColor {
    return [UIColor smr_colorWithHexRGB:@"#60A7DD"];
}

+ (UIColor *)smr_generalPurpleColor {
    return [UIColor smr_colorWithHexRGB:@"#7F79CA"];
}
+ (UIColor *)smr_darkPurpleColor {
    return [UIColor smr_colorWithHexRGB:@"#A399F0"];
}
+ (UIColor *)smr_backgroundPurpleColor {
    return [UIColor smr_colorWithHexRGB:@"#B5AEED"];
}

+ (UIColor *)smr_blackColor {
    return [UIColor smr_colorWithHexRGB:@"#000000"];
}
+ (UIColor *)smr_alertBlackColor {
    return [UIColor smr_colorWithHexRGB:@"#1B1B1B"];
}
+ (UIColor *)smr_generalBlackColor {
    return [UIColor smr_colorWithHexRGB:@"#333333"];
}

+ (UIColor *)smr_lightGrayColor {
    return [UIColor smr_colorWithHexRGB:@"#666666"];
}
+ (UIColor *)smr_darkGrayColor {
    return [UIColor smr_colorWithHexRGB:@"#999999"];
}
+ (UIColor *)smr_normalGrayColor {
    return [UIColor smr_colorWithHexRGB:@"#A7A7A7"];
}
+ (UIColor *)smr_placeholderGrayColor {
    return [UIColor smr_colorWithHexRGB:@"#BCBCBC"];
}
+ (UIColor *)smr_disableGrayColor {
    return [UIColor smr_colorWithHexRGB:@"#CDCDCD"];
}
+ (UIColor *)smr_tableLineGrayColor {
    return [UIColor smr_colorWithHexRGB:@"#D9D9D9"];
}
+ (UIColor *)smr_lineGrayColor {
    return [UIColor smr_colorWithHexRGB:@"#EBEBEB"];
}
+ (UIColor *)smr_backgroundGrayColor {
    return [UIColor smr_colorWithHexRGB:@"#F0F0F0"];
}
+ (UIColor *)smr_labelGrayColor {
    return [UIColor smr_colorWithHexRGB:@"#F2F2F2"];
}
+ (UIColor *)smr_sepGrayColor {
    return [UIColor smr_colorWithHexRGB:@"#F5F5F5"];
}
+ (UIColor *)smr_contentGrayColor {
    return [UIColor smr_colorWithHexRGB:@"#F8F9FB"];
}

@end
