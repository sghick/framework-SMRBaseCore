//
//  NSTimer+Weak.m
//  SMRBaseCoreDemo
//
//  Created by Tinswin on 2019/3/18.
//  Copyright © 2019年 sumrise. All rights reserved.
//

#import "NSTimer+Weak.h"

@implementation NSTimer (Weak)

+ (NSTimer *)smr_scheduledTimerWithTimeInterval:(NSTimeInterval)interval repeats:(BOOL)repeats block:(void (^)(NSTimer * _Nonnull))block {
    return [self scheduledTimerWithTimeInterval:interval target:self selector:@selector(smr_callBlock:) userInfo:[block copy] repeats:repeats];
}

+ (NSTimer *)smr_scheduledTimerWithTimeInterval:(NSTimeInterval)interval repeats:(BOOL)repeats block:(void (^)(NSTimer * _Nonnull))block fromMode:(NSRunLoopMode)mode {
    NSTimer *timer = [self smr_scheduledTimerWithTimeInterval:interval repeats:repeats block:block];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:mode];
    return timer;
}

+ (void)smr_callBlock:(NSTimer *)timer {
    void (^block)(NSTimer *timer) = timer.userInfo;
    !block ?: block(timer);
}

@end
