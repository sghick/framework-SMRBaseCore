//
//  UIView+SMRGesture.h
//  SMRBaseCoreDemo
//
//  Created by 丁治文 on 2019/3/20.
//  Copyright © 2019 sumrise.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^SMRGestureScaleChangedBlock)(CGAffineTransform transform, UIView *view);

@interface SMRGestureItem : NSObject

@property (assign, nonatomic) CGPoint center;
@property (assign, nonatomic) CGFloat minScale;
@property (assign, nonatomic) CGFloat maxScale;
@property (assign, nonatomic) CGFloat lastScale;
@property (assign, nonatomic) CGVector allowDirection;
@property (assign, nonatomic) CGFloat lastRotation;
@property (assign, nonatomic) CGRect originalPanFrame;  ///< 原始的panFrame
@property (assign, nonatomic) CGSize originalViewSize;  ///< 原始的viewSize,SMRGesturePanTypeLite时会有此值
@property (assign, nonatomic) CGRect panFrame;          ///< 非原始的panFrame,可以理解为变化后的
@property (assign, nonatomic) CGFloat panBounce;
@property (copy  , nonatomic) SMRGestureScaleChangedBlock scaleChangedBlock;

- (void)itemForAddPinGestureWithMinScale:(CGFloat)minScale
                                maxScale:(CGFloat)maxScale
                       scaleChangedBlock:(nullable SMRGestureScaleChangedBlock)scaleChangedBlock;

- (void)itemForAddPanGestureWithinFrame:(CGRect)frame
                               viewSize:(CGSize)viewSize
                                 bounce:(CGFloat)bounce
                         allowDirection:(CGVector)direction;

/** 对于移动手势,如果需要计算移动位置,可以使用此方法来计算,使用必须将innerRect覆盖 */
+ (CGRect)smr_coverFrameWithViewSize:(CGSize)viewSize innerRect:(CGRect)innerRect;

@end

@interface UIView (SMRGesture)

- (SMRGestureItem *)safeGestureItem;

/** 添加点击手势 */
- (void)addTapGestureWithTarget:(id)target action:(SEL)action;

/** 添加点击还原功能 */
- (void)addTapGesture;

/** 添加缩放功能 */
- (void)addPinchGestureWithinMinScale:(CGFloat)minScale maxScale:(CGFloat)maxScale;
- (void)addPinchGestureWithinMinScale:(CGFloat)minScale maxScale:(CGFloat)maxScale scaleChangedBlock:(nullable SMRGestureScaleChangedBlock)scaleChangedBlock;

/** 添加移动功能 */
- (void)addPanGestureWithinFrame:(CGRect)frame bounce:(CGFloat)bounce allowDirection:(CGVector)direction;
- (void)addPanGestureWithinFrame:(CGRect)frame viewSize:(CGSize)viewSize bounce:(CGFloat)bounce allowDirection:(CGVector)direction;

/** 添加旋转功能 */
- (void)addRotationGesture;

#pragma mark - Utils

/** 恢复移动,缩放,旋转过的图片 */
- (void)returnToOriginalShapeAnimated:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END
