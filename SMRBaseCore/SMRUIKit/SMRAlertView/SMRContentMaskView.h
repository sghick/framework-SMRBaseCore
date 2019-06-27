//
//  SMRContentMaskView.h
//  SMRBaseCoreDemo
//
//  Created by 丁治文 on 2019/2/13.
//  Copyright © 2019 sumrise. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, SMRContentMaskViewContentAlignment) {
    SMRContentMaskViewContentAlignmentCenter   = 0,    ///< contentView居中
    SMRContentMaskViewContentAlignmentBottom   = 1,    ///< contentView在底部
};

@protocol SMRContentMaskViewProtocol <NSObject>

/** 定义了maskView的contentView部分 */
- (UIView *)contentViewOfMaskView;
/** 定义了contentView的左右缩进后的宽,默认左右缩进了各43 */
- (CGFloat)widthOfContentView;
/** 定义了contentView的位置,默认居中 */
- (SMRContentMaskViewContentAlignment)contentAlignmentOfMaskView;
/** 背景与内容视图的insets,随内容定 */
- (UIEdgeInsets)contentInsetsOfBackgroundImageView;

@end

typedef void(^SMRContentMaskViewTouchedBlock)(id maskView);

@interface SMRContentMaskView : UIView<SMRContentMaskViewProtocol>

@property (assign, nonatomic, readonly) BOOL didLoadLayout;     ///< 是否已设置过一次约束
@property (assign, nonatomic, readonly) SMRContentMaskViewContentAlignment contentAlignment;    ///< 视频的布局对齐方式
@property (strong, nonatomic, readonly) UIImageView *backgroundImageView; ///< 内容背景,默认白色
@property (strong, nonatomic, readonly) UIView *contentView;    ///< 内容视频载体,默认白色
@property (assign, nonatomic) BOOL autoAdjustIfShowInMaskView;  ///< 默认YES,如果父类为maskView类型,则做自动适配

@property (copy  , nonatomic) SMRContentMaskViewTouchedBlock backgroundTouchedBlock;    ///< 背景的点击事件
@property (copy  , nonatomic) SMRContentMaskViewTouchedBlock contentViewTouchedBlock;   ///< 内容的点击事件

/** 初始化方法,默认SMRContentMaskViewContentAlignmentCenter */
- (instancetype)init;
- (instancetype)initWithContentAlignment:(SMRContentMaskViewContentAlignment)contentAlignment;
/** 推荐子类重写此方法 */
- (instancetype)initWithFrame:(CGRect)frame contentAlignment:(SMRContentMaskViewContentAlignment)contentAlignment;

/** 更新contentView的高 */
- (void)updateHeightOfContentView:(CGFloat)heightOfContentView;
- (void)updateHeightOfContentView:(CGFloat)heightOfContentView aniamted:(BOOL)animated;

- (void)show;
- (void)showAnimated:(BOOL)animated;
- (void)showInView:(nullable UIView *)inView animated:(BOOL)animated;

- (void)hide;
- (void)hideAnimated:(BOOL)animated;
/** 关闭整个嵌套的maskView */
- (void)hideAllMaskViewWithAnimated:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END
