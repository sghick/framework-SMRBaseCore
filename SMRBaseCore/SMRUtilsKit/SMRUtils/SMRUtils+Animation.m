//
//  SMRUtils+Animation.m
//  SMRBaseCoreDemo
//
//  Created by 丁治文 on 2019/2/15.
//  Copyright © 2019 sumrise. All rights reserved.
//

#import "SMRUtils+Animation.h"

@implementation SMRUtils (Animation)

+ (CATransition *)fadeAnimationWithDuration:(double)duration {
    CATransition *animation = [CATransition animation];
    animation.duration = duration;
    animation.timingFunction = [CAMediaTimingFunction functionWithControlPoints:0.20 :0.03 :0.13 :1.00];
    animation.type = kCATransitionReveal;
    animation.subtype = kCATransitionFade;
    return animation;
}

+ (CATransform3D)transformWithDegree:(double)deg {
    double radnum = deg*3.1415926*0.00555556;
    CATransform3D t = CATransform3DMakeRotation(radnum, 0, 0, 1);
    return t;
}

@end
