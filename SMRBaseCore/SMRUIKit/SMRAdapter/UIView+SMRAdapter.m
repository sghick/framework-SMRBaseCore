//
//  UIView+SMRAdapter.m
//  SMRBaseCoreDemo
//
//  Created by 丁治文 on 2019/2/18.
//  Copyright © 2019 sumrise. All rights reserved.
//

#import "UIView+SMRAdapter.h"

static NSInteger const kTagForBDSAdapterBottomView = 342983;

@implementation UIView (SMRAdapter)

/** 给view的底部添加一个定高定色的view */
- (UIView *)addSafeAreaViewWithColor:(UIColor *)color height:(CGFloat)height;
/** 给view的底部添加一个定高定色的view,可取得view的约束 */
- (UIView *)addSafeAreaViewWithColor:(UIColor *)color height:(CGFloat)height layouts:(NSArray<NSLayoutConstraint *> * _Nullable *)layouts;

/** 给view的底部view更换颜色 */
- (void)updateSafeAreaViewColor:(UIColor *)color;

@end
