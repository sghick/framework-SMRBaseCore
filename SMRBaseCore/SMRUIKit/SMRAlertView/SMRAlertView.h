//
//  SMRAlertView.h
//  SMRBaseCoreDemo
//
//  Created by 丁治文 on 2019/2/13.
//  Copyright © 2019 sumrise. All rights reserved.
//

#import "SMRTableAlertView.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, SMRAlertViewStyle) {
    SMRAlertViewStyleWhite      = 0,    ///< 白色经典样式
    SMRAlertViewStyleOrange     = 1,    ///< 橙色经典样式
    
    SMRAlertViewStyleConfig     = 64,   ///< 使用config配置
};

/** 定义深色按钮,仅能定制right/center位置 */
typedef NS_OPTIONS(NSInteger, SMRAlertViewButtonDeepColorType) {
    SMRAlertViewButtonDeepColorTypeNone     = 0,
    SMRAlertViewButtonDeepColorTypeCancel   = 1 << 0,
    SMRAlertViewButtonDeepColorTypeSure     = 1 << 1,
    SMRAlertViewButtonDeepColorTypeDelete   = 1 << 2,
};

@protocol SMRAlertViewBottomButtonProtocol <NSObject>

/** 确定按钮的响应action,子类自定义按钮样式时可以用做按钮的action */
- (void)sureBtnAction:(UIButton *)sender;
/** 取消按钮的响应action,子类自定义按钮样式时可以用做按钮的action */
- (void)cancelBtnAction:(UIButton *)sender;

@end

@interface SMRAlertView : SMRTableAlertView<SMRAlertViewBottomButtonProtocol>

@property (copy  , nonatomic, readonly) NSString *imageURL;
@property (copy  , nonatomic, readonly) NSString *title;
@property (copy  , nonatomic, readonly) NSString *content;
@property (copy  , nonatomic, readonly) NSAttributedString *attributeContent;
@property (copy  , nonatomic, readonly) NSArray<NSString *> *buttonTitles;
@property (assign, nonatomic, readonly) SMRAlertViewButtonDeepColorType deepColorType;

/// 默认NO,值为YES时,将取消按钮和确定按钮对掉,一个按钮时变为取消按钮
@property (assign, nonatomic) BOOL reversCancleAndSureButtonPostion;

@property (assign, nonatomic) NSTextAlignment contentTextAlignment; ///< 文字内容的对齐方式,默认居中对齐

@property (copy  , nonatomic) SMRContentMaskViewTouchedBlock cancelButtonTouchedBlock;  ///< 取消按钮的点击事件,left
@property (copy  , nonatomic) SMRContentMaskViewTouchedBlock sureButtonTouchedBlock;    ///< 确定按钮的点击事件,right/center

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

@end

NS_ASSUME_NONNULL_END
