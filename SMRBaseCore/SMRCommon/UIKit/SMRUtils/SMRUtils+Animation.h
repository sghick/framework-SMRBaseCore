//
//  SMRUtils+Animation.h
//  SMRBaseCoreDemo
//
//  Created by 丁治文 on 2019/2/15.
//  Copyright © 2019 sumrise. All rights reserved.
//

#import "SMRUtils.h"

NS_ASSUME_NONNULL_BEGIN

@interface SMRUtils (Animation)

/** 淡入淡出的动画效果 */
+ (CATransition *)fadeAnimationWithDuration:(double)duration;

/** 3D翻转 */
+ (CATransform3D )transformWithDegree:(double)deg;

@end

NS_ASSUME_NONNULL_END
