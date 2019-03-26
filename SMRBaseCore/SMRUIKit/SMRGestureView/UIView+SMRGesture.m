//
//  UIView+SMRGesture.m
//  SMRBaseCoreDemo
//
//  Created by 丁治文 on 2019/3/20.
//  Copyright © 2019 sumrise.com. All rights reserved.
//

#import "UIView+SMRGesture.h"
#warning TODO:这个类有时间需要进行一步完善

@implementation UIView (SMRGesture)

static CGPoint _center;
static CGFloat _minScale;
static CGFloat _maxScale;
static CGFloat _lastScale;
static CGVector _allowDirection;
static CGFloat _lastRotation;
static CGRect _panBounds;
static CGFloat _panBounce;

- (void)addTapGestureWithTarget:(id)target action:(SEL)action {
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:target action:action];
    [self addGestureRecognizer:tap];
}

- (void)addTapGesture {
    [self addTapGestureWithTarget:self action:@selector(tapGesture:)];
}

- (void)addPinchGestureWithinMinScale:(CGFloat)minScale maxScale:(CGFloat)maxScale {
    _minScale = MIN(minScale, maxScale);
    _maxScale = MAX(minScale, maxScale);
    self.userInteractionEnabled = YES;
    UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchGesture:)];
    [self addGestureRecognizer:pinch];
}

- (void)addPanGestureWithinBounds:(CGRect)bounds bounce:(CGFloat)bounce allowDirection:(CGVector)direction {
    _panBounds = bounds;
    _panBounce = bounce;
    _allowDirection = direction;
    self.userInteractionEnabled = YES;
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGesture:)];
    [self addGestureRecognizer:pan];
}

- (void)addRotationGesture {
    self.userInteractionEnabled = YES;
    UIRotationGestureRecognizer *rotation = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotationGesture:)];
    [self addGestureRecognizer:rotation];
}

- (void)tapGesture:(UITapGestureRecognizer *)tap {
    [self returnToOriginalShapeAnimated:YES];
}

#pragma mark - Actions

- (void)pinchGesture:(UIPinchGestureRecognizer *)pinch {
    UIView *view = pinch.view;
    if (pinch.state == UIGestureRecognizerStateBegan) {
        if (CGPointEqualToPoint(_center, CGPointZero)) {
            _center = view.center;
        }
        _lastScale = 1.0;
        return;
    }
    if (pinch.state == UIGestureRecognizerStateEnded) {
        [UIView animateWithDuration:0.35 delay:0 usingSpringWithDamping:0.9 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            view.center = _center;
            if (view.transform.a > _maxScale) {
                view.transform = CGAffineTransformMakeScale(_maxScale, _maxScale);
            }
            if (view.transform.a < _minScale) {
                view.transform = CGAffineTransformMakeScale(_minScale, _minScale);
            }
        } completion:nil];
        return;
    }
    
    CGFloat scale = 1.0 - (_lastScale - pinch.scale);
    view.transform = CGAffineTransformScale(view.transform, scale, scale);
    _lastScale = pinch.scale;
}

#warning TODO:移动功能还没有调试好,之后再调
- (void)panGesture:(UIPanGestureRecognizer *)pan {
    UIView *view = pan.view;
    
    CGPoint center = [pan translationInView:view];
    static CGFloat firstX;
    static CGFloat firstY;
    if (pan.state == UIGestureRecognizerStateBegan) {
        if (CGPointEqualToPoint(_center, CGPointZero)) {
            _center = view.center;
        }
        firstX = [view center].x;
        firstY = [view center].y;
    }
    
    center = CGPointMake(firstX + center.x*_allowDirection.dx, firstY + center.y*_allowDirection.dy);
    
    if (pan.state == UIGestureRecognizerStateCancelled) {
        NSLog(@"center:%@", NSStringFromCGPoint(center));
        return;
    }
    if (((center.x + _panBounce) > _panBounds.size.width*view.transform.a) ||
        ((center.y + CGRectGetHeight(view.frame) + _panBounce) > _panBounds.size.height*view.transform.a)) {
        pan.state = UIGestureRecognizerStateCancelled;
        return;
    }
    view.center = center;
}

- (void)rotationGesture:(UIRotationGestureRecognizer *)rotation {
    UIView *view = rotation.view;
    
    if (rotation.state == UIGestureRecognizerStateBegan) {
        if (CGPointEqualToPoint(_center, CGPointZero)) {
            _center = view.center;
        }
        _lastRotation = 0.0;
        return;
    }
    if (rotation.state == UIGestureRecognizerStateEnded) {
        [UIView animateWithDuration:0.35 delay:0 usingSpringWithDamping:0.9 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            view.center = _center;
        } completion:nil];
        return;
    }
    
    CGFloat rotate = (rotation.rotation - _lastRotation);
    view.transform = CGAffineTransformRotate(view.transform, rotate);
    _lastRotation = rotation.rotation;
}

#pragma mark - Utils

- (void)returnToOriginalShapeAnimated:(BOOL)animated {
    if (animated) {
        [UIView animateWithDuration:0.35 delay:0 usingSpringWithDamping:0.9 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.transform = CGAffineTransformMakeScale(1, 1);
            self.center = _center;
        } completion:nil];
    } else {
        self.transform = CGAffineTransformMakeScale(1, 1);
        self.center = _center;
    }
}

@end
