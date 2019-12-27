//
//  SMRAlertViewButton.h
//  SMRBaseCoreDemo
//
//  Created by 丁治文 on 2019/2/14.
//  Copyright © 2019 sumrise. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, SMRAlertViewStyle);
typedef NS_ENUM(NSInteger, SMRAlertViewButtonFunction) {
    SMRAlertViewButtonFunctionSure,
    SMRAlertViewButtonFunctionCancel,
    SMRAlertViewButtonFunctionDelete,
};

@class SMRAlertViewButton;
typedef void(^SMRAlertViewButtonBlock)(SMRAlertViewButton *button);

@interface SMRAlertViewButton : UIView

- (instancetype)initWithButtons:(NSArray<UIView *> *)buttons height:(CGFloat)height space:(CGFloat)space;

+ (UIButton *)buttonTitle:(NSString *)title
                   target:(id)target
                   action:(SEL)action
                 function:(SMRAlertViewButtonFunction)function;
+ (UIButton *)buttonTitle:(NSString *)title
                   target:(id)target
                   action:(SEL)action
                    style:(SMRAlertViewStyle)style
                 function:(SMRAlertViewButtonFunction)function;

@end

NS_ASSUME_NONNULL_END
