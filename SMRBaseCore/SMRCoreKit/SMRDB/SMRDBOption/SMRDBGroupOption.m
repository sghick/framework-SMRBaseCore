//
//  SMRDBGroupOption.m
//  SMRDBDemo
//
//  Created by 丁治文 on 2018/9/23.
//  Copyright © 2018年 sumrise.com. All rights reserved.
//

#import "SMRDBGroupOption.h"

@implementation SMRDBGroupOption

- (int)excuteInTransaction:(id<SMRTransactionItemDelegate>)item rollback:(BOOL *)rollback {
    int count = 0;
    for (id<SMRDBOption> opt in self.options) {
        count += [opt excuteInTransaction:item rollback:rollback];
    }
    return count;
}

- (id)queryInTransaction:(id<SMRTransactionItemDelegate>)item rollback:(BOOL *)rollback {
    NSMutableArray *results = [NSMutableArray array];
    for (id<SMRDBOption> opt in self.options) {
        NSArray *array = [opt queryInTransaction:item rollback:rollback];
        if (array) {
            [results addObject:array];
        }
    }
    return [NSArray arrayWithArray:results];
}

- (void)addOption:(id<SMRDBOption>)option {
    if (!option) {
        return;
    }
    NSMutableArray *array = [NSMutableArray arrayWithArray:self.options];
    [array addObject:option];
    self.options = [NSArray arrayWithArray:array];
}

- (void)addOptions:(NSArray<id<SMRDBOption>> *)options {
    if (!options || (options.count == 0)) {
        return;
    }
    NSMutableArray *array = [NSMutableArray arrayWithArray:self.options];
    [array addObjectsFromArray:options];
    self.options = [NSArray arrayWithArray:array];
}

@end
