//
//  UIColor+SMR.m
//  SMRBaseCoreDemo
//
//  Created by 丁治文 on 2019/1/21.
//  Copyright © 2019 sumrise. All rights reserved.
//

#import "UIColor+SMR.h"

@implementation UIColor (SMR)

+ (nullable UIColor *)smr_colorFromHexRGB:(NSString *)colorString {
    // 去除空格
    NSString *cString = [[colorString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    //把开头截取
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"]) cString = [cString substringFromIndex:1];
    if (cString.length != 6) return nil;
    UIColor *result = nil;
    unsigned int colorCode = 0;
    unsigned char redByte, greenByte, blueByte;
    if (nil != cString) {
        NSScanner *scanner = [NSScanner scannerWithString:cString];
        (void) [scanner scanHexInt:&colorCode]; // ignore error
    }
    redByte = (unsigned char) (colorCode >> 16);
    greenByte = (unsigned char) (colorCode >> 8);
    blueByte = (unsigned char) (colorCode); // masks off high bits
    result = [UIColor
              colorWithRed: (float)redByte / 0xff
              green: (float)greenByte/ 0xff
              blue: (float)blueByte / 0xff
              alpha:1.0];
    return result;
}

+ (UIColor *)smr_colorWithRed:(NSInteger)red green:(NSInteger)green blue:(NSInteger)blue {
    return [UIColor smr_colorWithRed:red green:green blue:blue alpha:1];
}

+ (UIColor *)smr_colorWithRed:(NSInteger)red green:(NSInteger)green blue:(NSInteger)blue alpha:(CGFloat)alpha {
    return [UIColor colorWithRed:red / 255.0f green:green / 255.0f blue:blue / 255.0f alpha:alpha];
}

@end
