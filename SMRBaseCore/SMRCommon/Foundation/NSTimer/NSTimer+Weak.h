//
//  NSTimer+Weak.h
//  SMRBaseCoreDemo
//
//  Created by Tinswin on 2020/6/15.
//  Copyright © 2020 sumrise. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSTimer (Weak)

+ (NSTimer *)smr_scheduledTimerWithTimeInterval:(NSTimeInterval)interval repeats:(BOOL)repeats block:(void (^)(NSTimer *timer))block;

+ (NSTimer *)smr_scheduledTimerWithTimeInterval:(NSTimeInterval)interval repeats:(BOOL)repeats block:(void (^)(NSTimer *timer))block fromMode:(NSRunLoopMode)mode;

@end

NS_ASSUME_NONNULL_END
