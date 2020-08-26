//
//  SMRDBInsertOption.m
//  SMRDataBaseDemo
//
//  Created by 丁治文 on 2018/12/18.
//  Copyright © 2018 sumrise. All rights reserved.
//

#import "SMRDBInsertOption.h"

@implementation SMRDBInsertOption

- (instancetype)init {
    return [self initWithObjects:nil];
}

- (instancetype)initWithObjects:(NSArray *)objs {
    Class cls = [objs.firstObject class];
    self = [super initWithTableName:NSStringFromClass(cls)
                         modelClass:cls
                        primaryKeys:nil];
    if (self) {
        _objects = objs;
        _insertType = SMRDBInsertOptionTypeInsertOrReplace;
    }
    return self;
}

- (NSString *)sql {
    SMRDBMapper *dbMapper = self.dbMapper;
    if (!dbMapper) {
        return nil;
    }
    NSString *sql = nil;
    switch (self.insertType) {
        case SMRDBInsertOptionTypeInsert:{sql = [dbMapper sqlForInsert];} break;
        case SMRDBInsertOptionTypeInsertOrReplace:{sql = [dbMapper sqlForInsertOrReplace];} break;
        case SMRDBInsertOptionTypeInsertOrIgnore:{sql = [dbMapper sqlForInsertOrIgnore];} break;
        default: break;
    }
    return sql;
}

- (int)excuteInTransaction:(id<SMRTransactionItemDelegate>)item rollback:(BOOL *)rollback {
    NSString *sql = self.sql;
    base_core_datas_log(@"excute insert:\n%@", sql);
    if (sql == nil) {
        return 0;
    }
    
    int count = 0;
    SMRDBMapper *dbMapper = self.dbMapper;
    for (id model in self.objects) {
        NSDictionary *params = [self.dbParser sqlParamsDictFromModel:model withDBMapper:dbMapper];
        if (self.generalParam) {
            NSMutableDictionary *gen = [NSMutableDictionary dictionaryWithDictionary:params];
            [gen setValuesForKeysWithDictionary:self.generalParam];
            params = [NSDictionary dictionaryWithDictionary:gen];
        }
        BOOL result = [self.dbManager excuteSQL:sql
                                                         withParamsInDictionary:params
                                                                  inTransaction:item
                                                                       rollback:rollback];
        count += result;
    }
    return count;
}

- (id)queryInTransaction:(id<SMRTransactionItemDelegate>)item rollback:(BOOL *)rollback {
    return @([self excuteInTransaction:item rollback:rollback]);
}

#pragma mark - Base

- (int)excute {
    [self setAlterTableWithModelClass:self.modelClass
                            tableName:self.tableName
                          primaryKeys:self.primaryKeys];
    return [super excute];
}

- (id)query {
    [self setAlterTableWithModelClass:self.modelClass
                            tableName:self.tableName
                          primaryKeys:self.primaryKeys];
    return [super query];
}

@end
