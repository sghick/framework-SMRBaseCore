//
//  SMRDBSelectOption.m
//  SMRDBDemo
//
//  Created by 丁治文 on 2018/9/23.
//  Copyright © 2018年 sumrise.com. All rights reserved.
//

#import "SMRDBSelectOption.h"
#import "SMRDBAdapter.h"
#import "SMRDBMapper.h"

@implementation SMRDBSelectOption

- (instancetype)initWithModelClass:(Class)modelClass {
    self = [super init];
    if (self) {
        _modelClass = modelClass;
    }
    return self;
}

- (instancetype)initWithTableName:(NSString *)tableName {
    self = [super init];
    if (self) {
        _tableName = tableName;
    }
    return self;
}

- (NSString *)tableName {
    if (_tableName == nil) {
        if (_modelClass != NULL) {
            return NSStringFromClass(_modelClass);
        }
    }
    return _tableName;
}

- (int)excuteInTransaction:(id<SMRTransactionItemDelegate>)item rollback:(BOOL *)rollback {
    NSArray *results = (NSArray *)[self queryInTransaction:item rollback:rollback];
    return (int)results.count;
}

- (id)queryInTransaction:(id<SMRTransactionItemDelegate>)item rollback:(BOOL *)rollback {
    NSArray *results = nil;
    SMRDBMapper *dbMapper = [self dbMapper];
    if (dbMapper == nil) {
        return results;
    }
    BOOL validLimit = (self.limit.location != NSNotFound) && (self.limit.length != NSNotFound);
    NSString *sql = validLimit?[dbMapper sqlForSelectWhere:self.where limit:self.limit]:[dbMapper sqlForSelectWhere:self.where];
    if (self.paramsArray) {
        results = [[[SMRDBAdapter shareInstance].dbManager class] querySQL:sql withParamsInArray:self.paramsArray inTransaction:item rollback:rollback];
    } else {
        results = [[[SMRDBAdapter shareInstance].dbManager class] querySQL:sql withParamsInDictionary:self.paramsDict inTransaction:item rollback:rollback];
    }
    if (results && self.modelClass) {
        NSMutableArray *array = [NSMutableArray array];
        for (NSDictionary *dict in results) {
            NSObject *obj = [[SMRDBAdapter shareInstance].dbParser modelFromDict:dict class:self.modelClass withDBMapper:dbMapper];
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

- (SMRDBMapper *)dbMapper {
    SMRDBMapper *dbMapper = [SMRDBMapper dbMapperWithClass:self.modelClass
                                                 tableName:self.tableName];
    return dbMapper;
}
@end
