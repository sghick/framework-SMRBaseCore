//
//  SMRDBOption.m
//  SMRDBDemo
//
//  Created by 丁治文 on 2018/9/22.
//  Copyright © 2018年 sumrise.com. All rights reserved.
//

#import "SMRDBOption.h"
#import "SMRDBAdapter.h"
#import "SMRDBMapper.h"
#import "SMRDBTableOption.h"

@interface SMRDBOption ()

/**
 Optional,表名
 default:NSStringFromClass(modelClass)
 */
@property (nonatomic, copy) NSString  *baseTableName;

/**
 Optional,类名,指定创建的表/类名
 default:NULL
 */
@property (nonatomic, assign) Class     baseModelClass;

/**
 Optional,创建表时指定的主键
 default:nil
 */
@property (nonatomic, strong) NSArray   *basePrimaryKeys;

@end

@implementation SMRDBOption

- (int)excuteInTransaction:(id<SMRTransactionItemDelegate>)item rollback:(BOOL *)rollback {
    return 0;
}

- (id)queryInTransaction:(id<SMRTransactionItemDelegate>)item rollback:(BOOL *)rollback {
    return nil;
}

- (int)excute {
    __block int count = 0;
    [[SMRDBAdapter shareInstance].dbManager doOptionInTransaction:^(id<SMRTransactionItemDelegate> item, BOOL *rollback) {
        if (self.needsAutoCreateAndAlterTable) {
            SMRDBMapper *dbMapper = [self dbMapper];
            if (dbMapper == nil) {
                return;
            }
            BOOL isTableModifiedSuccess = [SMRDBTableOption createAndAlterTableWithDbMapper:dbMapper inTransaction:item rollback:rollback];
            if (isTableModifiedSuccess == NO) {
                return;
            }
        }
        
        count += [self excuteInTransaction:item rollback:rollback];
    }];
    return count;
}

- (id)query {
    __block id result = nil;
    [[SMRDBAdapter shareInstance].dbManager doOptionInTransaction:^(id<SMRTransactionItemDelegate> item, BOOL *rollback) {
        if (self.needsAutoCreateAndAlterTable) {
            SMRDBMapper *dbMapper = [self dbMapper];
            if (dbMapper == nil) {
                return;
            }
            BOOL isTableModifiedSuccess = [SMRDBTableOption createAndAlterTableWithDbMapper:dbMapper inTransaction:item rollback:rollback];
            if (isTableModifiedSuccess == NO) {
                return;
            }
        }
        
        result = [self queryInTransaction:item rollback:rollback];
    }];
    return result;
}

- (SMRDBMapper *)dbMapper {
    SMRDBMapper *dbMapper = [SMRDBMapper dbMapperWithClass:self.baseModelClass
                                                 tableName:self.baseTableName
                                               primaryKeys:self.basePrimaryKeys];
    return dbMapper;
}

- (void)setNeedsAutoCreateAndAlterTableWithModelClass:(Class)modelClass tableName:(NSString *)tableName primaryKeys:(NSArray *)primaryKeys {
    _needsAutoCreateAndAlterTable = YES;
    _baseModelClass = modelClass;
    _baseTableName = tableName;
    _basePrimaryKeys = primaryKeys;
}

- (id)parserResultsToModel:(NSArray *)results withModelClass:(Class)modelClass {
    SMRDBMapper *dbMapper = [SMRDBMapper dbMapperWithClass:modelClass];
    if (results && modelClass) {
        NSMutableArray *array = [NSMutableArray array];
        for (NSDictionary *dict in results) {
            NSObject *obj = [[SMRDBAdapter shareInstance].dbParser modelFromDict:dict class:modelClass withDBMapper:dbMapper];
            if (obj) {
                [array addObject:obj];
            }
        }
        return [NSArray arrayWithArray:array];
    }
    return nil;
}

@end
