//
//  SMRDBUpdateOption.m
//  SMRDataBaseDemo
//
//  Created by 丁治文 on 2018/12/18.
//  Copyright © 2018 sumrise. All rights reserved.
//

#import "SMRDBUpdateOption.h"

@implementation SMRDBUpdateOption

- (instancetype)initWithObject:(NSObject *)obj {
    Class cls = [obj class];
    self = [super initWithTableName:NSStringFromClass(cls)
                         modelClass:cls
                        primaryKeys:nil];
    if (self) {
        _object = obj;
    }
    return self;
}

- (instancetype)initWithTableName:(NSString *)tableName where:(NSString *)where paramsArray:(NSArray *)paramsArray {
    self = [super initWithTableName:tableName];
    if (self) {
        _where = where;
        _paramsArray = paramsArray;
    }
    return self;
}

- (NSString *)sql {
    SMRDBMapper *dbMapper = [self dbMapper];
    if (dbMapper == nil) {
        return nil;
    }
    NSString *sql = self.object ? [dbMapper sqlForUpdateWhere:self.where] : [dbMapper sqlForUpdateSetWhere:self.where];;
    return sql;
}

- (int)excuteInTransaction:(id<SMRTransactionItemDelegate>)item rollback:(BOOL *)rollback {
    NSString *sql = self.sql;
    base_core_datas_log(@"excute update:\n%@", sql);
    if (!sql.length) {
        return 0;
    }
    
    SMRDBMapper *dbMapper = [self dbMapper];
    if (self.object) {
        NSDictionary *params = [self.dbParser sqlParamsDictFromModel:self.object withDBMapper:dbMapper];
        BOOL isSuccess = [self.dbManager excuteSQL:sql withParamsInDictionary:params inTransaction:item rollback:rollback];
        return isSuccess;
    } else {
        BOOL isSuccess = [self.dbManager excuteSQL:sql withParamsInArray:self.paramsArray inTransaction:item rollback:rollback];
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
