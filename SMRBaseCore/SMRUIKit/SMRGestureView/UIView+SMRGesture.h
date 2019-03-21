//
//  UIView+SMRGesture.h
//  SMRBaseCoreDemo
//
//  Created by 丁治文 on 2019/3/20.
//  Copyright © 2019 sumrise.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (SMRGesture)

/** 添加点击手势 */
- (void)addTapGestureWithTarget:(id)target action:(SEL)action;

/** 添加点击还原功能 */
- (void)addTapGesture;
/** 添加缩放功能 */
- (void)addPinchGestureWithinMinScale:(CGFloat)minScale maxScale:(CGFloat)maxScale;
/** 添加移动功能 */
- (void)addPanGestureWithinBounds:(CGRect)bounds bounce:(CGFloat)bounce allowDirection:(CGVector)direction;
/** 添加旋转功能 */
- (void)addRotationGesture;

#pragma mark - Utils

/** 恢复移动,缩放,旋转过的图片 */
- (void)returnToOriginalShapeAnimated:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END
