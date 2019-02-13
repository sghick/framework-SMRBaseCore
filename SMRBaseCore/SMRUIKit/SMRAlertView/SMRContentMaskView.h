//
//  SMRContentMaskView.h
//  SMRBaseCoreDemo
//
//  Created by 丁治文 on 2019/2/13.
//  Copyright © 2019 sumrise. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol SMRContentMaskViewProtocol <NSObject>

/** 定义了maskView的contentView部分 */
- (UIView *)contentViewOfMaskView;
/** 定义了contentView的左右缩进 */
- (CGFloat)marginOfContentView;

@end

@class SMRContentMaskView;
typedef void(^SMRContentMaskViewTouchedBlock)(SMRContentMaskView *maskView);

@interface SMRContentMaskView : UIView<SMRContentMaskViewProtocol>

@property (assign, nonatomic, readonly) BOOL didLoadLayout;     ///< 是否已设置过一次约束
@property (strong, nonatomic, readonly) UIView *contentView;    ///< 内容视频载体,默认白色

@property (copy  , nonatomic) SMRContentMaskViewTouchedBlock backgroundTouchedBlock;    ///< 背景的点击事件
@property (copy  , nonatomic) SMRContentMaskViewTouchedBlock contentViewTouchedBlock;   ///< 内容的点击事件

- (void)show;
- (void)showAnimated:(BOOL)animated;
- (void)showInView:(UIView *)view animated:(BOOL)animated;

- (void)hide;
- (void)hideAnimated:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END
