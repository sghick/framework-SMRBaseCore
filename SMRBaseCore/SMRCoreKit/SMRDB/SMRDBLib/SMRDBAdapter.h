//
//  SMRDBAdapter.h
//  SMRDBDemo
//
//  Created by 丁治文 on 2018/9/23.
//  Copyright © 2018年 sumrise.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SMRDBProtocol.h"

@interface SMRDBAdapter : NSObject

@property (nonatomic, strong) id<SMRDBManagerProtocol>  dbManager;  ///< 基本数据库,不可空
@property (nonatomic, strong) id<SMRDBParserDelegate>   dbParser;   ///< 可以设置解析数据,否则将使用默认解析器

+ (instancetype)shareInstance;

@end
