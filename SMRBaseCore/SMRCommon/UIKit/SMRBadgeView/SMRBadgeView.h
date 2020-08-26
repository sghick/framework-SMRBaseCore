//
//  SMRBadgeView.h
//  SMRBaseCoreDemo
//
//  Created by Tinswin on 2020/7/26.
//  Copyright © 2020 sumrise. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, SMRBadgeAlignment) {
    SMRBadgeAlignmentTopRight,
    SMRBadgeAlignmentTopLeft,
    SMRBadgeAlignmentTopCenter,
    SMRBadgeAlignmentBottomRight,
    SMRBadgeAlignmentBottomLeft,
    SMRBadgeAlignmentBottomCenter,
    SMRBadgeAlignmentCenterRight,
    SMRBadgeAlignmentCenterLeft,
    SMRBadgeAlignmentCenter,
};

typedef NS_ENUM(NSUInteger, SMRBadgeAnchor) {
    SMRBadgeAnchorCenter,
    SMRBadgeAnchorCenterRight,
    SMRBadgeAnchorCenterLeft,
    SMRBadgeAnchorTopCenter,
    SMRBadgeAnchorTopRight,
    SMRBadgeAnchorTopLeft,
    SMRBadgeAnchorBottomCenter,
    SMRBadgeAnchorBottomRight,
    SMRBadgeAnchorBottomLeft,
};

@interface SMRBadgeView : UIView

@property (nonatomic, strong) NSArray<NSLayoutConstraint *> *needsRemoveLayouts;
@property (nonatomic, copy  ) NSString *badgeText;

@property (nonatomic, assign) CGFloat minWidth UI_APPEARANCE_SELECTOR;
@property (nonatomic, assign) UIEdgeInsets badgeSideInsets UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIFont *badgeTextFont UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIColor *badgeTextColor UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIColor *badgeBackgroundColor UI_APPEARANCE_SELECTOR;
@property (nonatomic, assign) CGPoint badgeOffset UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) CAAnimation *animation UI_APPEARANCE_SELECTOR;

// 默认:SMRBadgeAlignmentTopRight
@property (nonatomic, assign) SMRBadgeAlignment alignment UI_APPEARANCE_SELECTOR;
// 默认:SMRBadgeAnchorCenter
@property (nonatomic, assign) SMRBadgeAnchor anchor UI_APPEARANCE_SELECTOR;

@end

typedef NS_ENUM(NSUInteger, SMRAxis) {
    SMRAxisX = 0,
    SMRAxisY,
    SMRAxisZ
};

// Degrees to radians
#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)
#define RADIANS_TO_DEGREES(radians) ((radians) * (180.0 / M_PI))

@interface SMRBadgeView (Animations)

#pragma mark - Animations

/**
 *  breathing forever
 *
 *  @param time duritaion, from clear to fully seen, recoments 1.4
 *
 *  @return animation obj
 */
+ (CABasicAnimation *)opacityForever_Animation:(float)time;

/**
 *  breathing with fixed repeated times
 *
 *  @param repeatTimes times, recoments CGFLOAT_MAX
 *  @param time        duritaion, from clear to fully seen, recoments 1
 *
 *  @return animation obj
 */
+ (CABasicAnimation *)opacityTimes_Animation:(float)repeatTimes durTimes:(float)time;

/**
 *  //rotate
 *
 *  @param dur         duration
 *  @param degree      rotate degree in radian(弧度)
 *  @param axis        axis
 *  @param repeatCount repeat count
 *
 *  @return animation obj
 */
+ (CABasicAnimation *)rotation:(float)dur degree:(float)degree direction:(SMRAxis)axis repeatCount:(int)repeatCount;


/**
 *  scale animation
 *
 *  @param fromScale   the original scale value, recoments 1.4
 *  @param toScale     target scale, recoments 0.6
 *  @param time        duration, recoments 1
 *  @param repeatTimes repeat counts, recoments MAXFLOAT
 *
 *  @return animaiton obj
 */
+ (CABasicAnimation *)scaleFrom:(CGFloat)fromScale toScale:(CGFloat)toScale durTimes:(float)time rep:(float)repeatTimes;
/**
 *  shake
 *
 *  @param repeatTimes time, recoments CGFLOAT_MAX
 *  @param time        duration, recoments 1
 *  @param obj         always be CALayer at present
 *  @return aniamtion obj
 */
+ (CAKeyframeAnimation *)shake_AnimationRepeatTimes:(float)repeatTimes durTimes:(float)time forObj:(id)obj;

/**
 *  bounce
 *
 *  @param repeatTimes time, recoments CGFLOAT_MAX
 *  @param time        duration, recoments 1
 *  @param obj         always be CALayer at present
 *  @return aniamtion obj
 */
+ (CAKeyframeAnimation *)bounce_AnimationRepeatTimes:(float)repeatTimes durTimes:(float)time forObj:(id)obj;

@end

NS_ASSUME_NONNULL_END
