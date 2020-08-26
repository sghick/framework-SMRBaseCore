//
//  UIFont+SMRAdapter.h
//  SMRBaseCoreDemo
//
//  Created by Tinswin on 2018/12/21.
//  Copyright © 2018年 BaoDashi. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIFont (SMRAdapter)

+ (UIFont *)smr_systemFontOfSize:(CGFloat)fontSize;
+ (UIFont *)smr_boldSystemFontOfSize:(CGFloat)fontSize;
+ (UIFont *)smr_fontWithName:(NSString *)fontName size:(CGFloat)fontSize;

@end

NS_ASSUME_NONNULL_END
