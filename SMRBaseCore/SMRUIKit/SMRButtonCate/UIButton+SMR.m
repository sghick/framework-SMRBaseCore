//
//  UIButton+SMR.m
//  SMRBaseCoreDemo
//
//  Created by 丁治文 on 2019/1/31.
//  Copyright © 2019 sumrise. All rights reserved.
//

#import "UIButton+SMR.h"
#import <objc/runtime.h>

static char topNameKey;
static char rightNameKey;
static char bottomNameKey;
static char leftNameKey;

@implementation UIButton (SMR)

#pragma mark - System Method

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    CGRect rect = [self enlargedRect];
    if (CGRectEqualToRect(rect, self.bounds) && !self.hidden && (self.alpha > 0)) {
        return [super hitTest:point withEvent:event];
    }
    return CGRectContainsPoint(rect, point) ? self : nil;
}

#pragma mark - Public Method

- (void)smr_enlargeTapEdge:(UIEdgeInsets)edge {
    objc_setAssociatedObject(self, &topNameKey, [NSNumber numberWithFloat:edge.top], OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &leftNameKey, [NSNumber numberWithFloat:edge.left], OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &bottomNameKey, [NSNumber numberWithFloat:edge.bottom], OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &rightNameKey, [NSNumber numberWithFloat:edge.right], OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)smr_makeImageToRight {
    [self smr_makeImageToRightWithSpace:0 alignment:SMRContentAlignmentCenter];
}

- (void)smr_makeImageToRightWithSpace:(CGFloat)space alignment:(SMRContentAlignment)alignment {
    [self layoutIfNeeded];
    CGFloat leftOffset = 0;
    CGFloat rightOffset = 0;
    switch (alignment) {
        case SMRContentAlignmentCenter: {} break;
        case SMRContentAlignmentLeft: {leftOffset = space;} break;
        case SMRContentAlignmentRight: {rightOffset = space;} break;
    }
    CGFloat labelWidth = CGRectGetWidth(self.titleLabel.frame);
    CGFloat imageWidth = CGRectGetWidth(self.imageView.frame);
    [self setTitleEdgeInsets:UIEdgeInsetsMake(0, leftOffset - space/2.0 - imageWidth, 0, rightOffset + space/2.0 + imageWidth)];
    [self setImageEdgeInsets:UIEdgeInsetsMake(0, leftOffset + space/2.0 + labelWidth, 0, rightOffset - space/2.0 - labelWidth)];
}

- (void)smr_makeImageAndTitleWithSpace:(CGFloat)space alignment:(SMRContentAlignment)alignment {
    CGFloat leftOffset = 0;
    CGFloat rightOffset = 0;
    switch (alignment) {
        case SMRContentAlignmentCenter: {} break;
        case SMRContentAlignmentLeft: {leftOffset = space;} break;
        case SMRContentAlignmentRight: {rightOffset = space;} break;
    }
    [self setImageEdgeInsets:UIEdgeInsetsMake(0, leftOffset - space/2.0, 0, rightOffset + space/2.0)];
    [self setTitleEdgeInsets:UIEdgeInsetsMake(0, leftOffset + space/2.0, 0, rightOffset - space/2.0)];
}

- (void)smr_makeImageRotation:(CGFloat)rotate {
    self.imageView.transform = CGAffineTransformMakeRotation(rotate);
}

#pragma mark - Private Method

- (CGRect)enlargedRect {
    NSNumber *topEdge = objc_getAssociatedObject(self, &topNameKey);
    NSNumber *leftEdge = objc_getAssociatedObject(self, &leftNameKey);
    NSNumber *bottomEdge = objc_getAssociatedObject(self, &bottomNameKey);
    NSNumber *rightEdge = objc_getAssociatedObject(self, &rightNameKey);
    if (topEdge && leftEdge && bottomEdge && rightEdge) {
        return CGRectMake(self.bounds.origin.x - leftEdge.floatValue,
                          self.bounds.origin.y - topEdge.floatValue,
                          self.bounds.size.width + leftEdge.floatValue + rightEdge.floatValue,
                          self.bounds.size.height + topEdge.floatValue + bottomEdge.floatValue);
    } else {
        return self.bounds;
    }
}

@end
