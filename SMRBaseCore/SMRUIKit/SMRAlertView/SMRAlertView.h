//
//  SMRAlertView.h
//  SMRBaseCoreDemo
//
//  Created by 丁治文 on 2019/2/14.
//  Copyright © 2019 sumrise. All rights reserved.
//

#import "SMRCustomAlertView.h"

NS_ASSUME_NONNULL_BEGIN

@class SMRAlertView;
typedef void(^SMRAlertPhoneLinkTouchedBlock)(SMRAlertView *alert, NSString *phone);
typedef void(^SMRAlertLinkTouchedBlock)(SMRAlertView *alert, NSURL *url);

@interface SMRAlertView : SMRCustomAlertView

// cmp-title
@property (copy  , nonatomic) NSString *title;
// cmp-content
@property (copy  , nonatomic) NSString *content;
@property (copy  , nonatomic) NSAttributedString *attributeContent;
// cmp-image
@property (copy  , nonatomic) NSString *imageURL;
@property (strong, nonatomic) UIImage *image;
@property (assign, nonatomic) CGSize imageSize;
@property (assign, nonatomic) CGFloat imageSpace;
// cmp-textField
@property (assign, nonatomic) BOOL useTextField;
@property (strong, nonatomic) UITextField *textField;

/** 仅支持通过initialConfig设置 */
@property (strong, nonatomic) UIColor *titleColor;
@property (assign, nonatomic) NSTextAlignment contentTextAlignment; ///< 文字内容的对齐方式,默认居中对齐

@property (copy  , nonatomic, nullable) SMRAlertPhoneLinkTouchedBlock phoneLinkTouchedBlock;
@property (copy  , nonatomic, nullable) SMRAlertLinkTouchedBlock linkTouchedBlock;

/// 在指定位置添加超级链接
- (void)addLinkToURL:(NSURL *)url withRange:(NSRange)range;
/// 在内容下方展示一张图片
- (void)addImage:(UIImage *)image size:(CGSize)size space:(CGFloat)space;
- (void)addImageURL:(NSString *)imageURL size:(CGSize)size space:(CGFloat)space;

/// 默认弹窗
+ (instancetype)alertView;

/// NString content
+ (instancetype)alertViewWithContent:(NSString *)content
                        buttonTitles:(NSArray<NSString *> *)buttonTitles
                       deepColorType:(SMRAlertViewButtonDeepColorType)deepColorType;
+ (instancetype)alertViewWithTitle:(NSString *)title
                           content:(NSString *)content
                      buttonTitles:(NSArray<NSString *> *)buttonTitles
                     deepColorType:(SMRAlertViewButtonDeepColorType)deepColorType;

/// NString attributeContent
+ (instancetype)alertViewWithAttributeContent:(NSAttributedString *)attributeContent
                                 buttonTitles:(NSArray<NSString *> *)buttonTitles
                                deepColorType:(SMRAlertViewButtonDeepColorType)deepColorType;
+ (instancetype)alertViewWithTitle:(NSString *)title
                  attributeContent:(NSAttributedString *)attributeContent
                      buttonTitles:(NSArray<NSString *> *)buttonTitles
                     deepColorType:(SMRAlertViewButtonDeepColorType)deepColorType;

/// NSTextField
+ (instancetype)alertViewWithTextFieldAndButtonTitles:(NSArray<NSString *> *)buttonTitles
                                        deepColorType:(SMRAlertViewButtonDeepColorType)deepColorType
                                          configStyle:(nullable UITextField * (^)(UITextField *textField))configStyle;

@end

NS_ASSUME_NONNULL_END
