//
//  UIView+SMRGesture.m
//  SMRBaseCoreDemo
//
//  Created by 丁治文 on 2019/3/20.
//  Copyright © 2019 sumrise.com. All rights reserved.
//

#import "UIView+SMRGesture.h"
#import <objc/runtime.h>

@implementation SMRGestureItem

- (void)itemForAddPinGestureWithMinScale:(CGFloat)minScale maxScale:(CGFloat)maxScale scaleChangedBlock:(nullable SMRGestureScaleChangedBlock)scaleChangedBlock {
    self.minScale = MIN(minScale, maxScale);
    self.maxScale = MAX(minScale, maxScale);
    self.scaleChangedBlock = scaleChangedBlock;
}

- (void)itemForAddPanGestureWithinFrame:(CGRect)frame viewSize:(CGSize)viewSize bounce:(CGFloat)bounce allowDirection:(CGVector)direction {
    self.originalViewSize = viewSize;
    self.originalPanFrame = frame;
    self.panFrame = [self.class smr_coverFrameWithViewSize:viewSize innerRect:frame];
    self.panBounce = bounce;
    self.allowDirection = direction;
}

+ (CGRect)smr_coverFrameWithViewSize:(CGSize)viewSize innerRect:(CGRect)innerRect {
    // 如果innerRect比viewSize大,则直接返回innerRect
    if ((innerRect.size.width >= viewSize.width) && (innerRect.size.height >= viewSize.height)) {
        return innerRect;
    }
    CGRect bounds = CGRectMake(innerRect.origin.x + CGRectGetWidth(innerRect) - viewSize.width,
                               innerRect.origin.y + CGRectGetHeight(innerRect) - viewSize.height,
                               2*viewSize.width - CGRectGetWidth(innerRect),
                               2*viewSize.height - CGRectGetHeight(innerRect));
    return bounds;
}


@end

@implementation UIView (SMRGesture)

#pragma mark - Getters/Setters
// sections
static const char SMRGestureItemPropertyKey = '\0';
- (void)setGestureItem:(SMRGestureItem *)gestureItem {
    if (gestureItem != self.gestureItem) {
        objc_setAssociatedObject(self, &SMRGestureItemPropertyKey, gestureItem, OBJC_ASSOCIATION_RETAIN);
    }
}

- (SMRGestureItem *)gestureItem {
    SMRGestureItem *gestureItem = objc_getAssociatedObject(self, &SMRGestureItemPropertyKey);
    return gestureItem;
}

- (SMRGestureItem *)safeGestureItem {
    SMRGestureItem *item = self.gestureItem;
    if (!item) {
        item = [[SMRGestureItem alloc] init];
        self.gestureItem = item;
    }
    return item;
}

- (void)addTapGestureWithTarget:(id)target action:(SEL)action {
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:target action:action];
    [self addGestureRecognizer:tap];
}

- (void)addTapGesture {
    [self addTapGestureWithTarget:self action:@selector(tapGesture:)];
}

- (void)addPinchGestureWithinMinScale:(CGFloat)minScale maxScale:(CGFloat)maxScale {
    [self addPinchGestureWithinMinScale:minScale maxScale:maxScale scaleChangedBlock:nil];
}

- (void)addPinchGestureWithinMinScale:(CGFloat)minScale
                             maxScale:(CGFloat)maxScale
                    scaleChangedBlock:(nullable SMRGestureScaleChangedBlock)scaleChangedBlock{
    [self.safeGestureItem itemForAddPinGestureWithMinScale:minScale
                                                  maxScale:maxScale
                                         scaleChangedBlock:scaleChangedBlock];
    self.userInteractionEnabled = YES;
    UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchGesture:)];
    [self addGestureRecognizer:pinch];
}

- (void)addPanGestureWithinFrame:(CGRect)frame bounce:(CGFloat)bounce allowDirection:(CGVector)direction {
    [self addPanGestureWithinFrame:frame viewSize:self.frame.size bounce:bounce allowDirection:direction];
}

- (void)addPanGestureWithinFrame:(CGRect)frame viewSize:(CGSize)viewSize bounce:(CGFloat)bounce allowDirection:(CGVector)direction {
    [self.safeGestureItem itemForAddPanGestureWithinFrame:frame
                                                 viewSize:viewSize
                                                   bounce:bounce
                                           allowDirection:direction];
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
        if (CGPointEqualToPoint(self.safeGestureItem.center, CGPointZero)) {
            self.safeGestureItem.center = view.center;
        }
        self.safeGestureItem.lastScale = 1.0;
        return;
    }
    if (pinch.state == UIGestureRecognizerStateEnded) {
        [UIView animateWithDuration:0.35 delay:0 usingSpringWithDamping:0.9 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            view.center = self.safeGestureItem.center;
            if (view.transform.a > self.safeGestureItem.maxScale) {
                view.transform = CGAffineTransformMakeScale(self.safeGestureItem.maxScale, self.safeGestureItem.maxScale);
            }
            if (view.transform.a < self.safeGestureItem.minScale) {
                view.transform = CGAffineTransformMakeScale(self.safeGestureItem.minScale, self.safeGestureItem.minScale);
            }
            
            CGAffineTransform scaleTransform = CGAffineTransformMakeScale(view.transform.a, view.transform.a);
            // lite类型需要转化一下
            self.safeGestureItem.panFrame = [SMRGestureItem smr_coverFrameWithViewSize:view.frame.size
                                                                             innerRect:self.safeGestureItem.originalPanFrame];
            if (self.safeGestureItem.scaleChangedBlock) {
                self.safeGestureItem.scaleChangedBlock(scaleTransform, view);
            }
        } completion:nil];
        return;
    }
    
    CGFloat scale = 1.0 - (self.safeGestureItem.lastScale - pinch.scale);
    view.transform = CGAffineTransformScale(view.transform, scale, scale);
    self.safeGestureItem.lastScale = pinch.scale;
}

