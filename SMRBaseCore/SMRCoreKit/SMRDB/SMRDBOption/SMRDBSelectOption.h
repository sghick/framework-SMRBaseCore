//
//  SMRDBSelectOption.h
//  SMRDBDemo
//
//  Created by 丁治文 on 2018/9/23.
//  Copyright © 2018年 sumrise.com. All rights reserved.
//

#import "SMRDBOption.h"

@interface SMRDBSelectOption : SMRDBOption

/**
 Optional,表名
 default:NSStringFromClass(modelClass)
 */
@property (nonatomic, copy) NSString  *tableName;

/**
 Optional,类名,指定查询的表名
 default:nil
 如果modelClass没有值,查询结果将返回一个字典
 */
@property (nonatomic, assign) Class     modelClass;

/**
 Optional,查询结果中处理成对象的子对象映射
 default:nil
 */
@property (nonatomic, copy) NSArray   *classMappers;

/**
 Optional,如 select * from 表名 order by aaa desc limit limit.location,limit.length
 default:(0,0)(在sqlite中返回0条数据);
 表示 从limit.location开始取limit.length条 {0,0}无数据 {NSNotFound,y}取所有
 */
@property (nonatomic, assign) NSRange limit;

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
 
 @param modelClass 查询结果的类或表名
 @return SelectOption
 */
- (instancetype)initWithModelClass:(Class)modelClass;

/**
 初始化方法
 
 @param tableName 查询的表名
 @return SelectOption
 */
- (instancetype)initWithTableName:(NSString *)tableName;

@end
