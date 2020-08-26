//
//  SMRDBDeleteOption.m
//  SMRDataBaseDemo
//
//  Created by 丁治文 on 2018/12/18.
//  Copyright © 2018 sumrise. All rights reserved.
//

#import "SMRDBDeleteOption.h"

@implementation SMRDBDeleteOption

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
    SMRDBMapper *dbMapper = self.dbMapper;
    if (!dbMapper) {
        return nil;
    }
    NSString *sql = [dbMapper sqlForDeleteWhere:self.where];
    return sql;
}

- (int)excuteInTransaction:(id<SMRTransactionItemDelegate>)item rollback:(BOOL *)rollback {
    NSString *sql = self.sql;
    base_core_datas_log(@"excute delete:\n%@", sql);
    
    if (!sql.length) {
        return 0;
    }
    
    BOOL result = NO;
    if (self.paramsArray) {
        result = [self.dbManager excuteSQL:sql withParamsInArray:self.paramsArray inTransaction:item rollback:rollback];
    } else {
        result = [self.dbManager excuteSQL:sql withParamsInDictionary:self.paramsDict inTransaction:item rollback:rollback];
    }
    return result;
}

- (id)queryInTransaction:(id<SMRTransactionItemDelegate>)item rollback:(BOOL *)rollback {
    return @([self excuteInTransaction:item rollback:rollback]);
}

@end