- (void)panGesture:(UIPanGestureRecognizer *)pan {
    UIView *view = pan.view;
    
    CGPoint center = [pan translationInView:view];
    static CGFloat firstX;
    static CGFloat firstY;
    if (pan.state == UIGestureRecognizerStateBegan) {
        if (CGPointEqualToPoint(self.safeGestureItem.center, CGPointZero)) {
            self.safeGestureItem.center = view.center;
        }
        firstX = [view center].x;
        firstY = [view center].y;
    }
    
    center = CGPointMake(firstX + center.x*self.safeGestureItem.allowDirection.dx, firstY + center.y*self.safeGestureItem.allowDirection.dy);
    
    if (pan.state == UIGestureRecognizerStateCancelled) {
        return;
    }
    
    // 手势结束后
    if (pan.state == UIGestureRecognizerStateEnded) {
        // 计算视图可停留的临界中心点
        CGPoint endCenter = [self getCenterPoint:center
                                        outFrame:self.safeGestureItem.panFrame
                                       outBounce:0
                                        viewSize:view.frame.size];
        // 以动画的形式弹回
        [UIView animateWithDuration:0.35 animations:^{
            view.center = endCenter;
        }];
        return;
    }
    
    // 手势如果超出panBounce,则不能再继续往外移动
    CGPoint rCenter = [self getCenterPoint:center
                                  outFrame:self.safeGestureItem.panFrame
                                 outBounce:self.safeGestureItem.panBounce
                                  viewSize:view.frame.size];
    view.center = rCenter;
}

- (CGPoint)getCenterPoint:(CGPoint)centerPoint outFrame:(CGRect)outFrame outBounce:(CGFloat)outBounce viewSize:(CGSize)viewSize {
    CGPoint point = centerPoint;
    CGRect outRect = CGRectMake(outFrame.origin.x + viewSize.width/2.0 - outBounce,
                                outFrame.origin.y + viewSize.height/2.0 - outBounce,
                                CGRectGetWidth(outFrame) - viewSize.width + 2*outBounce,
                                CGRectGetHeight(outFrame) - viewSize.height + 2*outBounce);
    // 如果超出outFrame+outBounce,则返回最近的点
    if (!CGRectContainsPoint(outRect, point)) {
        if (point.y > outRect.origin.y + outRect.size.height) {
            point.y = outRect.origin.y + outRect.size.height;
        }
        if (point.x > outRect.origin.x + outRect.size.width) {
            point.x = outRect.origin.x + outRect.size.width;
        }
        if (point.y < outRect.origin.y) {
            point.y = outRect.origin.y;
        }
        if (point.x < outRect.origin.x) {
            point.x = outRect.origin.x;
        }
    }
    return point;
}

- (void)rotationGesture:(UIRotationGestureRecognizer *)rotation {
    UIView *view = rotation.view;
    
    if (rotation.state == UIGestureRecognizerStateBegan) {
        if (CGPointEqualToPoint(self.safeGestureItem.center, CGPointZero)) {
            self.safeGestureItem.center = view.center;
        }
        self.safeGestureItem.lastRotation = 0.0;
        return;
    }
    if (rotation.state == UIGestureRecognizerStateEnded) {
        [UIView animateWithDuration:0.35 delay:0 usingSpringWithDamping:0.9 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            view.center = self.safeGestureItem.center;
        } completion:nil];
        return;
    }
    
    CGFloat rotate = (rotation.rotation - self.safeGestureItem.lastRotation);
    view.transform = CGAffineTransformRotate(view.transform, rotate);
    self.safeGestureItem.lastRotation = rotation.rotation;
}

#pragma mark - Utils

- (void)returnToOriginalShapeAnimated:(BOOL)animated {
    if (animated) {
        [UIView animateWithDuration:0.35 delay:0 usingSpringWithDamping:0.9 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.transform = CGAffineTransformMakeScale(1, 1);
            self.center = self.safeGestureItem.center;
            self.safeGestureItem.panFrame = [SMRGestureItem smr_coverFrameWithViewSize:self.safeGestureItem.originalViewSize
                                                                             innerRect:self.safeGestureItem.originalPanFrame];
            if (self.safeGestureItem.scaleChangedBlock) {
                self.safeGestureItem.scaleChangedBlock(self.transform, self);
            }
        } completion:nil];
    } else {
        self.transform = CGAffineTransformMakeScale(1, 1);
        self.center = self.safeGestureItem.center;
        self.safeGestureItem.panFrame = [SMRGestureItem smr_coverFrameWithViewSize:self.safeGestureItem.originalViewSize
                                                                         innerRect:self.safeGestureItem.originalPanFrame];
        if (self.safeGestureItem.scaleChangedBlock) {
            self.safeGestureItem.scaleChangedBlock(self.transform, self);
        }
    }
}

@end
