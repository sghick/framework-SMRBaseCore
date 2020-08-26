//
//  SMRBadgeView.m
//  SMRBaseCoreDemo
//
//  Created by Tinswin on 2020/7/26.
//  Copyright © 2020 sumrise. All rights reserved.
//

#import "SMRBadgeView.h"
#import <QuartzCore/QuartzCore.h>

@interface SMRBadgeView ()

@property (assign, nonatomic) BOOL didLoadLayout;

@property (strong, nonatomic) UILabel *label;

@end

@implementation SMRBadgeView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = NO;
        _alignment = SMRBadgeAlignmentTopRight;
        _anchor = SMRBadgeAnchorCenter;
        _badgeSideInsets = UIEdgeInsetsMake(3, 3, 3, 3);
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews {
    [self addSubview:self.label];
    
    [self setNeedsLayout];
}

- (void)layoutSubviews {
    [self _updateBadgeFrame];
}

- (void)_updateBadgeFrame {
    UIEdgeInsets insets = self.badgeSideInsets;
    CGPoint offset = self.badgeOffset;
    CGSize size = [self.label systemLayoutSizeFittingSize:CGSizeMake(320,2000)];
    CGSize realSize = CGSizeMake(size.width + insets.left + insets.right, size.height + insets.top + insets.bottom);
    CGFloat fitWidth = MAX(MAX(realSize.width, realSize.height), self.minWidth);
    self.label.frame = CGRectMake(0, 0, fitWidth, realSize.height);
    self.label.layer.cornerRadius = realSize.height/2.0;
    CGPoint point = [self _pointWithAlignment:self.alignment superSize:self.frame.size];
    CGPoint center = [self _centerAtPoint:point size:self.label.frame.size anchor:self.anchor];
    self.label.center = CGPointMake(center.x + offset.x, center.y + offset.y);
    
    [self removeAnimation];
    [self beginAnimation];
}

- (CGPoint)_centerAtPoint:(CGPoint)point size:(CGSize)size anchor:(SMRBadgeAnchor)anchor {
    CGPoint center = CGPointZero;
    switch (anchor) {
        case SMRBadgeAnchorCenter: {
            center = point;
        }
            break;
        case SMRBadgeAnchorCenterRight: {
            center = CGPointMake(point.x - size.width/2.0, point.y);
        }
            break;
        case SMRBadgeAnchorCenterLeft: {
            center = CGPointMake(point.x + size.width/2.0, point.y);
        }
            break;
        case SMRBadgeAnchorTopCenter: {
            center = CGPointMake(point.x, point.y + size.height/2.0);
        }
            break;
        case SMRBadgeAnchorTopRight: {
            center = CGPointMake(point.x - size.width/2.0, point.y + size.height/2.0);
        }
            break;
        case SMRBadgeAnchorTopLeft: {
            center = CGPointMake(point.x + size.width/2.0, point.y + size.height/2.0);
        }
            break;
        case SMRBadgeAnchorBottomCenter: {
            center = CGPointMake(point.x, point.y - size.height/2.0);
        }
            break;
        case SMRBadgeAnchorBottomRight: {
            center = CGPointMake(point.x - size.width/2.0, point.y - size.height/2.0);
        }
            break;
        case SMRBadgeAnchorBottomLeft: {
            center = CGPointMake(point.x + size.width/2.0, point.y - size.height/2.0);
        }
            break;
            
        default:
            break;
    }
    return center;
}

- (CGPoint)_pointWithAlignment:(SMRBadgeAlignment)alignment superSize:(CGSize)superSize {
    CGPoint point = CGPointZero;
    switch (alignment) {
        case SMRBadgeAlignmentTopRight: {
            point = CGPointMake(superSize.width, 0);
        }
            break;
        case SMRBadgeAlignmentTopLeft: {
            point = CGPointMake(0, 0);
        }
            break;
        case SMRBadgeAlignmentTopCenter: {
            point = CGPointMake(superSize.width/2.0, 0);
        }
            break;
        case SMRBadgeAlignmentBottomRight: {
            point = CGPointMake(superSize.width, superSize.height);
        }
            break;
        case SMRBadgeAlignmentBottomLeft: {
            point = CGPointMake(0, superSize.height);
        }
            break;
        case SMRBadgeAlignmentBottomCenter: {
            point = CGPointMake(superSize.width/2.0, superSize.height);
        }
            break;
        case SMRBadgeAlignmentCenterRight: {
            point = CGPointMake(superSize.width, superSize.height/2.0);
        }
            break;
        case SMRBadgeAlignmentCenterLeft: {
            point = CGPointMake(0, superSize.height/2.0);
        }
            break;
        case SMRBadgeAlignmentCenter: {
            point = CGPointMake(superSize.width/2.0, superSize.height/2.0);
        }
            break;
            
        default:
            break;
    }
    return point;
}

