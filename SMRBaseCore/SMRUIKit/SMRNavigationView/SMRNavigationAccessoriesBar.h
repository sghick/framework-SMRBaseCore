//
//  SMRNavigationAccessoriesBar.h
//  SMRGeneralUseDemo
//
//  Created by 丁治文 on 2019/1/11.
//  Copyright © 2019 sumrise. All rights reserved.
//

#import "SMRNavigationBar.h"

NS_ASSUME_NONNULL_BEGIN

@interface UIView (SMRNavigationAccessories)

/** 设置以下属性值,则会忽视SMRNavigationAccessoriesBar.space的值 */
@property (assign, nonatomic) CGFloat nav_accessories_space;

@end

@interface SMRNavigationAccessoriesBar : SMRNavigationBar

@property (assign, nonatomic) CGFloat leftMargin; ///< default:20
@property (assign, nonatomic) CGFloat rightMargin; ///< default:20

@property (assign, nonatomic) CGFloat space; ///< default:10

@property (assign, nonatomic) CGSize leftViewSize;
@property (assign, nonatomic) CGSize rightViewSize;
@property (assign, nonatomic) CGSize centerViewSize;

@property (nonatomic, copy  , nullable) NSArray<UIView *> *leftViews;
@property (nonatomic, copy  , nullable) NSArray<UIView *> *rightViews;

@property (nonatomic, strong, nullable) UIView *leftView;
@property (nonatomic, strong, nullable) UIView *rightView;
@property (nonatomic, strong, nullable) UIView *centerView;

/** 设置centerView,同时指定margin */
- (void)setCenterView:(UIView * _Nullable)centerView;
- (void)setCenterView:(UIView * _Nullable)centerView margin:(CGFloat)margin;
- (CGFloat)autoCenterViewMargin;

/** 替换view,未找到则不做替换 */
- (void)replaceLeftView:(UIView *)view withView:(nullable UIView *)withView;
- (void)replaceRightView:(UIView *)view withView:(nullable UIView *)withView;

/** 设置显示隐藏后需要触发此方法刷新 */
- (void)setNeedsLayoutLeftViews;
- (void)setNeedsLayoutRightViews;
- (void)setNeedsLayoutCenterViews;

/** 单纯只能移除某个view,不会刷新UI */
- (void)removeViewFromLeftViews:(UIView *)view;
/** 单纯只能移除某个view,不会刷新UI */
- (void)removeViewFromRightViews:(UIView *)view;

@end

NS_ASSUME_NONNULL_END
