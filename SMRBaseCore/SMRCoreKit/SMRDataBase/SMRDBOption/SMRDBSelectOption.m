//
//  SMRDBSelectOption.m
//  SMRDataBaseDemo
//
//  Created by 丁治文 on 2018/12/18.
//  Copyright © 2018 sumrise. All rights reserved.
//

#import "SMRDBSelectOption.h"

@implementation SMRDBSelectOption

- (instancetype)initWithModelClass:(Class)modelClass {
    return [super initWithTableName:NSStringFromClass(modelClass)
                         modelClass:modelClass
                        primaryKeys:nil];
    return self;
}

- (instancetype)initWithTableName:(NSString *)tableName {
    return [super initWithTableName:tableName];
}

- (NSString *)sql {
    SMRDBMapper *dbMapper = [self dbMapper];
    if (dbMapper == nil) {
        return nil;
    }
    
    BOOL validLimit = (self.limit.location != NSNotFound) && (self.limit.length != NSNotFound);
    NSString *sql = validLimit?[dbMapper sqlForSelectWhere:self.where limit:self.limit]:[dbMapper sqlForSelectWhere:self.where];
    return sql;
}

- (int)excuteInTransaction:(id<SMRTransactionItemDelegate>)item rollback:(BOOL *)rollback {
    NSArray *results = (NSArray *)[self queryInTransaction:item rollback:rollback];
    return (int)results.count;
}

- (id)queryInTransaction:(id<SMRTransactionItemDelegate>)item rollback:(BOOL *)rollback {
    NSString *sql = self.sql;
    base_core_datas_log(@"excute select:\n%@", sql);
    if (!sql.length) {
        return nil;
    }
    
    NSArray *results = nil;
    SMRDBMapper *dbMapper = [self dbMapper];
    if (self.paramsArray) {
        results = [self.dbManager querySQL:sql withParamsInArray:self.paramsArray inTransaction:item rollback:rollback];
    } else {
        results = [self.dbManager querySQL:sql withParamsInDictionary:self.paramsDict inTransaction:item rollback:rollback];
    }
    if (results && self.modelClass) {
        NSMutableArray *array = [NSMutableArray array];
        for (NSDictionary *dict in results) {
            NSObject *obj = [self.dbParser modelFromDict:dict class:self.modelClass withDBMapper:dbMapper];
            if (obj) {
                [array addObject:obj];
            }
        }
        if (array.count > 0) {
            results = [NSArray arrayWithArray:array];
        }
    }
    return results;
}

@end
