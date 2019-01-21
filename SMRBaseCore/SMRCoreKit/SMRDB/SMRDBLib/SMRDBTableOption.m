//
//  SMRDBTableOption.m
//  SMRDBDemo
//
//  Created by 丁治文 on 2018/9/23.
//  Copyright © 2018年 sumrise.com. All rights reserved.
//

#import "SMRDBTableOption.h"
#import "SMRDBAdapter.h"
#import "SMRDBMapper.h"

@implementation SMRDBTableOption

+ (BOOL)createAndAlterTableWithDbMapper:(SMRDBMapper *)dbMapper inTransaction:(id<SMRTransactionItemDelegate>)item rollback:(BOOL *)rollback {
    return [self createAndAlterTableWithName:dbMapper.table_name columns:dbMapper.columnsOfDictionary andPrimaryKeys:dbMapper.primaryKeys inTransaction:item rollback:rollback];
}

+ (BOOL)createAndAlterTableWithName:(NSString *)tableName
                            columns:(NSDictionary *)columns
                     andPrimaryKeys:(NSArray *)primaryKeys
                      inTransaction:(id<SMRTransactionItemDelegate>)item
                           rollback:(BOOL *)rollback {
    if ([self ifTableExistWithName:tableName inTransaction:item rollback:rollback] == NO) {
        // Create new table according to model
        return [self createTableWithName:tableName columns:columns andPrimaryKeys:primaryKeys inTransaction:item rollback:rollback];
    } else {
        // Delete table and Re-create new table when primary key changed
        if ([self keyColumnsChangedFromExistedTableByName:tableName andNewKeys:primaryKeys inTransaction:item rollback:rollback] == YES) {
            [self dropTableWithName:tableName inTransaction:item rollback:rollback];
            return [self createTableWithName:tableName columns:columns andPrimaryKeys:primaryKeys inTransaction:item rollback:rollback];
        }
        
        // Modify fields according to changed properties of model
        return [self alterTableWithName:tableName columns:columns andPrimaryKeys:primaryKeys inTransaction:item rollback:rollback];
    }
    return NO;
}

+ (BOOL)createTableWithName:(NSString *)tableName
                    columns:(NSDictionary *)columns
             andPrimaryKeys:(NSArray *)primaryKeys
              inTransaction:(id<SMRTransactionItemDelegate>)item
                   rollback:(BOOL *)rollback {
    NSMutableString *sqlColumns = [NSMutableString string];
    NSMutableString *sqlKeys = [NSMutableString string];
    for (NSString *key in columns.allKeys) {
        NSString *type = columns[key];
        // primary key
        if ([primaryKeys containsObject:key]) {
            [sqlColumns appendFormat:@"'%@' %@ NOT NULL, ", key, type];
            [sqlKeys appendFormat:@"'%@', ", key];
        } else {
            [sqlColumns appendFormat:@"'%@' %@, ", key, type];
        }
    }
    if (sqlColumns.length > 0) {
        [sqlColumns replaceCharactersInRange:NSMakeRange(sqlColumns.length - 2, 2) withString:@""];
    }
    
    NSString *dropSQL = [NSString stringWithFormat:@"DROP TABLE IF EXISTS '%@'", tableName];
    NSString *createSQL = @"";
    if (sqlKeys.length > 0) {
        [sqlKeys replaceCharactersInRange:NSMakeRange(sqlKeys.length - 2, 2) withString:@""];
        createSQL = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@' (%@, PRIMARY KEY(%@))", tableName, sqlColumns, sqlKeys];
    } else {
        createSQL = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@' (%@)", tableName, sqlColumns];
    }
    
    BOOL isSuccess = [[[SMRDBAdapter shareInstance].dbManager class] excuteSQLs:@[dropSQL, createSQL] inTransaction:item rollback:rollback];
    return isSuccess;
}

