//
//  SMRDBSqlOption.m
//  SMRDataBaseDemo
//
//  Created by 丁治文 on 2018/12/18.
//  Copyright © 2018 sumrise. All rights reserved.
//

#import "SMRDBSqlOption.h"

@implementation SMRDBSqlOption

- (NSString *)sql {
    SMRDBMapper *dbMapper = [self dbMapper];
    if (dbMapper == nil) {
        return nil;
    }
    
    _sql = [dbMapper sqlForReplaceFromSql:_sql];
    return _sql;
}

- (int)excuteInTransaction:(id<SMRTransactionItemDelegate>)item rollback:(BOOL *)rollback {
    int count = 0;
    NSArray *sqls = [self componentsSeparatedSql:self.sql];
    base_core_datas_log(@"excute sqls:\n%@", sqls);
    if (self.paramsArray) {
        for (NSString *sql in sqls) {
            if (![self validateSql:sql]) {
                continue;
            }
            count += [self.dbManager excuteSQL:sql withParamsInArray:self.paramsArray inTransaction:item rollback:rollback];
        }
    } else {
        for (NSString *sql in sqls) {
            if (![self validateSql:sql]) {
                continue;
            }
            count += [self.dbManager excuteSQL:sql withParamsInDictionary:self.paramsDict inTransaction:item rollback:rollback];
        }
    }
    return count;
}

- (id)queryInTransaction:(id<SMRTransactionItemDelegate>)item rollback:(BOOL *)rollback {
    id result = nil;
    NSArray *sqls = [self componentsSeparatedSql:self.sql];
    base_core_datas_log(@"query sqls:\n%@", sqls);
    if (self.paramsArray) {
        for (NSString *sql in sqls) {
            if (![self validateSql:sql]) {
                continue;
            }
            result = [self.dbManager querySQL:sql withParamsInArray:self.paramsArray inTransaction:item rollback:rollback];
        }
    } else {
        for (NSString *sql in sqls) {
            if (![self validateSql:sql]) {
                continue;
            }
            result = [self.dbManager querySQL:sql withParamsInDictionary:self.paramsDict inTransaction:item rollback:rollback];
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
