//
//  SMRDBMapper.h
//  SMRDBDemo
//
//  Created by 丁治文 on 2018/9/22.
//  Copyright © 2018年 sumrise.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SMRDBColumn.h"

@interface SMRDBMapper : NSObject

@property (nonatomic, strong, readonly) NSString *table_description;
@property (nonatomic, strong, readonly) NSArray *all_column_names;
@property (nonatomic, copy) NSString *table_name;
@property (nonatomic, strong) NSArray *primaryKeys;
@property (nonatomic, strong) NSArray<SMRDBColumn *> *columns;

#pragma mark - Init
+ (SMRDBMapper *)dbMapperWithClass:(Class)cls;
+ (SMRDBMapper *)dbMapperWithTableName:(NSString *)tableName;
+ (SMRDBMapper *)dbMapperWithClass:(Class)cls tableName:(NSString *)tableName;
+ (SMRDBMapper *)dbMapperWithClass:(Class)cls tableName:(NSString *)tableName primaryKeys:(NSArray *)primaryKeys;

#pragma mark - Utls
- (BOOL)isEqualToDBMapper:(SMRDBMapper *)dbMapper;
- (BOOL)isEqualTableNameToDBMapper:(SMRDBMapper *)dbMapper;
- (BOOL)isEqualPrimaryKeyToDBMapper:(SMRDBMapper *)dbMapper;
- (BOOL)isEqualColumnsToDBMapper:(SMRDBMapper *)dbMapper;
- (BOOL)containsForColumnName:(NSString *)name;
- (BOOL)containsForColumn:(SMRDBColumn *)colm;
- (void)setNeedsResetTableDescription;
- (void)setNeedsResetTableColumnNames;
- (SMRDBColumn *)columnWithColumnName:(NSString *)name;
- (void)addDBColumnTypeSymbol:(NSString *)columnName dbType:(NSString *)dbType;
- (NSDictionary *)columnsOfDictionary;
+ (NSArray<SMRDBColumn *> *)columnsWithClass:(Class)cls;

#pragma mark - Override
- (NSString *)description;

#pragma mark - SqlUtils
- (NSString *)sqlForDropTable;
- (NSString *)sqlForCreateTable;
- (NSString *)sqlForInsert;
- (NSString *)sqlForInsertOrReplace;
- (NSString *)sqlForInsertOrIgnore;
- (NSString *)sqlForDeleteWhere:(NSString *)where;
- (NSString *)sqlForUpdateWhere:(NSString *)where;
- (NSString *)sqlForUpdateSetWhere:(NSString *)where;
- (NSString *)sqlForSelectWhere:(NSString *)where;
- (NSString *)sqlForSelectWhere:(NSString *)where limit:(NSRange)limit;

#pragma mark - Mappers/Getters
- (NSString *)table_description;
- (NSArray *)all_column_names;
- (void)setTable_name:(NSString *)table_name;
- (void)setPrimaryKeys:(NSArray *)primaryKeys;
- (void)setColumns:(NSArray<SMRDBColumn *> *)columns;

@end
