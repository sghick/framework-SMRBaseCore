//
//  SMRUtils+ThirdEx.h
//  SMRBaseCoreDemo
//
//  Created by Tinswin on 2020/6/11.
//  Copyright © 2020 sumrise. All rights reserved.
//

#import "SMRUtils.h"

NS_ASSUME_NONNULL_BEGIN

@interface SMRUtils (ThirdEx)

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

+ (void)sd_downloadAndCacheImageWithURL:(nullable NSURL *)url
                                 toDisk:(BOOL)toDisk
                             completion:(nullable void(^)(UIImage *image))completion;

+ (void)sd_downloadAndCacheImageAndDataWithURL:(nullable NSURL *)url
                                        toDisk:(BOOL)toDisk
                                    completion:(nullable void(^)(UIImage *image, NSData *data))completion;

@end

NS_ASSUME_NONNULL_END
