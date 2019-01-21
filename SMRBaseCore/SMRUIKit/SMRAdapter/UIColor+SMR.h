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
+ (nullable UIColor *)smr_colorFromHexRGB:(NSString *)colorString;
+ (nullable UIColor *)smr_colorWithRed:(NSInteger)red green:(NSInteger)green blue:(NSInteger)blue;
+ (nullable UIColor *)smr_colorWithRed:(NSInteger)red green:(NSInteger)green blue:(NSInteger)blue alpha:(CGFloat)alpha;

@end

NS_ASSUME_NONNULL_END
