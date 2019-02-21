//
//  UIColor+SMR.m
//  SMRBaseCoreDemo
//
//  Created by 丁治文 on 2019/1/21.
//  Copyright © 2019 sumrise. All rights reserved.
//

#import "UIColor+SMR.h"

@implementation UIColor (SMR)

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
        int32_t rgbValue = (R << 16)|(R << 8)|(B << 0);
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

@end
