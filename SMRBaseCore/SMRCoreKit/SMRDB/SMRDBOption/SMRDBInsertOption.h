//
//  SMRDBInsertOption.h
//  SMRDBDemo
//
//  Created by 丁治文 on 2018/9/23.
//  Copyright © 2018年 sumrise.com. All rights reserved.
//

#import "SMRDBOption.h"

typedef NS_ENUM(NSInteger, SMRDBInsertOptionType) {
    SMRDBInsertOptionTypeInsert,             // 普通插入
    SMRDBInsertOptionTypeInsertOrReplace,    // 需要结合主键，如果不存在就插入，存在就更新 (default)
    SMRDBInsertOptionTypeInsertOrIgnore,     // 需要结合主键，如果不存在就插入，存在就忽略
};

@interface SMRDBInsertOption : SMRDBOption

/**
 Optional,表名
 default:objs.firstObject.class
 */
@property (nonatomic, copy) NSString  *tableName;

/**
 Optional,创建表时指定的主键
 default:nil
 */
@property (nonatomic, strong) NSArray   *primaryKeys;

/**
 要被插入的数据源
 */
@property (nonatomic, strong) NSArray   *objects;

/**
 通用参数,每条数据的相应字段都使用相同的值,格式为:@{param1:value1, param2:value2}
 如果没有相应字段,则无效
 */
@property (nonatomic, strong) NSDictionary  *generalParam;

/**
 Optional,插入操作类型
 default:SMRDBInsertOptionTypeInsertOrReplace
 */
@property (nonatomic, assign) SMRDBInsertOptionType insertType;

- (instancetype)init NS_UNAVAILABLE;

/**
 初始化方法
 
 @param objs 要插入的models
 @return InsertOption对象
 */
- (instancetype)initWithObjects:(NSArray *)objs;

@end