#pragma mark - Animations


//#define kBadgeBreatheAniKey     @"breathe"
//#define kBadgeRotateAniKey      @"rotate"
//#define kBadgeShakeAniKey       @"shake"
//#define kBadgeScaleAniKey       @"scale"
//#define kBadgeBounceAniKey      @"bounce"

- (void)beginAnimation {
    if (self.animation) {
        [self.label.layer addAnimation:self.animation forKey:@"badgeAnimaation"];
    }
}

- (void)removeAnimation {
    if (_label) {
        [self.label.layer removeAllAnimations];
    }
}

#pragma mark - Setters

- (void)setMinWidth:(CGFloat)minWidth {
    _minWidth = minWidth;
    [self setNeedsLayout];
}

- (void)setBadgeSideInsets:(UIEdgeInsets)badgeSideInsets {
    _badgeSideInsets = badgeSideInsets;
    [self setNeedsLayout];
}

- (void)setBadgeTextFont:(UIFont *)badgeTextFont {
    _badgeTextFont = badgeTextFont;
    self.label.font = badgeTextFont;
    [self setNeedsLayout];
}

- (void)setBadgeTextColor:(UIColor *)badgeTextColor {
    _badgeTextColor = badgeTextColor;
    self.label.textColor = badgeTextColor;
}

- (void)setBadgeBackgroundColor:(UIColor *)badgeBackgroundColor {
    _badgeBackgroundColor = badgeBackgroundColor;
    self.label.backgroundColor = badgeBackgroundColor;
}

- (void)setBadgeText:(NSString *)badgeText {
    _badgeText = badgeText;
    self.label.text = badgeText;
    [self setNeedsLayout];
}

- (void)setBadgeOffset:(CGPoint)badgeOffset {
    _badgeOffset = badgeOffset;
    [self setNeedsLayout];
}

- (void)setAlignment:(SMRBadgeAlignment)alignment {
    _alignment = alignment;
    [self setNeedsLayout];
}

- (void)setAnchor:(SMRBadgeAnchor)anchor {
    _anchor = anchor;
    [self setNeedsLayout];
}

- (void)setAnimation:(CAAnimation *)animation {
    _animation = animation;
    [self setNeedsLayout];
}

#pragma mark - Getters

- (UILabel *)label {
    if (!_label) {
        _label = [[UILabel alloc] init];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.clipsToBounds = YES;
    }
    return _label;
}

@end

@implementation SMRBadgeView (Animations)

#pragma mark - Animations

/**
 *  breathing forever
 *
 *  @param time duritaion, from clear to fully seen
 *
 *  @return animation obj
 */
+ (CABasicAnimation *)opacityForever_Animation:(float)time
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animation.fromValue = [NSNumber numberWithFloat:1.0];
    animation.toValue = [NSNumber numberWithFloat:0.1];
    animation.autoreverses = YES;
    animation.duration = time;
    animation.repeatCount = FLT_MAX;
    animation.removedOnCompletion = NO;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    animation.fillMode = kCAFillModeForwards;
    return animation;
}

/**
 *  breathing with fixed repeated times
 *
 *  @param repeatTimes times
 *  @param time        duritaion, from clear to fully seen
 *
 *  @return animation obj
 */
