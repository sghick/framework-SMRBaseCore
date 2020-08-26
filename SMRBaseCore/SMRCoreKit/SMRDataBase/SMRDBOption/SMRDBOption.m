//
//  SMRDBOption.m
//  SMRDataBaseDemo
//
//  Created by 丁治文 on 2018/12/18.
//  Copyright © 2018 sumrise. All rights reserved.
//

#import "SMRDBOption.h"
#import "SMRLog.h"

@interface SMRDBOption ()

@end

@implementation SMRDBOption
@synthesize dbMapper = _dbMapper;

- (SMRDBAdapter *)dbAdapter {
    return [SMRDBAdapter shareInstance];
}

- (id<SMRDBManagerProtocol>)dbManager {
    return self.dbAdapter.dbManager;
}

- (id<SMRDBParserDelegate>)dbParser {
    return self.dbAdapter.dbParser;
}

- (SMRDBMapper *)dbMapper {
    _dbMapper = [SMRDBMapper dbMapperWithClass:self.modelClass
                                     tableName:self.tableName
                                   primaryKeys:self.primaryKeys];
    return _dbMapper;
}

- (instancetype)initWithTableName:(NSString *)tableName {
    return [self initWithTableName:tableName
                        modelClass:NULL
                       primaryKeys:nil];
}
- (instancetype)initWithTableName:(NSString *)tableName
                       modelClass:(Class)modelClass
                      primaryKeys:(NSArray<NSString *> *)primaryKeys {
    self = [super init];
    if (self) {
        _tableName = tableName;
        _modelClass = modelClass;
        _primaryKeys = primaryKeys;
    }
    return self;
}

- (NSString *)sql {
    return nil;
}

- (int)excuteInTransaction:(id<SMRTransactionItemDelegate>)item rollback:(BOOL *)rollback {
    return 0;
}

- (id)queryInTransaction:(id<SMRTransactionItemDelegate>)item rollback:(BOOL *)rollback {
    return nil;
}

#pragma mark - Utils

- (int)excute {
    __block int count = 0;
    [self.dbManager doOptionInTransaction:^(id<SMRTransactionItemDelegate> item, BOOL *rollback) {
        BOOL alter = [self alterTableIfNeeded:item rollback:rollback];
        if (alter) {
            count += [self excuteInTransaction:item rollback:rollback];
        } else {
            base_core_warning_log(@"SMRDBOption excute:数据库更新失败,%@", self.tableName);
        }
    }];
    return count;
}

- (id)query {
    __block id result = nil;
    [self.dbManager doOptionInTransaction:^(id<SMRTransactionItemDelegate> item, BOOL *rollback) {
        BOOL alter = [self alterTableIfNeeded:item rollback:rollback];
        if (alter) {
            result = [self queryInTransaction:item rollback:rollback];
        } else {
            if (self.dbAdapter.logForSql) {
                base_core_warning_log(@"SMRDBOption query:数据库更新失败,%@", self.tableName);
            }
        }
    }];
    return result;
}

- (void)setAlterTableWithModelClass:(Class)modelClass
                          tableName:(NSString *)tableName
                        primaryKeys:(NSArray *)primaryKeys {
    NSString *classString = NSStringFromClass(modelClass);
    SMRDBMetaInfo *metaInfo =
    [SMRDBMetaInfo metaInfoWithTableName:tableName ?: classString
                             classString:classString
                             primaryKeys:primaryKeys];
    [SMRDBAlterHelper setMetaInfoIfNeedsAlter:metaInfo forKey:tableName];
}

- (id)parserResultsToModel:(NSArray *)results withModelClass:(Class)modelClass {
    SMRDBMapper *dbMapper = [SMRDBMapper dbMapperWithClass:modelClass];
    if (results && modelClass) {
        NSMutableArray *array = [NSMutableArray array];
        for (NSDictionary *dict in results) {
            NSObject *obj = [self.dbParser modelFromDict:dict class:modelClass withDBMapper:dbMapper];
            if (obj) {
                [array addObject:obj];
            }
        }
        return [NSArray arrayWithArray:array];
    }
    return nil;
}

@end

@implementation SMRDBOption (Helper)

#pragma mark - Base

- (BOOL)alterTableIfNeeded:(id<SMRTransactionItemDelegate>)item
                  rollback:(BOOL *)rollback {
    SMRDBMetaInfo *metaInfo =
    [SMRDBAlterHelper metaInfoNeedsAlterWithKey:self.tableName];
    // 不需要检查
    if (!metaInfo || !metaInfo.needsAlter) {
        return YES;
    }
    Class cls = NSClassFromString(metaInfo.class_string);
    SMRDBMapper *dbMapper =
    [SMRDBMapper dbMapperWithClass:cls
                         tableName:metaInfo.table_name
                       primaryKeys:metaInfo.primary_keys];
    // 数据不完整, 无法完成表更新
    if (!dbMapper) {
        NSAssert(NO, @"数据不完整, 无法完成表更新:%@", self.tableName);
        return YES;
    }
    BOOL success =
    [self _createAndAlterTableWithName:dbMapper.table_name
                               columns:dbMapper.columnsOfDictionary
                           primaryKeys:dbMapper.primaryKeys
                         inTransaction:item
                              rollback:rollback];
    if (success) {
        [SMRDBAlterHelper markMetaInfoAlteredWithKey:dbMapper.table_name];
    }
    return success;
}

