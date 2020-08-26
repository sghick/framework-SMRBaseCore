//
//  SMRCustomAlertView.h
//  SMRBaseCoreDemo
//
//  Created by Tinswin on 2020/8/6.
//  Copyright © 2020 sumrise. All rights reserved.
//

#import "SMRTableAlertView.h"

NS_ASSUME_NONNULL_BEGIN

/** 定义深色按钮,仅能定制right/center位置 */
typedef NS_ENUM(NSInteger, SMRAlertViewButtonDeepColorType) {
    SMRAlertViewButtonDeepColorTypeNone     = 0,
    SMRAlertViewButtonDeepColorTypeCancel   = 1,
    SMRAlertViewButtonDeepColorTypeSure     = 2,
    SMRAlertViewButtonDeepColorTypeDelete   = 3,
};

typedef NS_ENUM(NSInteger, SMRAlertViewStyle) {
    SMRAlertViewStyleBlack      = 0,    ///< 白色经典样式(黑色主题)
    SMRAlertViewStyleOrange     = 1,    ///< 橙色经典样式(橙色主题)
    SMRAlertViewStyleRed        = 2,    ///< 红色经典样式(红色主题)
};

@protocol SMRCustomBottomButtonProtocol <NSObject>

/** 确定按钮的响应action,子类自定义按钮样式时可以用做按钮的action */
- (void)sureBtnAction:(UIButton *)sender;
/** 取消按钮的响应action,子类自定义按钮样式时可以用做按钮的action */
- (void)cancelBtnAction:(UIButton *)sender;

@end

@interface SMRCustomAlertView : SMRTableAlertView<SMRCustomBottomButtonProtocol>

/** 仅支持通过initialConfig设置 */
@property (assign, nonatomic) SMRAlertViewStyle alertViewStyle;

@property (copy  , nonatomic) NSArray<NSString *> *buttonTitles;
@property (assign, nonatomic) SMRAlertViewButtonDeepColorType deepColorType;

/// 默认NO,值为YES时,将取消按钮和确定按钮对掉,一个按钮时变为取消按钮
@property (assign, nonatomic) BOOL reversCancleAndSureButtonPostion;

@property (copy  , nonatomic) SMRContentMaskViewTouchedBlock cancelButtonTouchedBlock;  ///< 取消按钮的点击事件,left
@property (copy  , nonatomic) SMRContentMaskViewTouchedBlock sureButtonTouchedBlock;    ///< 确定按钮的点击事件,right/center

@end

NS_ASSUME_NONNULL_END
