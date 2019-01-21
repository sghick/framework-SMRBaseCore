//
//  SMRDBProtocol.h
//  SMRDBDemo
//
//  Created by 丁治文 on 2018/9/22.
//  Copyright © 2018年 sumrise.com. All rights reserved.
//

#import <Foundation/Foundation.h>

/// 如果需要传递特殊参数给manager,请遵循此协议创建item
@protocol SMRTransactionItemDelegate <NSObject>

@end

/// 自动解析时需要实现的方法
@class SMRDBMapper;
@protocol SMRDBParserDelegate <NSObject>

/// 将model转换成sql的参数的实现
- (NSDictionary *)sqlParamsDictFromModel:(NSObject *)obj withDBMapper:(SMRDBMapper *)dbMapper;
/// 将数据库查询结果转换成model的实现
- (id)modelFromDict:(NSDictionary *)dict class:(Class)cls withDBMapper:(SMRDBMapper *)dbMapper;

@end

typedef void(^SMRTransactionBlock)(id<SMRTransactionItemDelegate> item, BOOL *rollback);

@protocol SMRDBManagerProtocol <NSObject>

/// 请实现在事务中处理任务的方法
- (void)doOptionInTransaction:(SMRTransactionBlock)block;
/// 请实现执行多条sql语句的方法
+ (BOOL)excuteSQLs:(NSArray *)sqlArray inTransaction:(id<SMRTransactionItemDelegate>)transaction rollback:(BOOL *)rollback;
/// 请实现执行一条sql语句,参数为字典的方法
+ (BOOL)excuteSQL:(NSString *)sql withParamsInDictionary:(NSDictionary *)params inTransaction:(id<SMRTransactionItemDelegate>)transaction rollback:(BOOL *)rollback;
/// 请实现执行一条sql语句,参数为数组的方法
+ (BOOL)excuteSQL:(NSString *)sql withParamsInArray:(NSArray *)params inTransaction:(id<SMRTransactionItemDelegate>)transaction rollback:(BOOL *)rollback;
/// 请实现查询一条sql语句,参数为字典的方法
+ (NSArray *)querySQL:(NSString *)sql withParamsInDictionary:(NSDictionary *)params inTransaction:(id<SMRTransactionItemDelegate>)transaction rollback:(BOOL *)rollback;
/// 请实现查询一条sql语句,参数为数组的方法
+ (NSArray *)querySQL:(NSString *)sql withParamsInArray:(NSArray *)params inTransaction:(id<SMRTransactionItemDelegate>)transaction rollback:(BOOL *)rollback;

@end
