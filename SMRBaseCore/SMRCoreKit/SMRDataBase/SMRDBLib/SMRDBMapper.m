//
//  SMRDBMapper.m
//  SMRDBDemo
//
//  Created by 丁治文 on 2018/9/22.
//  Copyright © 2018年 sumrise.com. All rights reserved.
//

#import "SMRDBMapper.h"
#import <objc/runtime.h>

@implementation SMRDBMapper

@synthesize table_description = _table_description;
@synthesize all_column_names = _all_column_names;

#pragma mark - Init
+ (SMRDBMapper *)dbMapperWithClass:(Class)cls {
    return [self dbMapperWithClass:cls tableName:nil];
}

+ (SMRDBMapper *)dbMapperWithTableName:(NSString *)tableName {
    return [self dbMapperWithClass:nil tableName:tableName];
}

+ (SMRDBMapper *)dbMapperWithClass:(Class)cls tableName:(NSString *)tableName {
    return [self dbMapperWithClass:cls tableName:tableName primaryKeys:nil];
}

+ (SMRDBMapper *)dbMapperWithClass:(Class)cls tableName:(NSString *)tableName primaryKeys:(NSArray *)primaryKeys {
    if ((cls == NULL) && ((tableName == nil) || (tableName.length == 0))) {
        return nil;
    }
    SMRDBMapper *dbMapper = [[SMRDBMapper alloc] init];
    dbMapper.table_name = tableName?tableName:NSStringFromClass(cls);
    dbMapper.primaryKeys = primaryKeys;
    dbMapper.columns = [self columnsWithClass:cls];
    return dbMapper;
}

#pragma mark - Utls
- (BOOL)isEqualToDBMapper:(SMRDBMapper *)dbMapper {
    // 1.判断对象是否相等
    if (dbMapper == nil) {
        return NO;
    }
    // 2.判断表名
    if (![self isEqualTableNameToDBMapper:dbMapper]) {
        return NO;
    }
    // 3.判断主键
    if (![self isEqualPrimaryKeyToDBMapper:dbMapper]) {
        return NO;
    }
    // 4.判断字段
    if (![self isEqualColumnsToDBMapper:dbMapper]) {
        return NO;
    }
    return YES;
}

- (BOOL)isEqualTableNameToDBMapper:(SMRDBMapper *)dbMapper {
    if (self.table_name) {
        if (![self.table_name isEqualToString:dbMapper.table_name]) {
            return NO;
        }
    } else {
        if (dbMapper.table_name && dbMapper.table_name.length) {
            return NO;
        }
    }
    return YES;
}

- (BOOL)isEqualPrimaryKeyToDBMapper:(SMRDBMapper *)dbMapper {
    if (self.primaryKeys) {
        if (dbMapper.primaryKeys == nil) {
            return NO;
        }
        if (self.primaryKeys.count != dbMapper.primaryKeys.count) {
            return NO;
        }
        for (NSString *key in self.primaryKeys) {
            if (![dbMapper.primaryKeys containsObject:key]) {
                return NO;
            }
        }
        for (NSString *key in dbMapper.primaryKeys) {
            if (![self.primaryKeys containsObject:key]) {
                return NO;
            }
        }
    } else {
        if (dbMapper.primaryKeys && dbMapper.primaryKeys.count) {
            return NO;
        }
    }
    return YES;
}

- (BOOL)isEqualColumnsToDBMapper:(SMRDBMapper *)dbMapper {
    if (self.columns) {
        if (dbMapper.columns == nil) {
            return NO;
        }
        if (self.columns.count != dbMapper.columns.count) {
            return NO;
        }
        for (SMRDBColumn *column in self.columns) {
            if (![dbMapper containsForColumn:column]) {
                return NO;
            }
        }
        for (SMRDBColumn *column in dbMapper.columns) {
            if (![self containsForColumn:column]) {
                return NO;
            }
        }
    } else {
        if (dbMapper.columns && dbMapper.columns.count) {
            return NO;
        }
    }
    return YES;
}

- (BOOL)containsForColumnName:(NSString *)name {
    for (SMRDBColumn *column in self.columns) {
        if ([column.name isEqualToString:name]) {
            return YES;
        }
    }
    return NO;
}

- (BOOL)containsForColumn:(SMRDBColumn *)colm {
    for (SMRDBColumn *column in self.columns) {
        if ([column.column_description isEqualToString:colm.column_description]) {
            return YES;
        }
    }
    return NO;
}