+ (BOOL)alterTableWithName:(NSString *)tableName
                   columns:(NSDictionary *)columns
            andPrimaryKeys:(NSArray *)primaryKeys
             inTransaction:(id<SMRTransactionItemDelegate>)item
                  rollback:(BOOL *)rollback {
    if (tableName == nil || columns == nil) {
        return NO;
    }
    
    NSDictionary *existColumns = [self columnsFromExistedTableByName:tableName inTransaction:item rollback:rollback];
    if (existColumns == nil || existColumns.count == 0) {
        return NO;
    }
    
    BOOL result = NO;
    BOOL shouldRecteateTable = NO;
    NSString *dataKeepColumnName = @"";
    if (existColumns.count != columns.count) {
        shouldRecteateTable = YES;
        
        // same column filter
        for (NSString *key in columns.allKeys) {
            NSArray *existFields = existColumns.allKeys;
            if ([existFields containsObject:key] == YES) {
                // check feild type
                NSString *existFieldType = [existColumns objectForKey:key];
                NSString *needFeildType = [columns objectForKey:key];
                if ([existFieldType.uppercaseString isEqualToString:needFeildType.uppercaseString] == YES) {
                    dataKeepColumnName = [dataKeepColumnName stringByAppendingString:[NSString stringWithFormat:@"%@,",key]];
                }
            }
        }
    } else {
        for (NSString *key in columns.allKeys) {
            NSArray *existFields = existColumns.allKeys;
            if ([existFields containsObject:key] == YES) {
                // check feild type
                NSString *existFieldType = [existColumns objectForKey:key];
                NSString *needFeildType = [columns objectForKey:key];
                if ([existFieldType.uppercaseString isEqualToString:needFeildType.uppercaseString] == NO) {
                    shouldRecteateTable = YES;
                } else {
                    dataKeepColumnName = [dataKeepColumnName stringByAppendingString:[NSString stringWithFormat:@"%@,",key]];
                }
            } else {
                // add field
                shouldRecteateTable = YES;
            }
        }
    }
    
    if (shouldRecteateTable == YES) {
        if (dataKeepColumnName.length > 1) {
            dataKeepColumnName = [dataKeepColumnName substringToIndex:dataKeepColumnName.length - 1];
        }
        result = [self recreateTableWithName:tableName
                                     columns:columns
                         dataKeepColumnNames:dataKeepColumnName
                                 primaryKeys:primaryKeys
                               inTransaction:item
                                    rollback:rollback];
    } else {
        return YES;
    }
    return result;
}

+ (BOOL)recreateTableWithName:(NSString *)tableName
                      columns:(NSDictionary *)columns
          dataKeepColumnNames:(NSString *)dataKeepColumnNames
                  primaryKeys:(NSArray *)primaryKeys
                inTransaction:(id<SMRTransactionItemDelegate>)item
                     rollback:(BOOL *)rollback {
    BOOL result = NO;
    NSString *newTableName = [NSString stringWithFormat:@"__wc_just_auto_recreate_%@_", tableName];
    if ([self createTableWithName:newTableName columns:columns andPrimaryKeys:primaryKeys inTransaction:item rollback:rollback] == YES) {
        if (dataKeepColumnNames != nil && dataKeepColumnNames.length != 0) {
            NSString *insertSQL = [NSString stringWithFormat:@"INSERT INTO '%@' (%@) SELECT %@ FROM '%@'", newTableName, dataKeepColumnNames, dataKeepColumnNames, tableName];
            NSString *dropSQL = [NSString stringWithFormat:@"DROP TABLE '%@'", tableName];
            NSString *renameSQL = [NSString stringWithFormat:@"ALTER TABLE '%@' RENAME TO '%@'",newTableName,tableName];
            result = [[[SMRDBAdapter shareInstance].dbManager class] excuteSQLs:@[insertSQL, dropSQL, renameSQL] inTransaction:item rollback:rollback];
        }
    }
    return result;
}

+ (NSDictionary *)columnsFromExistedTableByName:(NSString *)tableName inTransaction:(id<SMRTransactionItemDelegate>)item rollback:(BOOL *)rollback {
    NSMutableDictionary *existColumns = [NSMutableDictionary dictionary];
    NSString *sql = [NSString stringWithFormat:@"PRAGMA table_info([%@])", tableName];
    NSArray *resultArray = [[[SMRDBAdapter shareInstance].dbManager class] querySQL:sql withParamsInDictionary:nil inTransaction:item rollback:rollback];
    if (resultArray != nil && resultArray.count > 0) {
        for (NSDictionary *resultItemDict in resultArray) {
            NSString *fieldName = [resultItemDict objectForKey:@"name"];
            NSString *fieldType = [resultItemDict objectForKey:@"type"];
            [existColumns setObject:fieldType forKey:fieldName];
        }
        return existColumns;
    }
    return nil;
}

