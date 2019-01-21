//
//  SMRDBUtilOption.m
//  SMRDBDemo
//
//  Created by 丁治文 on 2018/9/23.
//  Copyright © 2018年 sumrise.com. All rights reserved.
//

#import "SMRDBUtilOption.h"
#import "SMRDBAdapter.h"
#import "SMRDBTableOption.h"

@implementation SMRDBUtilOption

#pragma mark - DBUtils
+ (BOOL)ifTableExistWithName:(NSString *)tableName {
    __block BOOL result = NO;
    [[SMRDBAdapter shareInstance].dbManager doOptionInTransaction:^(id<SMRTransactionItemDelegate> item, BOOL *rollback) {
        result = [SMRDBTableOption ifTableExistWithName:tableName inTransaction:item rollback:rollback];
    }];
    return result;
}

+ (BOOL)dropTableWithName:(NSString *)tableName {
    __block BOOL result = NO;
    [[SMRDBAdapter shareInstance].dbManager doOptionInTransaction:^(id<SMRTransactionItemDelegate> item, BOOL *rollback) {
        result = [SMRDBTableOption dropTableWithName:tableName inTransaction:item rollback:rollback];
    }];
    return result;
}

+ (NSArray *)selectExistedTablesNames {
    __block NSArray *result = nil;
    [[SMRDBAdapter shareInstance].dbManager doOptionInTransaction:^(id<SMRTransactionItemDelegate> item, BOOL *rollback) {
        result = [SMRDBTableOption selectExistedTablesNamesInTransaction:item rollback:rollback];
    }];
    return result;
}

+ (BOOL)deleteAllTablesData {
    __block BOOL result = NO;
    [[SMRDBAdapter shareInstance].dbManager doOptionInTransaction:^(id<SMRTransactionItemDelegate> item, BOOL *rollback) {
        result = [SMRDBTableOption deleteAllTablesDataInTransaction:item rollback:rollback];
    }];
    return result;
}

@end
