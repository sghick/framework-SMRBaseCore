//
//  UIColor+SMR.h
//  SMRBaseCoreDemo
//
//  Created by 丁治文 on 2019/1/21.
//  Copyright © 2019 sumrise. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (SMR)

/** 获取UIColor对象的RGB值,返回格式为: prefix + 'FFFFFF',非RGB颜色返回nil */
- (NSString *)smr_colorHexRGBStringWithPrefix:(nullable NSString *)prefix;
/** 获取UIColor对象的RGB值,返回格式为:0xFFFFFF,非RGB颜色返回0 */
- (int32_t)smr_colorHexRGBValue;
/** 获取UIColor对象的Alpha值 */
- (CGFloat)smr_colorAlpha;
/** 改变UIColor对象的Alpha值后,返回一个新的UIColor对象 */
- (UIColor *)smr_colorWithAlphaComponent:(CGFloat)alpha;

/** 以16进制字符串创建一个RGB颜色,支持格式:'FFFFFF','#FFFFFF','0xFFFFFF' */
+ (UIColor *)smr_colorWithHexRGB:(NSString *)colorString;
/** 以16进制字符串创建一个RGB颜色,带透明度 */
+ (UIColor *)smr_colorWithHexRGB:(NSString *)colorString alpha:(CGFloat)alpha;

/** 以16进制整数创建一个RGB颜色,支持格式:0xFFFFFF */
+ (UIColor *)smr_colorWithHexRGBValue:(int32_t)hex;
/** 以16进制整数创建一个RGB颜色,带透明度 */
+ (UIColor *)smr_colorWithHexRGBValue:(int32_t)hex alpha:(CGFloat)alpha;

/** 以红绿蓝三色的分子创建一个RGB颜色 */
+ (UIColor *)smr_colorWithRed:(NSInteger)red green:(NSInteger)green blue:(NSInteger)blue;
/** 以红绿蓝三色的分子创建一个RGB颜色,带透明度 */
+ (UIColor *)smr_colorWithRed:(NSInteger)red green:(NSInteger)green blue:(NSInteger)blue alpha:(CGFloat)alpha;

@end

NS_ASSUME_NONNULL_END