- (void)setNeedsResetTableDescription {
    _table_description = nil;
}

- (void)setNeedsResetTableColumnNames {
    _all_column_names = nil;
}

- (SMRDBColumn *)columnWithColumnName:(NSString *)name {
    for (SMRDBColumn *column in self.columns) {
        if ([column.name isEqualToString:name]) {
            return column;
        }
    }
    return nil;
}

- (void)addDBColumnTypeSymbol:(NSString *)columnName dbType:(NSString *)dbType {
    SMRDBColumn *column = [self columnWithColumnName:columnName];
    if (column) {
        column.dbTypeSymbol = dbType;
    }
}

- (NSDictionary *)columnsOfDictionary {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    for (SMRDBColumn *column in self.columns) {
        [dict setObject:column.dbType forKey:column.name];
    }
    return [NSDictionary dictionaryWithDictionary:dict];
}

+ (NSArray<SMRDBColumn *> *)columnsWithClass:(Class)cls {
    if (cls == nil) {
        return nil;
    }
    NSMutableArray *rtn = [NSMutableArray array];
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList(cls, &outCount);
    for (i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        SMRDBColumn *column = [SMRDBColumn dbColumnWithAttributeString:property];
        if (column) {
            [rtn addObject:column];
        }
    }
    free(properties);
    return rtn;
}

#pragma mark - Override
- (NSString *)description {
    return [self table_description];
}

#pragma mark - SqlUtils
- (NSString *)sqlForDropTable {
    NSString *dropSQL = [NSString stringWithFormat:@"DROP TABLE IF EXISTS '%@'", self.table_name];
    return dropSQL;
}

- (NSString *)sqlForCreateTable {
    NSMutableString *sqlColumns = [NSMutableString string];
    NSMutableString *sqlKeys = [NSMutableString string];
    for (SMRDBColumn *column in self.columns) {
        // primary key
        if ([self.primaryKeys containsObject:column.name]) {
            [sqlColumns appendFormat:@"'%@' %@ NOT NULL, ", column.name, column.dbTypeSymbol];
            [sqlKeys appendFormat:@"'%@', ", column.name];
        } else {
            [sqlColumns appendFormat:@"'%@' %@, ", column.name, column.dbTypeSymbol];
        }
    }
    if (sqlColumns.length > 1) {
        [sqlColumns replaceCharactersInRange:NSMakeRange(sqlColumns.length - 2, 2) withString:@""];
    }
    
    NSString *createSQL = @"";
    if (sqlColumns.length > 0) {
        if (sqlKeys.length > 1) {
            [sqlKeys replaceCharactersInRange:NSMakeRange(sqlKeys.length - 2, 2) withString:@""];
            createSQL = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@' (%@, PRIMARY KEY(%@))", self.table_name, sqlColumns, sqlKeys];
        } else {
            createSQL = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@' (%@)", self.table_name, sqlColumns];
        }
    } else {
        createSQL = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@'", self.table_name];
    }
    return createSQL;
}

// private
- (NSString *)sqlForInsertWithHead:(NSString *)head {
    if (!head || head.length == 0) {
        return nil;
    }
    NSMutableString *properties = [NSMutableString string];
    NSMutableString *values = [NSMutableString string];
    for (SMRDBColumn *column in self.columns) {
        [properties appendFormat:@"'%@',", column.name];
        [values appendFormat:@":%@,", column.name];
    }
    if ((properties.length > 0) && (values.length > 0)) {
        [properties replaceCharactersInRange:NSMakeRange(properties.length - 1, 1) withString:@""];
        [values replaceCharactersInRange:NSMakeRange(values.length - 1, 1) withString:@""];
        NSMutableString *sql = [NSMutableString stringWithFormat:@"%@ INTO '%@' (%@) VALUES(%@)", head, self.table_name, properties, values];
        return [NSString stringWithString:sql];
    } else {
        return nil;
    }
}

- (NSString *)sqlForInsert {
    return [self sqlForInsertWithHead:@"INSERT"];
}

- (NSString *)sqlForInsertOrReplace {
    return [self sqlForInsertWithHead:@"INSERT OR REPLACE"];
}

- (NSString *)sqlForInsertOrIgnore {
    return [self sqlForInsertWithHead:@"INSERT OR IGNORE"];
}

