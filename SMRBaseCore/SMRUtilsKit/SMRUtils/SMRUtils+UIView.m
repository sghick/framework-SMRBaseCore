//
//  SMRUtils+UIView.m
//  SMRBaseCoreDemo
//
//  Created by 丁治文 on 2019/2/14.
//  Copyright © 2019 sumrise. All rights reserved.
//

#import "SMRUtils+UIView.h"

@implementation SMRUtils (UIView)

+ (void)addReflection:(UIView *)view {
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
    
    // 作为layer的sublayer
    [view.layer addSublayer:reflectLayer];
}

@end
