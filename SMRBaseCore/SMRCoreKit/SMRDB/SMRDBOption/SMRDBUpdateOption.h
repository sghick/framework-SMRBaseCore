//
//  SMRDBUpdateOption.h
//  SMRDBDemo
//
//  Created by 丁治文 on 2018/9/23.
//  Copyright © 2018年 sumrise.com. All rights reserved.
//

#import "SMRDBOption.h"

@interface SMRDBUpdateOption : SMRDBOption

/**
 Optional,表名
 default:object.class
 */
@property (nonatomic, copy) NSString  *tableName;

/**
 要被修改的数据源
 default:nil
 */
@property (nonatomic, strong) NSObject  *object;

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
 Optional,为sql中的参数
 */
@property (nonatomic, copy, readonly) NSArray *paramsArray;

- (instancetype)init NS_UNAVAILABLE;

/**
 初始化方法
 
 @param obj 要修改的model
 @return UpdateOption对象
 */
- (instancetype)initWithObject:(NSObject *)obj;

/**
 初始化方法
 
 @param tableName   表名
 @param paramsArray where中的条件
 @return UpdateOption对象
 */
- (instancetype)initWithTableName:(NSString *)tableName where:(NSString *)where paramsArray:(NSArray *)paramsArray;

@end
