//
//  UIView+SMRShadowView.m
//  SMRBaseCoreDemo
//
//  Created by Tinswin on 2020/6/10.
//  Copyright © 2020 sumrise. All rights reserved.
//

#import "UIView+SMRShadowView.h"

@implementation SMRShadowItem

@end

@implementation UIView (SMRShadowView)

- (void)setShadowWithItem:(SMRShadowItem *)shadowItem {
    [self setShadowWithItem:shadowItem shadowPath:nil];
}

- (void)setShadowWithItem:(SMRShadowItem *)shadowItem shadowPath:(UIBezierPath *)shadowPath {
    self.layer.shadowColor = shadowItem.shadowColor.CGColor;
    self.layer.shadowOpacity = shadowItem.shadowOpacity;
    self.layer.shadowOffset = shadowItem.shadowOffset;
    self.layer.cornerRadius = shadowItem.cornerRadius;
    self.layer.shadowRadius = shadowItem.shadowRadius;
    self.layer.shadowPath = shadowPath.CGPath;
}

- (void)addReflection {
    [self.layer addSublayer:[self reflectionLayer]];
}

- (CALayer *)reflectionLayer {
    UIView *view = self;
    // 制作reflection
    CALayer *reflectLayer = [CALayer layer];
    reflectLayer.contents = view.layer.contents;
    reflectLayer.bounds = view.layer.bounds;
    reflectLayer.position = CGPointMake(view.layer.bounds.size.width/2, view.layer.bounds.size.height*1.5);
    reflectLayer.transform = CATransform3DMakeRotation(M_PI, 1, 0, 0);
    
    // 给该reflection加个半透明的layer
    CALayer *blackLayer = [CALayer layer];
    blackLayer.cornerRadius = view.layer.cornerRadius;
    blackLayer.borderWidth = view.layer.borderWidth;
    blackLayer.borderColor = view.layer.borderColor;
    blackLayer.backgroundColor = [UIColor whiteColor].CGColor;
    blackLayer.bounds = reflectLayer.bounds;
    blackLayer.position = CGPointMake(blackLayer.bounds.size.width/2, blackLayer.bounds.size.height/2);
    blackLayer.opacity = 0.2;
    [reflectLayer addSublayer:blackLayer];
    
    // 给该reflection加个mask
    CAGradientLayer *mask = [CAGradientLayer layer];
    mask.bounds = reflectLayer.bounds;
    mask.position = CGPointMake(mask.bounds.size.width/2, mask.bounds.size.height/2);
    mask.colors = [NSArray arrayWithObjects:
                   (__bridge id)[UIColor clearColor].CGColor,
                   (__bridge id)[UIColor whiteColor].CGColor, nil];
    mask.startPoint = CGPointMake(0.5, 0.35);
    mask.endPoint = CGPointMake(0.5, 1.0);
    reflectLayer.mask = mask;
    
    return reflectLayer;
}

@end
