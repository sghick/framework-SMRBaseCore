//
//  SMRUtils+YYText.h
//  SMRBaseCoreDemo
//
//  Created by 丁治文 on 2019/2/26.
//  Copyright © 2019 sumrise. All rights reserved.
//

#import "SMRUtils.h"
#import <YYText/YYText.h>

NS_ASSUME_NONNULL_BEGIN

@interface SMRUtils (YYText)

+ (NSMutableAttributedString *)yy_attributedStringWithTags:(NSArray<NSString *> *)tags
                                                  textFont:(UIFont *)textFont
                                                 textColor:(UIColor *)textColor
                                          hilitedTextColor:(UIColor *)hilitedTextColor
                                                  tagSpace:(nullable NSString *)tagSpace
                                                 lineSpace:(CGFloat)lineSpace
                                               borderWidth:(CGFloat)borderWidth
                                               borderColor:(nullable UIColor *)borderColor
                                              cornerRadius:(CGFloat)cornerRadius
                                              borderInsets:(UIEdgeInsets)borderInsets
                                           backgroundColor:(nullable UIColor *)backgroundColor
                                                 tapAction:(void (^)(NSString *text, NSInteger index))tapAction;

@end

NS_ASSUME_NONNULL_END