+ (NSArray *)keyColumnsFromExistedTableByName:(NSString *)tableName inTransaction:(id<SMRTransactionItemDelegate>)item rollback:(BOOL *)rollback {
    NSMutableArray *keyColumns = [NSMutableArray array];
    NSString *sql = [NSString stringWithFormat:@"PRAGMA table_info([%@])", tableName];
    NSArray *resultArray = [[[SMRDBAdapter shareInstance].dbManager class] querySQL:sql withParamsInDictionary:nil inTransaction:item rollback:rollback];
    if (resultArray != nil && resultArray.count > 0) {
        for (NSDictionary *resultItemDict in resultArray) {
            NSString *fieldName = [resultItemDict objectForKey:@"name"];
            BOOL fieldPK = [[resultItemDict objectForKey:@"pk"] boolValue];
            if (fieldPK == YES) {
                [keyColumns addObject:fieldName];
            }
        }
        return keyColumns;
    }
    return nil;
}

+ (BOOL)keyColumnsChangedFromExistedTableByName:(NSString *)tableName andNewKeys:(NSArray *)keys inTransaction:(id<SMRTransactionItemDelegate>)item rollback:(BOOL *)rollback {
    NSArray *keyColumns = [self keyColumnsFromExistedTableByName:tableName inTransaction:item rollback:rollback];
    if (keyColumns == nil && keys == nil) {
        return NO;
    }
    
    if (keyColumns.count == 0 && keys.count == 0) {
        return NO;
    }
    
    if (keyColumns.count != keys.count) {
        return YES;
    }
    
    if (keyColumns.count == keys.count) {
        for (NSString *columnName in keyColumns) {
            if ([keys containsObject:columnName] == NO) {
                return YES;
            }
        }
        return NO;
    }
    return YES;
}

#pragma mark - Table Utils

+ (BOOL)ifTableExistWithName:(NSString *)tableName inTransaction:(id<SMRTransactionItemDelegate>)item rollback:(BOOL *)rollback {
    NSString *sql = [NSString stringWithFormat:@"SELECT count(*) AS 'count' FROM sqlite_master WHERE type ='table' and name = '%@'",tableName];
    NSArray *resultArray = [[[SMRDBAdapter shareInstance].dbManager class] querySQL:sql withParamsInDictionary:nil inTransaction:item rollback:rollback];
    BOOL result = NO;
    if (resultArray != nil && resultArray.count > 0) {
        result = [[resultArray.firstObject objectForKey:@"count"] boolValue];
    }
    return result;
}

+ (BOOL)dropTableWithName:(NSString *)tableName inTransaction:(id<SMRTransactionItemDelegate>)item rollback:(BOOL *)rollback {
    if (tableName == nil || tableName.length <= 0) {
        return NO;
    }
    
    NSString *sql = [NSString stringWithFormat:@"DROP TABLE %@", tableName];
    BOOL rtn = [[[SMRDBAdapter shareInstance].dbManager class] excuteSQLs:@[sql] inTransaction:item rollback:rollback];
    return rtn;
}

+ (NSArray *)selectExistedTablesNamesInTransaction:(id<SMRTransactionItemDelegate>)item rollback:(BOOL *)rollback {
    NSString *sql = [NSString stringWithFormat:@"SELECT name FROM sqlite_master WHERE type ='table'"];
    return [[[SMRDBAdapter shareInstance].dbManager class] querySQL:sql withParamsInDictionary:nil inTransaction:item rollback:rollback];
}

+ (BOOL)deleteAllTablesDataInTransaction:(id<SMRTransactionItemDelegate>)item rollback:(BOOL *)rollback {
    BOOL result = NO;
    NSArray *tableNames = [self selectExistedTablesNamesInTransaction:item rollback:rollback];
    NSMutableArray *sqlArray = [NSMutableArray array];
    for (NSDictionary *tableNameDict in tableNames) {
        NSString *tableName = [tableNameDict objectForKey:@"name"];
        NSString *sql = [NSString stringWithFormat:@"DELETE FROM '%@'", tableName];
        [sqlArray addObject:sql];
    }
    result = [[[SMRDBAdapter shareInstance].dbManager class] excuteSQLs:[sqlArray copy] inTransaction:item rollback:rollback];
    return result;
}

@end
