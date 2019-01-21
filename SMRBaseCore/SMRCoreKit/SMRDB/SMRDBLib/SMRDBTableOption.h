//
//  SMRDBTableOption.h
//  SMRDBDemo
//
//  Created by 丁治文 on 2018/9/23.
//  Copyright © 2018年 sumrise.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SMRDBProtocol.h"

@class SMRDBMapper;
@interface SMRDBTableOption : NSObject

+ (BOOL)createAndAlterTableWithDbMapper:(SMRDBMapper *)dbMapper
                          inTransaction:(id<SMRTransactionItemDelegate>)item
                               rollback:(BOOL *)rollback;

+ (BOOL)createAndAlterTableWithName:(NSString *)tableName
                            columns:(NSDictionary *)columns
                     andPrimaryKeys:(NSArray *)primaryKeys
                      inTransaction:(id<SMRTransactionItemDelegate>)item
                           rollback:(BOOL *)rollback;

+ (BOOL)ifTableExistWithName:(NSString *)tableName
               inTransaction:(id<SMRTransactionItemDelegate>)item
                    rollback:(BOOL *)rollback;

+ (BOOL)dropTableWithName:(NSString *)tableName
            inTransaction:(id<SMRTransactionItemDelegate>)item
                 rollback:(BOOL *)rollback;

+ (NSArray *)selectExistedTablesNamesInTransaction:(id<SMRTransactionItemDelegate>)item
                                          rollback:(BOOL *)rollback;

+ (BOOL)deleteAllTablesDataInTransaction:(id<SMRTransactionItemDelegate>)item
                                rollback:(BOOL *)rollback;

@end
