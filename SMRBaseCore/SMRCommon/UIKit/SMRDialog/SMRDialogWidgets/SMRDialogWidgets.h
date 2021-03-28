//
//  SMRDialogWidgets.h
//  Hermes
//
//  Created by Tinswin on 2021/3/27.
//  Copyright © 2021 ibaodashi. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SMRDialogWidget : UIView

@property (assign, nonatomic, readonly) UIEdgeInsets insets;
@property (strong, nonatomic, readonly) UIView *child;

+ (instancetype)child:(nullable UIView *)child insets:(UIEdgeInsets)insets;

- (instancetype)initWithChild:(nullable UIView *)child insets:(UIEdgeInsets)insets;

@end

NS_ASSUME_NONNULL_END