- (BOOL)ifTableExistWithName:(NSString *)tableName
               inTransaction:(id<SMRTransactionItemDelegate>)item
                    rollback:(BOOL *)rollback {
    NSString *sql = [NSString stringWithFormat:@"SELECT count(*) AS 'count' FROM sqlite_master WHERE type='table' and name='%@'", tableName];
    NSArray *resultArray = [self.dbManager querySQL:sql withParamsInDictionary:nil inTransaction:item rollback:rollback];
    BOOL result = NO;
    if (resultArray != nil && resultArray.count > 0) {
        result = [[resultArray.firstObject objectForKey:@"count"] boolValue];
    }
    return result;
}

- (BOOL)dropTableWithName:(NSString *)tableName
            inTransaction:(id<SMRTransactionItemDelegate>)item
                 rollback:(BOOL *)rollback {
    if (tableName == nil || tableName.length <= 0) {
        return NO;
    }
    
    NSString *sql = [NSString stringWithFormat:@"DROP TABLE %@", tableName];
    BOOL rtn = [self.dbManager excuteSQLs:@[sql] inTransaction:item rollback:rollback];
    return rtn;
}

- (NSArray *)selectExistedTableNamesInTransaction:(id<SMRTransactionItemDelegate>)item
                                         rollback:(BOOL *)rollback {
    NSString *sql = [NSString stringWithFormat:@"SELECT name FROM sqlite_master WHERE type ='table'"];
    return [self.dbManager querySQL:sql withParamsInDictionary:nil inTransaction:item rollback:rollback];
}

- (BOOL)deleteAllTableDatasInTransaction:(id<SMRTransactionItemDelegate>)item
                                rollback:(BOOL *)rollback {
    BOOL result = NO;
    NSArray *tableNames = [self selectExistedTableNamesInTransaction:item rollback:rollback];
    NSMutableArray *sqlArray = [NSMutableArray array];
    for (NSDictionary *tableNameDict in tableNames) {
        NSString *tableName = [tableNameDict objectForKey:@"name"];
        NSString *sql = [NSString stringWithFormat:@"DELETE FROM '%@'", tableName];
        [sqlArray addObject:sql];
    }
    result = [self.dbManager excuteSQLs:[sqlArray copy] inTransaction:item rollback:rollback];
    return result;
}

#pragma mark - Base Privaties

- (BOOL)_createAndAlterTableWithName:(NSString *)tableName
                             columns:(NSDictionary *)columns
                         primaryKeys:(NSArray *)primaryKeys
                       inTransaction:(id<SMRTransactionItemDelegate>)item
                            rollback:(BOOL *)rollback {
    if (![self ifTableExistWithName:tableName
                     inTransaction:item
                          rollback:rollback]) {
        // 创建一张数据库表
        return [self _createTableWithName:tableName
                                  columns:columns
                              primaryKeys:primaryKeys
                            inTransaction:item
                                 rollback:rollback];
    } else {
        // 如果主键发生变化,则删除原表和数据,再重新创建新的表
        if ([self _primaryKeysChangedFromTableName:tableName
                                           newKeys:primaryKeys
                                     inTransaction:item
                                          rollback:rollback]) {
            [self dropTableWithName:tableName inTransaction:item rollback:rollback];
            return [self _createTableWithName:tableName
                                      columns:columns
                                  primaryKeys:primaryKeys
                                inTransaction:item
                                     rollback:rollback];
        }
        // 更新表字段
        return [self _alterTableWithName:tableName
                                 columns:columns
                             primaryKeys:primaryKeys
                           inTransaction:item
                                rollback:rollback];
    }
    return NO;
}

- (BOOL)_createTableWithName:(NSString *)tableName
                     columns:(NSDictionary *)columns
                 primaryKeys:(NSArray *)primaryKeys
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
    BOOL isSuccess = [self.dbManager excuteSQLs:@[dropSQL, createSQL] inTransaction:item rollback:rollback];
    base_core_log(@"自动更新表(%@):%@", isSuccess ? @"成功" : @"失败", createSQL);
    return isSuccess;
}

- (BOOL)_primaryKeysChangedFromTableName:(NSString *)tableName
                                 newKeys:(NSArray *)keys
                           inTransaction:(id<SMRTransactionItemDelegate>)item
                                rollback:(BOOL *)rollback {
    NSArray *primaryKeys = [self _primaryKeysFromTableName:tableName inTransaction:item rollback:rollback];
    if (primaryKeys == nil && keys == nil) {
        return NO;
    }
    
    if (primaryKeys.count == 0 && keys.count == 0) {
        return NO;
    }
    
    if (primaryKeys.count != keys.count) {
        return YES;
    }
    
    if (primaryKeys.count == keys.count) {
        for (NSString *columnName in primaryKeys) {
            if ([keys containsObject:columnName] == NO) {
                return YES;
            }
        }
        return NO;
    }
    return YES;
}

