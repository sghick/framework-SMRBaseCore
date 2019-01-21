//
//  SMRNetAPIQueue.m
//  SMRBaseCoreDemo
//
//  Created by 丁治文 on 2019/1/21.
//  Copyright © 2019 sumrise. All rights reserved.
//

#import "SMRNetAPIQueue.h"

@interface SMRNetAPIQueue ()

@property (strong, nonatomic) NSMutableArray *queueArray;

@end

@implementation SMRNetAPIQueue

- (void)enqueue:(SMRNetAPI *)api {
    if (!api) {
        return;
    }
    NSLog(@"入队:%@", api);
    [self.queueArray addObject:api];
}

- (SMRNetAPI *)dequeue {
    SMRNetAPI *api = self.queueArray.firstObject;
    if (api) {
        [self.queueArray removeObject:api];
    }
    NSLog(@"出队:%@", api);
    return api;
}

#pragma mark - Getters

- (NSMutableArray *)queueArray {
    if (!_queueArray) {
        _queueArray = [NSMutableArray array];
    }
    return _queueArray;
}


@end
