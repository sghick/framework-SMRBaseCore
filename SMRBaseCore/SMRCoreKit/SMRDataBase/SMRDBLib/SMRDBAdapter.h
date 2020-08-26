//
//  SMRDBAdapter.h
//  SMRDataBaseDemo
//
//  Created by 丁治文 on 2018/12/18.
//  Copyright © 2018 sumrise. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SMRDBProtocol.h"

@interface SMRDBAdapter : NSObject

/** 是否输入执行的sql,默认NO */
@property (nonatomic, assign) BOOL logForSql;

/** 基本数据库,不可空 */
@property (nonatomic, strong) id<SMRDBManagerProtocol>  dbManager;

/** 可以设置解析数据,否则将使用默认解析器 */
@property (nonatomic, strong) id<SMRDBParserDelegate>   dbParser;

+ (instancetype)shareInstance;

@end
