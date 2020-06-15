//
//  UIView+SMRAdapter.h
//  SMRBaseCoreDemo
//
//  Created by 丁治文 on 2019/2/18.
//  Copyright © 2019 sumrise. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

static NSInteger const kTagForSMRAdapterBottomView = 541608;

@interface UIView (SMRAdapter)

/** 给view的底部添加一个定高定色的view */
- (nullable UIView *)setSafeAreaViewWithColor:(UIColor *)color;

/** 给view的底部添加一个定高定色的view,指定高 */
- (nullable UIView *)setSafeAreaViewWithColor:(UIColor *)color height:(CGFloat)height;

/** 获取safeAreaView */
- (nullable UIView *)safeAreaView;

/** 将safeAreaView层级上提 */
- (void)bringSafeAreaViewToFront;

/** 给view的底部view更换颜色 */
- (void)updateSafeAreaViewColor:(UIColor *)color;

/** 给view设置圆角的maskLayer */
- (void)setRoundCornersWithRadius:(CGFloat)radius;
- (void)setRoundCorners:(UIRectCorner)corners radii:(CGSize)radii;

/** 给view设置渐变色的layer */
- (void)addGradientLayerWithColors:(NSArray<UIColor *> *)colors
                verticalTransition:(BOOL)verticalTransition;
- (void)addGradientLayerWithStartPoint:(CGPoint)startPoint
                              endPoint:(CGPoint)endPoint
                                colors:(NSArray<UIColor *> *)colors;
- (void)addGradientLayerWithStartPoint:(CGPoint)startPoint
                              endPoint:(CGPoint)endPoint
                                colors:(NSArray<UIColor *> *)colors
                             locations:(nullable NSArray<NSNumber *> *)locations;

@end

NS_ASSUME_NONNULL_END
