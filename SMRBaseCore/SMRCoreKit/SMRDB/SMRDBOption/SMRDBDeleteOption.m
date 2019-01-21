//
//  SMRDBDeleteOption.m
//  SMRDBDemo
//
//  Created by 丁治文 on 2018/9/23.
//  Copyright © 2018年 sumrise.com. All rights reserved.
//

#import "SMRDBDeleteOption.h"
#import "SMRDBAdapter.h"
#import "SMRDBMapper.h"

@implementation SMRDBDeleteOption

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
    SMRDBMapper *dbMapper = [self dbMapper];
    if (dbMapper == nil) {
        return 0;
    }
    NSString *sql = [dbMapper sqlForDeleteWhere:self.where];
    BOOL result = NO;
    if (self.paramsArray) {
        result = [[[SMRDBAdapter shareInstance].dbManager class] excuteSQL:sql withParamsInArray:self.paramsArray inTransaction:item rollback:rollback];
    } else {
        result = [[[SMRDBAdapter shareInstance].dbManager class] excuteSQL:sql withParamsInDictionary:self.paramsDict inTransaction:item rollback:rollback];
    }
    return result;
}

- (id)queryInTransaction:(id<SMRTransactionItemDelegate>)item rollback:(BOOL *)rollback {
    return @([self excuteInTransaction:item rollback:rollback]);
}

- (SMRDBMapper *)dbMapper {
    SMRDBMapper *dbMapper = [SMRDBMapper dbMapperWithClass:self.modelClass
                                                 tableName:self.tableName];
    return dbMapper;
}

@end