- (BOOL)_alterTableWithName:(NSString *)tableName
                    columns:(NSDictionary *)columns
                primaryKeys:(NSArray *)primaryKeys
              inTransaction:(id<SMRTransactionItemDelegate>)item
                   rollback:(BOOL *)rollback {
    if (tableName == nil || columns == nil) {
        return NO;
    }
    
    NSDictionary *existColumns = [self _columnsFromTableName:tableName inTransaction:item rollback:rollback];
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
        result = [self _recreateTableWithName:tableName
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

- (BOOL)_recreateTableWithName:(NSString *)tableName
                       columns:(NSDictionary *)columns
           dataKeepColumnNames:(NSString *)dataKeepColumnNames
                   primaryKeys:(NSArray *)primaryKeys
                 inTransaction:(id<SMRTransactionItemDelegate>)item
                      rollback:(BOOL *)rollback {
    BOOL result = NO;
    NSString *newTableName = [NSString stringWithFormat:@"__smr_just_auto_recreate_%@_", tableName];
    if ([self _createTableWithName:newTableName columns:columns primaryKeys:primaryKeys inTransaction:item rollback:rollback]) {
        if (dataKeepColumnNames != nil && dataKeepColumnNames.length != 0) {
            NSString *insertSQL = [NSString stringWithFormat:@"INSERT INTO '%@' (%@) SELECT %@ FROM '%@'", newTableName, dataKeepColumnNames, dataKeepColumnNames, tableName];
            NSString *dropSQL = [NSString stringWithFormat:@"DROP TABLE '%@'", tableName];
            NSString *renameSQL = [NSString stringWithFormat:@"ALTER TABLE '%@' RENAME TO '%@'",newTableName,tableName];
            result = [self.dbManager excuteSQLs:@[insertSQL, dropSQL, renameSQL] inTransaction:item rollback:rollback];
        }
    }
    return result;
}

- (NSArray *)_primaryKeysFromTableName:(NSString *)tableName
                         inTransaction:(id<SMRTransactionItemDelegate>)item
                              rollback:(BOOL *)rollback {
    NSMutableArray *keyColumns = [NSMutableArray array];
    NSString *sql = [NSString stringWithFormat:@"PRAGMA table_info([%@])", tableName];
    NSArray *resultArray = [self.dbManager querySQL:sql withParamsInDictionary:nil inTransaction:item rollback:rollback];
    if (resultArray.count > 0) {
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

- (NSDictionary *)_columnsFromTableName:(NSString *)tableName
                          inTransaction:(id<SMRTransactionItemDelegate>)item
                               rollback:(BOOL *)rollback {
    NSMutableDictionary *existColumns = [NSMutableDictionary dictionary];
    NSString *sql = [NSString stringWithFormat:@"PRAGMA table_info([%@])", tableName];
    NSArray *resultArray = [self.dbManager querySQL:sql withParamsInDictionary:nil inTransaction:item rollback:rollback];
    if (resultArray.count > 0) {
        for (NSDictionary *resultItemDict in resultArray) {
            NSString *fieldName = [resultItemDict objectForKey:@"name"];
            NSString *fieldType = [resultItemDict objectForKey:@"type"];
            [existColumns setObject:fieldType forKey:fieldName];
        }
        return existColumns;
    }
    return nil;
}

#pragma mark - Utils

- (BOOL)ifTableExistWithName:(NSString *)tableName {
    id<SMRDBManagerProtocol> manager = self.dbManager;
    __block BOOL result = NO;
    [manager doOptionInTransaction:^(id<SMRTransactionItemDelegate> item, BOOL *rollback) {
        result = [self ifTableExistWithName:tableName
                              inTransaction:item
                                   rollback:rollback];
    }];
    return result;
}

- (BOOL)dropTableWithName:(NSString *)tableName {
    id<SMRDBManagerProtocol> manager = self.dbManager;
    __block BOOL result = NO;
    [manager doOptionInTransaction:^(id<SMRTransactionItemDelegate> item, BOOL *rollback) {
        result = [self dropTableWithName:tableName
                           inTransaction:item
                                rollback:rollback];
    }];
    return result;
}

- (NSArray *)selectExistedTablesNames {
    id<SMRDBManagerProtocol> manager = self.dbManager;
    __block NSArray *result = nil;
    [manager doOptionInTransaction:^(id<SMRTransactionItemDelegate> item, BOOL *rollback) {
        result = [self selectExistedTableNamesInTransaction:item
                                                   rollback:rollback];
    }];
    return result;
}

- (BOOL)deleteAllTablesData {
    id<SMRDBManagerProtocol> manager = self.dbManager;
    __block BOOL result = NO;
    [manager doOptionInTransaction:^(id<SMRTransactionItemDelegate> item, BOOL *rollback) {
        result = [self deleteAllTableDatasInTransaction:item
                                               rollback:rollback];
    }];
    return result;
}

@end
