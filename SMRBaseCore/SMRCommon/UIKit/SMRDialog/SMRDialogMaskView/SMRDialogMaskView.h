//
//  SMRDialogMaskView.h
//  Hermes
//
//  Created by Tinswin on 2021/3/26.
//  Copyright © 2021 isumrise. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol SMRDialogMaskViewProtocol <NSObject>

/** 弹窗创建方法 */
- (void)dialogViewCreated;
/** 定义了maskView的contentView部分 */
- (UIView *)contentViewOfMaskView;
/** backgroundImageView与contentView的insets */
- (UIEdgeInsets)contentInsetsOfBackgroundImageView;

@end

@protocol SMRDialogMaskViewAnimation <NSObject>

/** 展示动画 */
- (void)animationOfShow;
/** 隐藏动画 */
- (void)animationOfHide;

@end

typedef void(^SMRDialogMaskViewTouchedBlock)(id maskView);

@interface SMRDialogMaskView : UIView<SMRDialogMaskViewProtocol, SMRDialogMaskViewAnimation>

/// 内容背景,默认白色
@property (strong, nonatomic, readonly) UIImageView *backgroundImageView;
/// 内容视图载体,默认白色
@property (strong, nonatomic, readonly) UIView *maskContentView;
/// 内容视图载体,默认白色,子视图应该在这里增加
@property (strong, nonatomic, readonly) UIView *contentView;
/// 背景的点击事件
@property (copy  , nonatomic) SMRDialogMaskViewTouchedBlock backgroundTouchedBlock;
/// 内容的点击事件
@property (copy  , nonatomic) SMRDialogMaskViewTouchedBlock contentViewTouchedBlock;

/// 动画时间
@property (assign, nonatomic) CGFloat animationDuration; ///< default:0.35
/// 默认YES,如果父类为maskView类型,则做自动适配
@property (assign, nonatomic) BOOL autoAdjustIfShowInMaskView;

/** 创建dialog实例 */
+ (instancetype)dialogView;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;

/** 视图创建完成后的回调 */
- (void)dialogViewCreated;
- (void)setContentViewSize:(CGSize)size animated:(BOOL)animated;

- (void)show;
- (void)showAnimated:(BOOL)animated;
- (void)showInView:(nullable UIView *)inView animated:(BOOL)animated;

- (void)hide;
- (void)hideAnimated:(BOOL)animated;
/** 关闭整个嵌套的maskView */
- (void)hideAllMaskViewWithAnimated:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END
