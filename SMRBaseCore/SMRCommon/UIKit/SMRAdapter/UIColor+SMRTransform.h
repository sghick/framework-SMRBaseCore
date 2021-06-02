//
//  UIColor+SMRTransform.h
//  SMRBaseCoreDemo
//
//  Created by Tinswin on 2018/12/21.
//  Copyright © 2018年 sumrise. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (SMRTransform)

/** 获取UIColor对象的RGB值,返回格式为: prefix + 'FFFFFF',非RGB颜色返回nil */
- (nullable NSString *)smr_colorHexRGBStringWithPrefix:(nullable NSString *)prefix;
/** 获取UIColor对象的RGB值,返回格式为:0xFFFFFF,非RGB颜色返回0 */
- (int32_t)smr_colorHexRGBValue;
/** 获取UIColor对象的Alpha值 */
- (CGFloat)smr_colorAlpha;
/** 改变UIColor对象的Alpha值后,返回一个新的UIColor对象 */
- (nullable UIColor *)smr_colorWithAlphaComponent:(CGFloat)alpha;

/** 以16进制字符串创建一个RGB颜色,支持格式:'FFFFFF','#FFFFFF','0xFFFFFF' */
+ (nullable UIColor *)smr_colorWithHexRGB:(NSString *)colorString;
/** 以16进制字符串创建一个RGB颜色,带透明度 */
+ (nullable UIColor *)smr_colorWithHexRGB:(NSString *)colorString alpha:(CGFloat)alpha;

/** 以16进制整数创建一个RGB颜色,支持格式:0xFFFFFF */
+ (nullable UIColor *)smr_colorWithHexRGBValue:(int32_t)hex;
/** 以16进制整数创建一个RGB颜色,带透明度 */
+ (nullable UIColor *)smr_colorWithHexRGBValue:(int32_t)hex alpha:(CGFloat)alpha;

/** 以红绿蓝三色的分子创建一个RGB颜色 */
+ (UIColor *)smr_colorWithRed:(NSInteger)red green:(NSInteger)green blue:(NSInteger)blue;
/** 以红绿蓝三色的分子创建一个RGB颜色,带透明度 */
+ (UIColor *)smr_colorWithRed:(NSInteger)red green:(NSInteger)green blue:(NSInteger)blue alpha:(CGFloat)alpha;

#pragma mark - GeneralColors

/** 透明色 */
+ (UIColor *)smr_clearColor;

/** 白色 #FFFFFF */
+ (UIColor *)smr_whiteColor;

/** 红色 #D12920 */
+ (UIColor *)smr_generalRedColor;

/** 橘色 #E7B02D */
+ (UIColor *)smr_deepOrangeColor;
/** 橘色 #F19722 */
+ (UIColor *)smr_generalOrangeColor;

/** 蓝色 #60A7DD */
+ (UIColor *)smr_generalBlueColor;

/** 紫色 #7F79CA */
+ (UIColor *)smr_generalPurpleColor;
/** 紫色 #A399F0 */
+ (UIColor *)smr_darkPurpleColor;
/** 紫色 #B5AEED */
+ (UIColor *)smr_backgroundPurpleColor;

/** 黑色 #000000 */
+ (UIColor *)smr_blackColor;
/** 黑色 #1B1B1B */
+ (UIColor *)smr_alertBlackColor;
/** 黑色 #333333 */
+ (UIColor *)smr_generalBlackColor;

/** 灰色 #666666 */
+ (UIColor *)smr_lightGrayColor;
/** 灰色 #999999 */
+ (UIColor *)smr_darkGrayColor;
/** 灰色 #A7A7A7 */
+ (UIColor *)smr_normalGrayColor;
/** 灰色 #BCBCBC */
+ (UIColor *)smr_placeholderGrayColor;
/** 灰色 #CDCDCD */
+ (UIColor *)smr_disableGrayColor;
/** 灰色 #D9D9D9 */
+ (UIColor *)smr_tableLineGrayColor;
/** 灰色 #EBEBEB */
+ (UIColor *)smr_lineGrayColor;
/** 灰色 #F0F0F0 */
+ (UIColor *)smr_backgroundGrayColor;
/** 灰色 #F2F2F2 */
+ (UIColor *)smr_labelGrayColor;
/** 灰色 #F5F5F5 */
+ (UIColor *)smr_sepGrayColor;
/** 灰色 #F8F9FB */
+ (UIColor *)smr_contentGrayColor;

@end

NS_ASSUME_NONNULL_END
