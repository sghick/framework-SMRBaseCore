//
//  NSObject+SMRDB.h
//  SMRDBDemo
//
//  Created by 丁治文 on 2018/9/23.
//  Copyright © 2018年 sumrise.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (SMRDB)

#pragma mark - DefaultTableName
+ (NSString *)tableName;

+ (BOOL)insertOrReplace:(NSArray *)objs; ///< 常规插入数据
+ (BOOL)insertOrReplace:(NSArray *)objs generalParam:(NSDictionary *)generalParam; ///< 插入数据中统一某字段的值:{key<字段名>:value<要统一的值>}
+ (BOOL)insertOrReplace:(NSArray *)objs primaryKeys:(NSArray *)primaryKeys; ///< 指定主键
+ (BOOL)insertOrReplace:(NSArray *)objs generalParam:(NSDictionary *)generalParam primaryKeys:(NSArray *)primaryKeys;

+ (NSArray *)selectAll; ///< 常规查数据
+ (NSArray *)selectWhere:(NSString *)where; ///< 按条件查数据
+ (NSArray *)selectWhere:(NSString *)where paramsArray:(NSArray *)params; ///< 按条件查数据+条件参数
+ (NSArray *)selectWhere:(NSString *)where limit:(NSRange)limit; ///< 按条件查数据,从limit.location开始取limit.length条 {0,0}无数据 {NSNotFound,y}取所有
+ (NSArray *)selectWhere:(NSString *)where limit:(NSRange)limit paramsArray:(NSArray *)params; ///< 按条件查数据+条件参数,从limit.location开始取limit.length条 {0,0}无数据 {NSNotFound,y}取所有
+ (__kindof NSObject *)selectFirstObjectWhere:(NSString *)where;
+ (__kindof NSObject *)selectFirstObjectWhere:(NSString *)where paramsArray:(NSArray *)params;
+ (NSArray *)selectSql:(NSString *)sql paramsArray:(NSArray *)params; ///< 按sql查数据+条件参数
+ (id)selectConcreteSql:(NSString *)sql paramsArray:(NSArray *)params concreteKey:(NSString *)concreteKey; ///< 只返回结果的第一行(NSDictionary *),如果concreteKey不为空,返回concreteKey对应的内容(id),concreteKey必须是sql结果中的字段名

+ (BOOL)update:(NSObject *)obj where:(NSString *)where; ///< 按条件更新数据
+ (BOOL)updateSetWhere:(NSString *)where params:(NSArray *)params;///< 更新自定义的字段

+ (BOOL)deleteAll; ///< 常规删除数据
+ (BOOL)deleteWhere:(NSString *)where; ///< 按条件删除数据
+ (BOOL)deleteWhere:(NSString *)where paramsArray:(NSArray *)params; ///< 按条件删除数据+条件参数

#pragma mark - OtherTableName
+ (BOOL)insertOrReplace:(NSArray *)objs intoTable:(NSString *)tableName;
+ (BOOL)insertOrReplace:(NSArray *)objs generalParam:(NSDictionary *)generalParam intoTable:(NSString *)tableName;
+ (BOOL)insertOrReplace:(NSArray *)objs primaryKeys:(NSArray *)primaryKeys intoTable:(NSString *)tableName;
+ (BOOL)insertOrReplace:(NSArray *)objs generalParam:(NSDictionary *)generalParam primaryKeys:(NSArray *)primaryKeys intoTable:(NSString *)tableName;
+ (BOOL)insertOrIgnore:(NSArray *)objs generalParam:(NSDictionary *)generalParam primaryKeys:(NSArray *)primaryKeys intoTable:(NSString *)tableName;

+ (NSArray *)selectAllFromTable:(NSString *)tableName;
+ (NSArray *)selectWhere:(NSString *)where fromTable:(NSString *)tableName;
+ (NSArray *)selectWhere:(NSString *)where paramsArray:(NSArray *)params fromTable:(NSString *)tableName;
+ (NSArray *)selectWhere:(NSString *)where limit:(NSRange)limit fromTable:(NSString *)tableName;
+ (NSArray *)selectWhere:(NSString *)where limit:(NSRange)limit paramsArray:(NSArray *)params fromTable:(NSString *)tableName;
+ (__kindof NSObject *)selectFirstObjectWhere:(NSString *)where fromTable:(NSString *)tableName;
+ (__kindof NSObject *)selectFirstObjectWhere:(NSString *)where paramsArray:(NSArray *)params fromTable:(NSString *)tableName;

+ (BOOL)update:(NSObject *)obj where:(NSString *)where fromTable:(NSString *)tableName;
+ (BOOL)updateSetWhere:(NSString *)where params:(NSArray *)params fromTable:(NSString *)tableName;

+ (BOOL)deleteAllFromTable:(NSString *)tableName;
+ (BOOL)deleteWhere:(NSString *)where fromTable:(NSString *)tableName;
+ (BOOL)deleteWhere:(NSString *)where paramsArray:(NSArray *)params fromTable:(NSString *)tableName;

#pragma mark - Utils
/// 将sql中 (:tb) 替换为 tableName
+ (NSString *)sqlForReplaceTableName:(NSString *)tableName fromSql:(NSString *)sql;

@end
