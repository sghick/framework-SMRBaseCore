//
//  SMRDBUpdateOption.m
//  SMRDBDemo
//
//  Created by 丁治文 on 2018/9/23.
//  Copyright © 2018年 sumrise.com. All rights reserved.
//

#import "SMRDBUpdateOption.h"
#import "SMRDBAdapter.h"
#import "SMRDBMapper.h"

@implementation SMRDBUpdateOption

- (instancetype)initWithObject:(NSObject *)obj {
    self = [super init];
    if (self) {
        _object = obj;
    }
    return self;
}

- (instancetype)initWithTableName:(NSString *)tableName where:(NSString *)where paramsArray:(NSArray *)paramsArray {
    self = [super init];
    if (self) {
        _tableName = tableName;
        _where = where;
        _paramsArray = paramsArray;
    }
    return self;
}

- (NSString *)tableName {
    if (_tableName == nil) {
        if (_object != nil) {
            return NSStringFromClass([_object class]);
        }
    }
    return _tableName;
}

- (int)excuteInTransaction:(id<SMRTransactionItemDelegate>)item rollback:(BOOL *)rollback {
    SMRDBMapper *dbMapper = [self dbMapper];
    if (dbMapper == nil) {
        return NO;
    }
    if (self.object) {
        NSDictionary *params = [[SMRDBAdapter shareInstance].dbParser sqlParamsDictFromModel:self.object withDBMapper:dbMapper];
        NSString *sql = [dbMapper sqlForUpdateWhere:self.where];
        BOOL isSuccess = [[[SMRDBAdapter shareInstance].dbManager class] excuteSQL:sql withParamsInDictionary:params inTransaction:item rollback:rollback];
        return isSuccess;
    } else {
        NSString *sql = [dbMapper sqlForUpdateSetWhere:self.where];
        BOOL isSuccess = [[[SMRDBAdapter shareInstance].dbManager class] excuteSQL:sql withParamsInArray:self.paramsArray inTransaction:item rollback:rollback];
        return isSuccess;
    }
}

- (id)queryInTransaction:(id<SMRTransactionItemDelegate>)item rollback:(BOOL *)rollback {
    return @([self excuteInTransaction:item rollback:rollback]);
}

- (SMRDBMapper *)dbMapper {
    Class modelClass = [self.object class];
    SMRDBMapper *dbMapper = [SMRDBMapper dbMapperWithClass:modelClass
                                                 tableName:self.tableName];
    return dbMapper;
}

@end
