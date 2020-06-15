//
//  UIButton+SMR.h
//  SMRBaseCoreDemo
//
//  Created by 丁治文 on 2019/1/31.
//  Copyright © 2019 sumrise. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, SMRContentAlignment) {
    SMRContentAlignmentCenter   = 0,    ///< 居中对齐
    SMRContentAlignmentLeft     = 1,    ///< 居左对齐
    SMRContentAlignmentRight    = 2,    ///< 居右对齐
};

/**
 设置 alignment 属性时,只有当Button的宽高给出之后才能正确展示
 */
@interface UIButton (SMR)

/** 设置按钮的点击范围 */
- (void)smr_enlargeTapEdge:(UIEdgeInsets)edge;

/** 让Button的图片显示在文字的右边，每修改一次title或者image必须再次调用此方法 */
- (void)smr_makeImageToRight;
/** 让Button的图片显示在文字的右边，同时设置间距，每修改一次title或者image必须再次调用此方法 */
- (void)smr_makeImageToRightWithSpace:(CGFloat)space alignment:(SMRContentAlignment)alignment;
/** 让Button的图片显示在文字的左边，同时设置间距 */
- (void)smr_makeImageAndTitleWithSpace:(CGFloat)space alignment:(SMRContentAlignment)alignment;

/** 将图片进行旋转，如果需要动画效果，可以直接置于UIView动画效果中 */
- (void)smr_makeImageRotation:(CGFloat)rotate;

@end

NS_ASSUME_NONNULL_END
