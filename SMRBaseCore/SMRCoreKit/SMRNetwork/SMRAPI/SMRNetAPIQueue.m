//
//  SMRNetAPIQueue.m
//  SMRBaseCoreDemo
//
//  Created by 丁治文 on 2019/1/21.
//  Copyright © 2019 sumrise. All rights reserved.
//

#import "SMRNetAPIQueue.h"
#import "SMRLog.h"

@interface SMRNetAPIQueue ()

@property (strong, nonatomic) NSMutableArray *queueArray;

@end

@implementation SMRNetAPIQueue

- (void)enqueue:(SMRNetAPI *)api {
    if (!api) {
        return;
    }
    base_core_log(@"入队:%@", api);
    [self.queueArray addObject:api];
}

- (SMRNetAPI *)dequeue {
    SMRNetAPI *api = self.queueArray.firstObject;
    if (api) {
        [self.queueArray removeObject:api];
    }
    base_core_log(@"出队:%@", api);
    return api;
}

- (void)clearQueue {
    [self.queueArray removeAllObjects];
}

#pragma mark - Getters

- (NSMutableArray *)queueArray {
    if (!_queueArray) {
        _queueArray = [NSMutableArray array];
    }
    return _queueArray;
}


@end
