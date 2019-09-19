//
//  SMRUtils.h
//  SMRBaseCoreDemo
//
//  Created by 丁治文 on 2019/2/14.
//  Copyright © 2019 sumrise. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SMRUtils : NSObject

+ (NSMutableAttributedString *)yy_attributedStringWithTags:(NSArray<NSString *> *)tags
                                                  textFont:(UIFont *)textFont
                                                 textColor:(UIColor *)textColor
                                          hilitedTextColor:(UIColor *)hilitedTextColor
                                                  tagSpace:(NSString *)tagSpace
                                                 lineSpace:(CGFloat)lineSpace
                                               borderWidth:(CGFloat)borderWidth
                                               borderColor:(UIColor *)borderColor
                                              cornerRadius:(CGFloat)cornerRadius
                                              borderInsets:(UIEdgeInsets)borderInsets
                                           backgroundColor:(UIColor *)backgroundColor
                                                 tapAction:(void (^)(NSString *text, NSInteger index))tapAction;

+ (void)sd_downloadAndCacheImageWithURL:(nullable NSURL *)url
                                 toDisk:(BOOL)toDisk
                             completion:(nullable void(^)(UIImage *))completion;

@end

NS_ASSUME_NONNULL_END
