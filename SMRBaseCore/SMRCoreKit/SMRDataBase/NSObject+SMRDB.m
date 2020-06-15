//
//  NSObject+SMRDB.m
//  SMRDBDemo
//
//  Created by 丁治文 on 2018/9/23.
//  Copyright © 2018年 sumrise.com. All rights reserved.
//

#import "NSObject+SMRDB.h"
#import "SMRDBMapper.h"
#import "SMRDBGroupOption.h"
#import "SMRDBSqlOption.h"
#import "SMRDBInsertOption.h"
#import "SMRDBDeleteOption.h"
#import "SMRDBUpdateOption.h"
#import "SMRDBSelectOption.h"

@implementation NSObject (SMRDB)

#pragma mark - DefaultTableName
+ (NSString *)tableName {
    return NSStringFromClass([self class]);
}

+ (BOOL)insertOrReplace:(NSArray *)objs {
    return [self insertOrReplace:objs intoTable:[self tableName]];
}
+ (BOOL)insertOrReplace:(NSArray *)objs generalParam:(NSDictionary *)generalParam {
    return [self insertOrReplace:objs generalParam:generalParam intoTable:[self tableName]];
}
+ (BOOL)insertOrReplace:(NSArray *)objs primaryKeys:(NSArray *)primaryKeys {
    return [self insertOrReplace:objs primaryKeys:primaryKeys intoTable:[self tableName]];
}
+ (BOOL)insertOrReplace:(NSArray *)objs generalParam:(NSDictionary *)generalParam primaryKeys:(NSArray *)primaryKeys {
    return [self insertOrReplace:objs generalParam:generalParam primaryKeys:primaryKeys intoTable:[self tableName]];
}

+ (NSArray *)selectAll {
    return [self selectAllFromTable:[self tableName]];
}
+ (NSArray *)selectWhere:(NSString *)where {
    return [self selectWhere:where fromTable:[self tableName]];
}
+ (NSArray *)selectWhere:(NSString *)where paramsArray:(NSArray *)params {
    return [self selectWhere:where paramsArray:params fromTable:[self tableName]];
}
+ (NSArray *)selectWhere:(NSString *)where limit:(NSRange)limit {
    return [self selectWhere:where limit:limit fromTable:[self tableName]];
}
+ (NSArray *)selectWhere:(NSString *)where limit:(NSRange)limit paramsArray:(NSArray *)params {
    return [self selectWhere:where limit:limit paramsArray:params fromTable:[self tableName]];
}
+ (__kindof NSObject *)selectFirstObjectWhere:(NSString *)where {
    return [self selectFirstObjectWhere:where fromTable:[self tableName]];
}
+ (__kindof NSObject *)selectFirstObjectWhere:(NSString *)where paramsArray:(NSArray *)params {
    return [self selectFirstObjectWhere:where paramsArray:params fromTable:[self tableName]];
}
+ (NSArray *)selectSql:(NSString *)sql paramsArray:(NSArray *)params {
    return [self selectSql:sql paramsArray:params fromTable:[self tableName]];
}
+ (id)selectConcreteSql:(NSString *)sql paramsArray:(NSArray *)params concreteKey:(NSString *)concreteKey {
    return [self selectConcreteSql:sql paramsArray:params concreteKey:concreteKey fromTable:[self tableName]];
}

+ (BOOL)update:(NSObject *)obj where:(NSString *)where {
    return [self update:obj where:where fromTable:[self tableName]];
}

+ (BOOL)updateSetWhere:(NSString *)where params:(NSArray *)params {
    return [self updateSetWhere:where params:params fromTable:[self tableName]];
}

+ (BOOL)deleteAll {
    return [self deleteAllFromTable:[self tableName]];
}
+ (BOOL)deleteWhere:(NSString *)where {
    return [self deleteWhere:where fromTable:[self tableName]];
}
+ (BOOL)deleteWhere:(NSString *)where paramsArray:(NSArray *)params {
    return [self deleteWhere:where paramsArray:params fromTable:[self tableName]];
}

#pragma mark - OtherTableName

+ (BOOL)insertOrReplace:(NSArray *)objs intoTable:(NSString *)tableName {
    return [self insertOrReplace:objs generalParam:nil primaryKeys:nil intoTable:tableName];
}
+ (BOOL)insertOrReplace:(NSArray *)objs generalParam:(NSDictionary *)generalParam intoTable:(NSString *)tableName {
    return [self insertOrReplace:objs generalParam:generalParam primaryKeys:nil intoTable:tableName];
}
+ (BOOL)insertOrReplace:(NSArray *)objs primaryKeys:(NSArray *)primaryKeys intoTable:(NSString *)tableName {
    return [self insertOrReplace:objs generalParam:nil primaryKeys:primaryKeys intoTable:tableName];
}
/**
 插入数据
 
 @param objs 数据源
 @param generalParam 每条数据共同的参数(有则替换)
 @param primaryKeys 主键
 @param tableName 表名
 @return 插入成功
 */
