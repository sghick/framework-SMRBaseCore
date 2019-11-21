//
//  UIView+SMRAdapter.m
//  SMRBaseCoreDemo
//
//  Created by 丁治文 on 2019/2/18.
//  Copyright © 2019 sumrise. All rights reserved.
//

#import "UIView+SMRAdapter.h"
#import "SMRUIAdapter.h"
#import "PureLayout.h"

@implementation UIView (SMRAdapter)

- (UIView *)setSafeAreaViewWithColor:(UIColor *)color {
    return [self setSafeAreaViewWithColor:color height:BOTTOM_HEIGHT];
}

- (UIView *)setSafeAreaViewWithColor:(UIColor *)color height:(CGFloat)height {
    if (height == 0) {
        return nil;
    }
    UIView *view = [self safeAreaView];
    if (view) {
        view.backgroundColor = color;
        return view;
    }
    view = [[UIView alloc] init];
    view.backgroundColor = color;
    view.tag = kTagForSMRAdapterBottomView;
    [self addSubview:view];
    
    [view autoPinEdgeToSuperviewEdge:ALEdgeBottom];
    [view autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [view autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [view autoSetDimension:ALDimensionHeight toSize:height];
    return view;
}

- (UIView *)safeAreaView {
    UIView *view = [self viewWithTag:kTagForSMRAdapterBottomView];
    return view;
}

- (void)bringSafeAreaViewToFront {
    UIView *view = [self safeAreaView];
    if (view) {
        [self bringSubviewToFront:view];
    }
}

- (void)updateSafeAreaViewColor:(UIColor *)color {
    UIView *view = [self safeAreaView];
    if (view) {
        view.backgroundColor = color;
    }
}

- (void)setRoundCornersWithRadius:(CGFloat)radius {
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:radius];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}

- (void)setRoundCorners:(UIRectCorner)corners radii:(CGSize)radii {
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:corners cornerRadii:radii];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}

- (void)addGradientLayerWithColors:(NSArray<UIColor *> *)colors
                verticalTransition:(BOOL)verticalTransition {
    if (verticalTransition) {
        [self addGradientLayerWithStartPoint:CGPointMake(0.5, 0)
                                    endPoint:CGPointMake(0.5, 1)
                                      colors:colors];
    } else {
        [self addGradientLayerWithStartPoint:CGPointMake(0, 0.5)
                                    endPoint:CGPointMake(1, 0.5)
                                      colors:colors];
    }
}

- (void)addGradientLayerWithStartPoint:(CGPoint)startPoint
                              endPoint:(CGPoint)endPoint
                                colors:(NSArray<UIColor *> *)colors {
    [self addGradientLayerWithStartPoint:startPoint endPoint:endPoint colors:colors locations:nil];
}

- (void)addGradientLayerWithStartPoint:(CGPoint)startPoint
                              endPoint:(CGPoint)endPoint
                                colors:(NSArray<UIColor *> *)colors
                             locations:(nullable NSArray<NSNumber *> *)locations {
    if (!colors || colors.count == 0) {
        return;
    }
    CAGradientLayer *layer = [CAGradientLayer layer];
    layer.startPoint = startPoint;
    layer.endPoint = endPoint;
    if (locations) {
        layer.locations = locations;
    }
    NSMutableArray *colorArray = [NSMutableArray array];
    for (UIColor *color in colors) {
        [colorArray addObject:(id)color.CGColor];
    }
    layer.colors = [NSArray arrayWithArray:colorArray];
    layer.frame = self.bounds;
    [self.layer addSublayer:layer];
}

@end