+ (CABasicAnimation *)opacityTimes_Animation:(float)repeatTimes durTimes:(float)time
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animation.fromValue = [NSNumber numberWithFloat:1.0];
    animation.toValue = [NSNumber numberWithFloat:0.4];
    animation.repeatCount = repeatTimes;
    animation.duration = time;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    animation.autoreverses = YES;
    return animation;
}

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
+ (CABasicAnimation *)rotation:(float)dur degree:(float)degree direction:(SMRAxis)axis repeatCount:(int)repeatCount
{
    CABasicAnimation* animation;
    NSArray *axisArr = @[@"transform.rotation.x", @"transform.rotation.y", @"transform.rotation.z"];
    animation = [CABasicAnimation animationWithKeyPath:axisArr[axis]];
    animation.fromValue = [NSNumber numberWithFloat:0];
    animation.toValue = [NSNumber numberWithFloat:degree];
    animation.duration = dur;
    animation.autoreverses = NO;
    animation.cumulative = YES;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.repeatCount = repeatCount;
    return animation;
}

/**
 *  scale animation
 *
 *  @param fromScale   the original scale value, 1.0 by default
 *  @param toScale     target scale
 *  @param time        duration
 *  @param repeatTimes repeat counts
 *
 *  @return animaiton obj
 */
+ (CABasicAnimation *)scaleFrom:(CGFloat)fromScale toScale:(CGFloat)toScale durTimes:(float)time rep:(float)repeatTimes
{
    CABasicAnimation *animation=[CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation.fromValue = @(fromScale);
    animation.toValue = @(toScale);
    animation.duration = time;
    animation.autoreverses = YES;
    animation.repeatCount = repeatTimes;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    return animation;
}

/**
 *  shake
 *
 *  @param repeatTimes time
 *  @param time        duration
 *  @param obj         always be CALayer
 *  @return aniamtion obj
 */
+ (CAKeyframeAnimation *)shake_AnimationRepeatTimes:(float)repeatTimes durTimes:(float)time forObj:(id)obj
{
    NSAssert([obj isKindOfClass:[CALayer class]] , @"invalid target");
    CGPoint originPos = CGPointZero;
    CGSize originSize = CGSizeZero;
    if ([obj isKindOfClass:[CALayer class]]) {
        originPos = [(CALayer *)obj position];
        originSize = [(CALayer *)obj bounds].size;
    }
    CGFloat hOffset = originSize.width / 4;
    CAKeyframeAnimation *anim = [CAKeyframeAnimation animation];
    anim.keyPath = @"position";
    anim.values = @[[NSValue valueWithCGPoint:CGPointMake(originPos.x, originPos.y)],
                    [NSValue valueWithCGPoint:CGPointMake(originPos.x-hOffset, originPos.y)],
                    [NSValue valueWithCGPoint:CGPointMake(originPos.x, originPos.y)],
                    [NSValue valueWithCGPoint:CGPointMake(originPos.x+hOffset, originPos.y)],
                    [NSValue valueWithCGPoint:CGPointMake(originPos.x, originPos.y)]];
    anim.repeatCount = repeatTimes;
    anim.duration = time;
    anim.fillMode = kCAFillModeForwards;
    return anim;
}

/**
 *  bounce
 *
 *  @param repeatTimes time
 *  @param time        duration
 *  @param obj         always be CALayer
 *  @return aniamtion obj
 */
+ (CAKeyframeAnimation *)bounce_AnimationRepeatTimes:(float)repeatTimes durTimes:(float)time forObj:(id)obj
{
    NSAssert([obj isKindOfClass:[CALayer class]] , @"invalid target");
    CGPoint originPos = CGPointZero;
    CGSize originSize = CGSizeZero;
    if ([obj isKindOfClass:[CALayer class]]) {
        originPos = [(CALayer *)obj position];
        originSize = [(CALayer *)obj bounds].size;
    }
    CGFloat hOffset = originSize.height / 4;
    CAKeyframeAnimation *anim = [CAKeyframeAnimation animation];
    anim.keyPath = @"position";
    anim.values = @[[NSValue valueWithCGPoint:CGPointMake(originPos.x, originPos.y)],
                    [NSValue valueWithCGPoint:CGPointMake(originPos.x, originPos.y-hOffset)],
                    [NSValue valueWithCGPoint:CGPointMake(originPos.x, originPos.y)],
                    [NSValue valueWithCGPoint:CGPointMake(originPos.x, originPos.y+hOffset)],
                    [NSValue valueWithCGPoint:CGPointMake(originPos.x, originPos.y)]];
    anim.repeatCount = repeatTimes;
    anim.duration = time;
    anim.fillMode = kCAFillModeForwards;
    return anim;
}

@end
