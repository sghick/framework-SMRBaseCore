//
//  SMRDBOption.h
//  SMRDataBaseDemo
//
//  Created by 丁治文 on 2018/12/18.
//  Copyright © 2018 sumrise. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SMRDBLib.h"
#import "SMRDBProtocol.h"
#import "SMRLog.h"

@protocol SMRDBOption <NSObject>

@required

/**
 返回实时的sql语句
 */
- (NSString *)sql;

/**
 执行无返回值的option
 
 @return 返回执行成功的option数
 */
- (int)excuteInTransaction:(id<SMRTransactionItemDelegate>)item rollback:(BOOL *)rollback;

/**
 执行option
 
 @return    1.普通option时:返回结果为NSArray<NSDictionary>或者NSArray<model>
 2.GroupOption时:若每一个option的返回结果为T,则实际返回结果为NSArray<T>
 */
- (id)queryInTransaction:(id<SMRTransactionItemDelegate>)item rollback:(BOOL *)rollback;

@end

@interface SMRDBOption : NSObject<SMRDBOption>

/**
 适配器
 */
@property (nonatomic, strong, readonly) SMRDBAdapter *dbAdapter;

/**
 数据库管理对象
 */
@property (nonatomic, strong, readonly) id<SMRDBManagerProtocol> dbManager;

/**
 解析器
 */
@property (nonatomic, strong, readonly) id<SMRDBParserDelegate> dbParser;

/**
 数据库表的映射
 */
@property (nonatomic, strong, readonly) SMRDBMapper *dbMapper;

/**
 数据库表名
 default:NSStringFromClass(modelClass)
 */
@property (nonatomic, strong) NSString *tableName;

/**
 Optional,类名,指定操作的表名
 default:NULL
*/
@property (nonatomic, assign) Class modelClass;

/**
 Optional,创建表时指定的主键
 default:nil
 */
@property (nonatomic, strong) NSArray<NSString *> *primaryKeys;

/** 初始化 */
- (instancetype)initWithTableName:(NSString *)tableName;
- (instancetype)initWithTableName:(NSString *)tableName
                       modelClass:(Class)modelClass
                      primaryKeys:(NSArray<NSString *> *)primaryKeys;

/**
 在事务中执行option
 
 @return 返回执行成功的option数
 */
- (int)excute;

/**
 在事务中执行option
 
 @return    1.普通option时:返回结果为NSArray<NSDictionary>或者NSArray<model>
 2.GroupOption时:若每一个option的返回结果为T,则实际返回结果为NSArray<T>
 */
- (id)query;

/**
 根据version来标记是否强制检查更新
 [注意:此方法仅限于调用 -[excute] 或者 -[query] 方法有效]
 
 @param modelClass  类名
 @param tableName   Optional,表名,可空,如果为nil,则以类名作为表名
 @param primaryKeys Optional,主键,未更新表前可以重新设置
 */
- (void)setAlterTableWithModelClass:(Class)modelClass
                          tableName:(NSString *)tableName
                        primaryKeys:(NSArray *)primaryKeys;

/**
 手动解析结果
 
 @param results     使用Option返回的结果
 @param modelClass  类名
 */
- (id)parserResultsToModel:(NSArray *)results withModelClass:(Class)modelClass;

@end

@interface SMRDBOption (Helper)

#pragma mark - Base

/**
 如有需要执行表的修改, 不需要执行/执行成功返回YES
 */
- (BOOL)alterTableIfNeeded:(id<SMRTransactionItemDelegate>)item
                  rollback:(BOOL *)rollback;

#pragma mark - Utils

/**
 *  根据表名判断是否已经在数据库中存在此表
 *
 *  @param tableName 表名
 *
 *  @return 如果存在返回YES，不存在返回NO
 */
- (BOOL)ifTableExistWithName:(NSString *)tableName;

/**
 *  根据表名删除表
 *
 *  @param tableName 表名
 *
 *  @return 删除成功返回YES，失败返回NO
 */
- (BOOL)dropTableWithName:(NSString *)tableName;

/**
 *  查询当前数据库中已经存在的表名称
 *
 *  @return 返回结果列表
 */
- (NSArray *)selectExistedTablesNames;

/**
 *  慎用，此方法会删除所有表的记录
 *
 *  @return 返回删除结果，成功为YES， 失败为NO
 */
- (BOOL)deleteAllTablesData;

@end

