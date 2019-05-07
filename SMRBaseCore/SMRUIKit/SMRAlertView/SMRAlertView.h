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

/** 定义深色按钮 */
typedef NS_OPTIONS(NSInteger, SMRAlertViewButtonDeepColorType) {
    SMRAlertViewButtonDeepColorTypeNone     = 0,
    SMRAlertViewButtonDeepColorTypeCancel   = 1 << 0,
    SMRAlertViewButtonDeepColorTypeSure     = 1 << 1,
};

@interface SMRAlertView : SMRTableAlertView

@property (copy  , nonatomic, readonly) NSString *imageURL;
@property (copy  , nonatomic, readonly) NSString *title;
@property (copy  , nonatomic, readonly) NSString *content;
@property (copy  , nonatomic, readonly) NSArray<NSString *> *buttonTitles;
@property (assign, nonatomic, readonly) SMRAlertViewButtonDeepColorType deepColorType;

@property (copy  , nonatomic) SMRContentMaskViewTouchedBlock cancelButtonTouchedBlock;  ///< 取消按钮的点击事件,left
@property (copy  , nonatomic) SMRContentMaskViewTouchedBlock sureButtonTouchedBlock;    ///< 确定按钮的点击事件,right/center

+ (instancetype)alertViewWithContent:(NSString *)content
                        buttonTitles:(NSArray<NSString *> *)buttonTitles
                       deepColorType:(SMRAlertViewButtonDeepColorType)deepColorType;

+ (instancetype)alertViewWithTitle:(NSString *)title
                           content:(NSString *)content
                      buttonTitles:(NSArray<NSString *> *)buttonTitles
                     deepColorType:(SMRAlertViewButtonDeepColorType)deepColorType;

@end

NS_ASSUME_NONNULL_END
