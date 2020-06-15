//
//  SMRDBDeleteOption.h
//  SMRDBDemo
//
//  Created by 丁治文 on 2018/9/23.
//  Copyright © 2018年 sumrise.com. All rights reserved.
//

#import "SMRDBOption.h"

@interface SMRDBDeleteOption : SMRDBOption

/**
 Optional,表名
 default:NSStringFromClass(modelClass)
 */
@property (nonatomic, copy) NSString  *tableName;

/**
 Optional,类名,指定删除的表名
 default:NULL
 */
@property (nonatomic, assign) Class     modelClass;

/**
 Optional,为sql添加条件
 default:nil
 如:
 where ...
 limit ...
 order by ...
 参数写成 key=:keyname,并在params中传入
 */
@property (nonatomic, copy) NSString  *where;

/**
 Optional,sql语句中的sql参数,如果paramsArray==nil,使用paramsDict参数
 */
@property (nonatomic, copy) NSDictionary *paramsDict;

/**
 Optional,sql语句中的sql参数,如果paramsArray!=nil,使用paramsArray参数
 */
@property (nonatomic, copy) NSArray *paramsArray;

- (instancetype)init NS_UNAVAILABLE;

/**
 初始化方法
 
 @param modelClass 要删除的类/表名
 @return DeleteOption
 */
- (instancetype)initWithModelClass:(Class)modelClass;

/**
 初始化方法
 
 @param tableName 要删除的表名
 @return DeleteOption
 */
- (instancetype)initWithTableName:(NSString *)tableName;

@end
