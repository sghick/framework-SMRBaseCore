//
//  SMRDBGroupOption.m
//  SMRDataBaseDemo
//
//  Created by 丁治文 on 2018/12/18.
//  Copyright © 2018 sumrise. All rights reserved.
//

#import "SMRDBGroupOption.h"

@implementation SMRDBGroupOption

- (NSString *)sql {
    NSMutableString *sql = [NSMutableString string];
    for (id<SMRDBOption> opt in self.options) {
        NSString *s = opt.sql;
        if (s) {
            [sql stringByAppendingFormat:@"%@;\n", s];
        }
    }
    return [sql copy];
}

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
