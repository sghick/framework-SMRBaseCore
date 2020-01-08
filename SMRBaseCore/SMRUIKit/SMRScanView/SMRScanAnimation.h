//
//  SMRScanAnimation.h
//  Gucci
//
//  Created by Tinswin on 2020/1/8.
//  Copyright © 2020 sumrise. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol SMRScanAnimation <NSObject>

/** 开始扫码线动画 */
- (void)startAnimatingWithRect:(CGRect)animationRect inView:(UIView*)parentView image:(UIImage*)image;

/** 停止动画 */
- (void)stopAnimating;

@end

@interface SMRScanAnimation : UIImageView<SMRScanAnimation>

- (void)setupAnimation;

@end

NS_ASSUME_NONNULL_END
