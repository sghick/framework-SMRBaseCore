//
//  SMRDBUpdateOption.h
//  SMRDataBaseDemo
//
//  Created by 丁治文 on 2018/12/18.
//  Copyright © 2018 sumrise. All rights reserved.
//

#import "SMRDBOption.h"

@interface SMRDBUpdateOption : SMRDBOption

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

