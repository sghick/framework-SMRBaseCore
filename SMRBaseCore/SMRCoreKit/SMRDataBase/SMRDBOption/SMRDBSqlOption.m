//
//  SMRDBSqlOption.m
//  SMRDBDemo
//
//  Created by 丁治文 on 2018/9/23.
//  Copyright © 2018年 sumrise.com. All rights reserved.
//

#import "SMRDBSqlOption.h"
#import "SMRDBAdapter.h"

@implementation SMRDBSqlOption

- (int)excuteInTransaction:(id<SMRTransactionItemDelegate>)item rollback:(BOOL *)rollback {
    int count = 0;
    NSArray *sqls = [self componentsSeparatedSql:self.sql];
    if (self.paramsArray) {
        for (NSString *sql in sqls) {
            if (![self validateSql:sql]) {
                continue;
            }
            count += [[[SMRDBAdapter shareInstance].dbManager class] excuteSQL:sql withParamsInArray:self.paramsArray inTransaction:item rollback:rollback];
        }
    } else {
        for (NSString *sql in sqls) {
            if (![self validateSql:sql]) {
                continue;
            }
            count += [[[SMRDBAdapter shareInstance].dbManager class] excuteSQL:sql withParamsInDictionary:self.paramsDict inTransaction:item rollback:rollback];
        }
    }
    return count;
}

- (id)queryInTransaction:(id<SMRTransactionItemDelegate>)item rollback:(BOOL *)rollback {
    id result = nil;
    NSArray *sqls = [self componentsSeparatedSql:self.sql];
    if (self.paramsArray) {
        for (NSString *sql in sqls) {
            if (![self validateSql:sql]) {
                continue;
            }
            result = [[[SMRDBAdapter shareInstance].dbManager class] querySQL:sql withParamsInArray:self.paramsArray inTransaction:item rollback:rollback];
        }
    } else {
        for (NSString *sql in sqls) {
            if (![self validateSql:sql]) {
                continue;
            }
            result = [[[SMRDBAdapter shareInstance].dbManager class] querySQL:sql withParamsInDictionary:self.paramsDict inTransaction:item rollback:rollback];
        }
    }
    return result;
}

- (NSArray<NSString *> *)componentsSeparatedSql:(NSString *)sql {
    if (!sql || !sql.length) {
        return nil;
    }
    NSArray *sqls = [sql componentsSeparatedByString:@";"];
    return sqls;
}

- (BOOL)validateSql:(NSString *)sql {
    if (!sql || !sql.length) {
        return NO;
    }
    NSString *ssq = [sql stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (ssq.length == 0) {
        return NO;
    }
    return YES;
}

@end
