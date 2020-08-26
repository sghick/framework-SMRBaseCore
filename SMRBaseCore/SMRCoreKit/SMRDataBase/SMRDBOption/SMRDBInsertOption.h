//
//  SMRDBInsertOption.h
//  SMRDataBaseDemo
//
//  Created by 丁治文 on 2018/12/18.
//  Copyright © 2018 sumrise. All rights reserved.
//

#import "SMRDBOption.h"

typedef NS_ENUM(NSInteger, SMRDBInsertOptionType) {
    SMRDBInsertOptionTypeInsert,             // 普通插入
    SMRDBInsertOptionTypeInsertOrReplace,    // 需要结合主键，如果不存在就插入，存在就更新 (default)
    SMRDBInsertOptionTypeInsertOrIgnore,     // 需要结合主键，如果不存在就插入，存在就忽略
};

@interface SMRDBInsertOption : SMRDBOption

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

