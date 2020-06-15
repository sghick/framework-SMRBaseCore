//
//  SMRDBOption.h
//  SMRDBDemo
//
//  Created by 丁治文 on 2018/9/22.
//  Copyright © 2018年 sumrise.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SMRDBProtocol.h"

@protocol SMRDBOption <NSObject>

@required
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
 是否被标记为需要自动创建或者修改表结构
 */
@property (nonatomic, assign, readonly) BOOL needsAutoCreateAndAlterTable;

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
 标记执行sql前检查创建或者修改表,默认不会创建或者修改
 [注意:此方法仅限于调用 -[excute] 或者 -[query] 方法有效]
 
 @param modelClass  类名
 @param tableName   Optional,表名,可空,如果为nil,则以类名作为表名
 @param primaryKeys Optional,主键
 */
- (void)setNeedsAutoCreateAndAlterTableWithModelClass:(Class)modelClass tableName:(NSString *)tableName primaryKeys:(NSArray *)primaryKeys;

/**
 手动解析结果
 
 @param results     使用Option返回的结果
 @param modelClass  类名
 */
- (id)parserResultsToModel:(NSArray *)results withModelClass:(Class)modelClass;

@end
