//
//  SMRFMDBManager.h
//  SMRDBDemo
//
//  Created by 丁治文 on 2018/9/23.
//  Copyright © 2018年 sumrise.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SMRDBProtocol.h"

typedef NS_ENUM(NSInteger, SMRDBStatus) {
    DB_CREATE_FAIL    = -1,//数据库创建失败
    DB_CREATE_SUCCESS = 0,//数据库创建成功
    DB_EXIST          = 1,//数据库已经存在
    DB_OPEN_FAIL      = 2,//数据库链接失败
    DB_OPEN_SUCCESS   = 3,//数据库链接成功
    DB_OPENNING       = 4,//数据库当前为open状态
    DB_CLOSED         = 5,//数据库当前为close状态
};

@class FMDatabaseQueue;
@class FMDatabase;
@interface SMRTransactionItem : NSObject<SMRTransactionItemDelegate>

@property (nonatomic, strong) FMDatabaseQueue   *queue;
@property (nonatomic, strong) FMDatabase        *db;

@end

@interface SMRFMDBManager : NSObject<SMRDBManagerProtocol>

+ (SMRFMDBManager *)sharedInstance;

/// 创建或者连接数据库，如果数据库不存在则建立并连接打开，如果数据库已经存在则直接连接打开,不需要包含后缀名
- (SMRDBStatus)connectDatabaseWithName:(NSString *)name;
/// 创建或者连接数据库，版本号与原来不同,则删除原来的Database,并重新创建一个新的
- (SMRDBStatus)connectDatabaseWithName:(NSString *)name withVersion:(double)version;
/// 获取数据库当前状态，OPEN还是CLOSED
- (SMRDBStatus)getDatabaseConnectStatus;
/// 关闭数据库
- (void)closeDatabase;
/// 删除数据库文件
- (BOOL)deleteDatabase;

/// 获取当前的数据库对象
- (FMDatabase *)getCurrentDatabase;
/// 获取数据库文件路径
- (NSString *)getDBFilePath;
/// 检查数据库文件是否存在
- (BOOL)checkDBFileExist;

@end
