//
//  SMRAlertViewButton.h
//  SMRBaseCoreDemo
//
//  Created by 丁治文 on 2019/2/14.
//  Copyright © 2019 sumrise. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class SMRAlertViewButton;
typedef void(^SMRAlertViewButtonBlock)(SMRAlertViewButton *button);

@interface SMRAlertViewButton : UIView

- (instancetype)initWithButtons:(NSArray<UIView *> *)buttons height:(CGFloat)height space:(CGFloat)space;

+ (UIButton *)whiteButtonWithTitle:(NSString *)title target:(id)target action:(SEL)action deepColor:(BOOL)deepColor;
+ (UIButton *)orangeButtonWithTitle:(NSString *)title target:(id)target action:(SEL)action deepColor:(BOOL)deepColor;

@end

NS_ASSUME_NONNULL_END