- (NSString *)sqlForDeleteWhere:(NSString *)where {
    NSString *sql = nil;
    if (where && (where.length > 0)) {
        sql = [NSString stringWithFormat:@"DELETE FROM '%@' %@", self.table_name, where];
    } else {
        sql = [NSString stringWithFormat:@"DELETE FROM '%@'", self.table_name];
    }
    return sql;
}

- (NSString *)sqlForUpdateWhere:(NSString *)where {
    NSMutableString *set = [NSMutableString string];
    for (SMRDBColumn *column in self.columns) {
        [set appendFormat:@"'%@'=:%@,", column.name, column.name];
    }
    
    if (set.length > 0) {
        [set replaceCharactersInRange:NSMakeRange(set.length - 1, 1) withString:@""];
        NSString *sql = nil;
        if (where && (where.length > 0)) {
            sql = [NSString stringWithFormat:@"UPDATE '%@' set %@ %@", self.table_name, set, where];
        } else {
            sql = [NSString stringWithFormat:@"UPDATE '%@' set %@", self.table_name, set];
        }
        return sql;
    } else {
        return nil;
    }
}

- (NSString *)sqlForUpdateSetWhere:(NSString *)where {
    NSString *sql = nil;
    if (where && (where.length > 0)) {
        sql = [NSString stringWithFormat:@"UPDATE '%@' %@", self.table_name, where];
    } else {
        sql = [NSString stringWithFormat:@"UPDATE '%@'", self.table_name];
    }
    return sql;
}

- (NSString *)sqlForSelectWhere:(NSString *)where {
    NSString *sql = nil;
    if (where && (where.length > 0)) {
        sql = [NSString stringWithFormat:@"SELECT * FROM '%@' %@", self.table_name, where];
    } else {
        sql = [NSString stringWithFormat:@"SELECT * FROM '%@'", self.table_name];
    }
    return sql;
}

- (NSString *)sqlForSelectWhere:(NSString *)where limit:(NSRange)limit {
    NSString *sql = nil;
    NSString *limitSql = [NSString stringWithFormat:@"LIMIT %zi,%zi", limit.location, limit.length];
    if (where && (where.length > 0)) {
        sql = [NSString stringWithFormat:@"SELECT * FROM '%@' %@ %@", self.table_name, where, limitSql];
    } else {
        sql = [NSString stringWithFormat:@"SELECT * FROM '%@' %@", self.table_name, limitSql];
    }
    return sql;
}

#pragma mark - Mappers/Getters
- (NSString *)table_description {
    if (_table_description == nil) {
        NSMutableString *des = [NSMutableString string];
        // table_name
        [des appendFormat:@"table_name:%@", self.table_name];
        // primaryKeys
        if (self.primaryKeys && self.primaryKeys.count) {
            NSString *keysFormat = @"primaryKeys:(%@)";
            NSMutableString *keys = [NSMutableString string];
            for (NSString *key in self.primaryKeys) {
                [keys appendFormat:@"%@,", key];
            }
            [keys replaceCharactersInRange:NSMakeRange(keys.length - 1, 1) withString:@""];
            [des appendFormat:keysFormat, keys];
        }
        // columns
        if (self.columns && self.columns.count) {
            NSString *columnsFormat = @"columns:<\n%@\n>";
            NSMutableString *colms = [NSMutableString string];
            for (SMRDBColumn *column in self.columns) {
                [colms appendFormat:@"\t%@,", column.column_description];
            }
            [colms replaceCharactersInRange:NSMakeRange(colms.length - 1, 1) withString:@""];
            [des appendFormat:columnsFormat, colms];
        }
        _table_description = [NSString stringWithString:des];
    }
    return _table_description;
}

- (NSArray *)all_column_names {
    if (_all_column_names == nil) {
        NSMutableArray *array = [NSMutableArray array];
        for (SMRDBColumn *column in self.columns) {
            if (column.name) {
                [array addObject:column.name];
            }
        }
        _all_column_names = [NSArray arrayWithArray:array];
    }
    return _all_column_names;
}

- (void)setTable_name:(NSString *)table_name {
    _table_name = table_name;
    [self setNeedsResetTableDescription];
}

- (void)setPrimaryKeys:(NSArray *)primaryKeys {
    _primaryKeys = primaryKeys;
    [self setNeedsResetTableDescription];
}

- (void)setColumns:(NSArray<SMRDBColumn *> *)columns {
    _columns = columns;
    [self setNeedsResetTableDescription];
    [self setNeedsResetTableColumnNames];
}

@end
