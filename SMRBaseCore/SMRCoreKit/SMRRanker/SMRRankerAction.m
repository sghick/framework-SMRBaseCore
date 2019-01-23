//
//  SMRRankerAction.m
//  SMRRankerDemo
//
//  Created by 丁治文 on 2018/7/28.
//  Copyright © 2018年 sumrise.com. All rights reserved.
//

#import "SMRRankerAction.h"
#import "SMRRankerLifecycleManager.h"

@implementation SMRRankerAction

- (instancetype)initWithIdentifier:(NSString *)identifier {
    return [self initWithIdentifier:identifier completionBlock:nil];
}

- (instancetype)initWithIdentifier:(NSString *)identifier
                   completionBlock:(SMRRankerActionCompletionBlock)completionBlock {
    self = [super init];
    if (self) {
        _identifier = identifier;
        _completionBlock = completionBlock;
        _lifecycle = SMRRankerLifecycleLaunch;
        _checkCount = 1;
        _enable = YES;
    }
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"{%@\tdel:%@\tsta:%@\teab:%@}", _identifier, @(_markDeleted), @(_status), @(_enable)];
}

- (void)setLifecycle:(SMRRankerLifecycle)lifecycle checkCount:(NSInteger)checkCount {
    _lifecycle = lifecycle;
    _checkCount = checkCount;
}

- (void)setCustomTime:(NSTimeInterval)customTime checkCount:(NSInteger)checkCount {
    _lifecycle = SMRRankerLifecycleCustomTime;
    _customTime = customTime;
    _checkCount = checkCount;
}

- (void)performAction {
    if (self.completionBlock) {
        self.completionBlock(self);
    }
}

@end
