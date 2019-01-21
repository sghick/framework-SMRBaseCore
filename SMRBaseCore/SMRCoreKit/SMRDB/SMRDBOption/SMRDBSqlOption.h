//
//  SMRDBSqlOption.h
//  SMRDBDemo
//
//  Created by 丁治文 on 2018/9/23.
//  Copyright © 2018年 sumrise.com. All rights reserved.
//

#import "SMRDBOption.h"

@interface SMRDBSqlOption : SMRDBOption

/**
 sql语句
 */
@property (nonatomic, copy) NSString  *sql;

/**
 Optional,sql语句中的sql参数,如果paramsArray==nil,使用paramsDict参数
 */
@property (nonatomic, copy) NSDictionary *paramsDict;

/**
 Optional,sql语句中的sql参数,如果paramsArray!=nil,使用paramsArray参数
 */
@property (nonatomic, copy) NSArray *paramsArray;

@end
