//
//  UIFont+SMR.h
//  SMRBaseCoreDemo
//
//  Created by 丁治文 on 2019/1/21.
//  Copyright © 2019 sumrise. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIFont (SMR)

+ (UIFont *)smr_systemFontOfSize:(CGFloat)fontSize;
+ (UIFont *)smr_boldSystemFontOfSize:(CGFloat)fontSize;
+ (UIFont *)smr_fontWithName:(NSString *)fontName size:(CGFloat)fontSize;

@end

NS_ASSUME_NONNULL_END
