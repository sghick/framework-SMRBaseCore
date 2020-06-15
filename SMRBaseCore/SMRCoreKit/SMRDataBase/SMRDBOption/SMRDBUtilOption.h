//
//  SMRDBUtilOption.h
//  SMRDBDemo
//
//  Created by 丁治文 on 2018/9/23.
//  Copyright © 2018年 sumrise.com. All rights reserved.
//

#import "SMRDBOption.h"

@interface SMRDBUtilOption : SMRDBOption

/**
 *  根据表名判断是否已经在数据库中存在此表
 *
 *  @param tableName 表名
 *
 *  @return 如果存在返回YES，不存在返回NO
 */
+ (BOOL)ifTableExistWithName:(NSString *)tableName;

/**
 *  根据表名删除表
 *
 *  @param tableName 表名
 *
 *  @return 删除成功返回YES，失败返回NO
 */
+ (BOOL)dropTableWithName:(NSString *)tableName;

/**
 *  查询当前数据库中已经存在的表名称
 *
 *  @return 返回结果列表
 */
+ (NSArray *)selectExistedTablesNames;

/**
 *  慎用，此方法会删除所有表的记录
 *
 *  @return 返回删除结果，成功为YES， 失败为NO
 */
+ (BOOL)deleteAllTablesData;

@end
