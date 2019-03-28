//
//  UIView+SMRAdapter.h
//  SMRBaseCoreDemo
//
//  Created by 丁治文 on 2019/2/18.
//  Copyright © 2019 sumrise. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

static NSInteger const kTagForSMRAdapterBottomView = 541608;

@interface UIView (SMRAdapter)

/** 给view的底部添加一个定高定色的view */
- (UIView *)setSafeAreaViewWithColor:(UIColor *)color;

/** 给view的底部添加一个定高定色的view,指定从哪个view开始 */
- (UIView *)setSafeAreaViewWithColor:(UIColor *)color fromBottomOfView:(UIView *)fromBottomOfView;
/** 给view的底部添加一个定高定色的view,指定从哪个view开始,可取得view的约束 */
- (UIView *)setSafeAreaViewWithColor:(UIColor *)color fromBottomOfView:(UIView *)fromBottomOfView layouts:(NSArray<NSLayoutConstraint *> **)layouts;

/** 给view的底部添加一个定高定色的view,指定高 */
- (UIView *)setSafeAreaViewWithColor:(UIColor *)color height:(CGFloat)height;
/** 给view的底部添加一个定高定色的view,可取得view的约束 */
- (UIView *)setSafeAreaViewWithColor:(UIColor *)color height:(CGFloat)height layouts:(NSArray<NSLayoutConstraint *> **)layouts;

/** 给view的底部view更换颜色 */
- (void)updateSafeAreaViewColor:(UIColor *)color;

@end

NS_ASSUME_NONNULL_END
