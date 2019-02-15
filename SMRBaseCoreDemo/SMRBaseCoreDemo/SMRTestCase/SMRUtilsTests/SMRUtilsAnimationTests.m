//
//  SMRUtilsAnimationTests.m
//  SMRBaseCoreDemo
//
//  Created by 丁治文 on 2019/2/15.
//  Copyright © 2019 sumrise. All rights reserved.
//

#import "SMRUtilsAnimationTests.h"

@implementation SMRUtilsAnimationTests

- (id)begin {
    UIView *jerview = [[UIView alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    jerview.backgroundColor = [UIColor redColor];
    [[UIApplication sharedApplication].delegate.window addSubview:jerview];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((1.0) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSTimeInterval duration = 2.0;
        CAAnimation *animation = [SMRUtils fadeAnimationWithDuration:duration];
        [jerview.layer addAnimation:animation forKey:@"jerview"];
        [UIView animateWithDuration:duration animations:^{
            jerview.frame = CGRectMake(200, 200, 200, 200);
        }];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((duration + 1.0) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [jerview removeFromSuperview];
        });
    });
    
    return self;
}

@end
