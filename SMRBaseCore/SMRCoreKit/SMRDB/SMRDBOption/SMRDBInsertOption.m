//
//  SMRDBInsertOption.m
//  SMRDBDemo
//
//  Created by 丁治文 on 2018/9/23.
//  Copyright © 2018年 sumrise.com. All rights reserved.
//

#import "SMRDBInsertOption.h"
#import "SMRDBAdapter.h"
#import "SMRDBMapper.h"
#import "SMRDBTableOption.h"

@implementation SMRDBInsertOption

- (instancetype)init {
    return [self initWithObjects:nil];
}

- (instancetype)initWithObjects:(NSArray *)objs {
    self = [super init];
    if (self) {
        _objects = objs;
        _insertType = SMRDBInsertOptionTypeInsertOrReplace;
    }
    return self;
}

- (NSString *)tableName {
    if (_tableName == nil) {
        if (_objects != nil) {
            return NSStringFromClass([_objects.firstObject class]);
        }
    }
    return _tableName;
}

- (int)excuteInTransaction:(id<SMRTransactionItemDelegate>)item rollback:(BOOL *)rollback {
    int count = 0;
    SMRDBMapper *dbMapper = [self dbMapper];
    if (dbMapper == nil) {
        return count;
    }
    
    BOOL isTableModifiedSuccess = [SMRDBTableOption createAndAlterTableWithDbMapper:dbMapper inTransaction:item rollback:rollback];
    if (isTableModifiedSuccess == YES) {
        NSString *sql = nil;
        switch (self.insertType) {
            case SMRDBInsertOptionTypeInsert:{sql = [dbMapper sqlForInsert];} break;
            case SMRDBInsertOptionTypeInsertOrReplace:{sql = [dbMapper sqlForInsertOrReplace];} break;
            case SMRDBInsertOptionTypeInsertOrIgnore:{sql = [dbMapper sqlForInsertOrIgnore];} break;
            default: break;
        }
        if (sql == nil) {
            return count;
        }
        
        for (id model in self.objects) {
            NSDictionary *params = [[SMRDBAdapter shareInstance].dbParser sqlParamsDictFromModel:model withDBMapper:dbMapper];
            if (self.generalParam) {
                NSMutableDictionary *gen = [NSMutableDictionary dictionaryWithDictionary:params];
                [gen setValuesForKeysWithDictionary:self.generalParam];
                params = [NSDictionary dictionaryWithDictionary:gen];
            }
            BOOL result = [[[SMRDBAdapter shareInstance].dbManager class] excuteSQL:sql
                                                             withParamsInDictionary:params
                                                                      inTransaction:item
                                                                           rollback:rollback];
            count += result;
        }
    }
    return count;
}

- (id)queryInTransaction:(id<SMRTransactionItemDelegate>)item rollback:(BOOL *)rollback {
    return @([self excuteInTransaction:item rollback:rollback]);
}

- (SMRDBMapper *)dbMapper {
    Class modelClass = [self.objects.firstObject class];
    SMRDBMapper *dbMapper = [SMRDBMapper dbMapperWithClass:modelClass
                                                 tableName:self.tableName
                                               primaryKeys:self.primaryKeys];
    return dbMapper;
}

@end