+ (BOOL)insertOrReplace:(NSArray *)objs generalParam:(NSDictionary *)generalParam primaryKeys:(NSArray *)primaryKeys intoTable:(NSString *)tableName {
    SMRDBInsertOption *option = [[SMRDBInsertOption alloc] initWithObjects:objs];
    option.tableName = tableName;
    option.primaryKeys = primaryKeys;
    option.generalParam = generalParam;
    return [option excute];
}
+ (BOOL)insertOrIgnore:(NSArray *)objs generalParam:(NSDictionary *)generalParam primaryKeys:(NSArray *)primaryKeys intoTable:(NSString *)tableName {
    SMRDBInsertOption *option = [[SMRDBInsertOption alloc] initWithObjects:objs];
    option.insertType = SMRDBInsertOptionTypeInsertOrIgnore;
    option.tableName = tableName;
    option.primaryKeys = primaryKeys;
    option.generalParam = generalParam;
    return [option excute];
}

+ (NSArray *)selectAllFromTable:(NSString *)tableName {
    return [self selectWhere:nil fromTable:tableName];
}
+ (NSArray *)selectWhere:(NSString *)where fromTable:(NSString *)tableName {
    return [self selectWhere:where limit:NSMakeRange(NSNotFound, 0) paramsArray:nil fromTable:tableName];
}
+ (NSArray *)selectWhere:(NSString *)where paramsArray:(NSArray *)params fromTable:(NSString *)tableName {
    return [self selectWhere:where limit:NSMakeRange(NSNotFound, 0) paramsArray:params fromTable:tableName];
}
+ (NSArray *)selectWhere:(NSString *)where limit:(NSRange)limit fromTable:(NSString *)tableName {
    return [self selectWhere:where limit:limit paramsArray:nil fromTable:tableName];
}
+ (NSArray *)selectWhere:(NSString *)where limit:(NSRange)limit paramsArray:(NSArray *)params fromTable:(NSString *)tableName {
    SMRDBSelectOption *option = [[SMRDBSelectOption alloc] initWithModelClass:[self class]];
    option.tableName = tableName;
    option.where = where;
    option.paramsArray = params;
    option.limit = limit;
    return [option query];
}
+ (__kindof NSObject *)selectFirstObjectWhere:(NSString *)where fromTable:(NSString *)tableName {
    return [self selectFirstObjectWhere:where paramsArray:nil fromTable:tableName];
}
+ (__kindof NSObject *)selectFirstObjectWhere:(NSString *)where paramsArray:(NSArray *)params fromTable:(NSString *)tableName {
    return [self selectWhere:where limit:NSMakeRange(0, 1) paramsArray:params fromTable:tableName].firstObject;
}
+ (NSArray *)selectSql:(NSString *)sql paramsArray:(NSArray *)params fromTable:(NSString *)tableName {
    SMRDBSqlOption *option = [[SMRDBSqlOption alloc] init];
    option.sql = [self sqlForReplaceTableName:tableName fromSql:sql];
    option.paramsArray = params;
    NSArray *results = [option query];
    return [option parserResultsToModel:results withModelClass:[self class]];
}
+ (id)selectConcreteSql:(NSString *)sql paramsArray:(NSArray *)params concreteKey:(NSString *)concreteKey fromTable:(NSString *)tableName {
    SMRDBSqlOption *option = [[SMRDBSqlOption alloc] init];
    option.sql = [self sqlForReplaceTableName:tableName fromSql:sql];;
    option.paramsArray = params;
    NSArray *results = [option query];
    if (concreteKey) {
        return results.firstObject[concreteKey];
    } else {
        return results.firstObject;
    }
}

+ (BOOL)update:(NSObject *)obj where:(NSString *)where fromTable:(NSString *)tableName {
    SMRDBUpdateOption *option = [[SMRDBUpdateOption alloc] initWithObject:obj];
    option.tableName = tableName;
    option.where = where;
    return [option excute];
}

+ (BOOL)updateSetWhere:(NSString *)where params:(NSArray *)params fromTable:(NSString *)tableName {
    SMRDBUpdateOption *option = [[SMRDBUpdateOption alloc] initWithTableName:tableName where:where paramsArray:params];
    return [option excute];
}

+ (BOOL)deleteAllFromTable:(NSString *)tableName {
    return [self deleteWhere:nil fromTable:tableName];
}
+ (BOOL)deleteWhere:(NSString *)where fromTable:(NSString *)tableName {
    return [self deleteWhere:where paramsArray:nil fromTable:tableName];
}
+ (BOOL)deleteWhere:(NSString *)where paramsArray:(NSArray *)params fromTable:(NSString *)tableName {
    SMRDBDeleteOption *option = [[SMRDBDeleteOption alloc] initWithModelClass:[self class]];
    option.tableName = tableName;
    option.where = where;
    option.paramsArray = params;
    return [option excute];
}

#pragma mark - Utils
+ (NSString *)sqlForReplaceTableName:(NSString *)tableName fromSql:(NSString *)sql {
    if (!sql || !tableName) {
        return sql;
    }
    return [sql stringByReplacingOccurrencesOfString:@":tb" withString:[NSString stringWithFormat:@"'%@'", tableName]];
}

@end
