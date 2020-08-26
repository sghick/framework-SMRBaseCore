//
//  SMRDataBaseTests.m
//  SMRBaseCoreDemo
//
//  Created by Tinswin on 2020/6/22.
//  Copyright © 2020 sumrise. All rights reserved.
//

#import "SMRDataBaseTests.h"
#import "SMRDB.h"
#import "SMRTestDBModels.h"

@implementation SMRDataBaseTests

- (id)begin {
    [self test_insert];
    [self test_update];
    [self test_select];
    [self test_delete];
    
    [self test_alter];
//    [self test_alter2];
//    [self test_alter3];
//    [self test_add];
    
    return self;
}

- (void)test_insert {
    [SMRTestDBPerson deleteAll];
    
    SMRTestDBPerson *xiaoming = [SMRTestDBPerson createXiaoMing];
    SMRTestDBPerson *xiaogang = [SMRTestDBPerson createXiaoGang];
    SMRTestDBPerson *xiaohua = [SMRTestDBPerson createXiaoHua];
    NSArray *p = @[xiaoming, xiaogang, xiaohua];
    assert([SMRTestDBPerson insertOrReplace:p primaryKeys:@[@"identifier"]]);
    
    NSArray<SMRTestDBPerson *> *rs = [SMRTestDBPerson selectAll];
    assert(rs.count == p.count);
    for (SMRTestDBPerson *ps in rs) {
        assert([p containsObject:ps]);
    }
}

- (void)test_update {
    [SMRTestDBPerson deleteAll];
    SMRTestDBPerson *xiaoming = [SMRTestDBPerson createXiaoMing];
    [SMRTestDBPerson insertOrReplace:@[xiaoming] primaryKeys:@[@"identifier"]];
    
    xiaoming.name = @"dongdong";
    NSString *where = [NSString stringWithFormat:@"WHERE identifier=%@", xiaoming.identifier];
    
    SMRTestDBPerson *dong1 = [SMRTestDBPerson selectFirstObjectWhere:where];
    [SMRTestDBPerson update:xiaoming where:where];
    SMRTestDBPerson *dong2 = [SMRTestDBPerson selectFirstObjectWhere:where];
    assert(![dong1.name isEqualToString:dong2.name]);
    assert([xiaoming.name isEqualToString:dong2.name]);
}

- (void)test_select {
    // see other case
}

- (void)test_delete {
    [SMRTestDBPerson deleteAll];
    
    SMRTestDBPerson *xiaoming = [SMRTestDBPerson createXiaoMing];
    SMRTestDBPerson *xiaogang = [SMRTestDBPerson createXiaoGang];
    SMRTestDBPerson *xiaohua = [SMRTestDBPerson createXiaoHua];
    NSArray *p = @[xiaoming, xiaogang, xiaohua];
    assert([SMRTestDBPerson insertOrReplace:p primaryKeys:@[@"identifier"]]);
    
    NSArray<SMRTestDBPerson *> *rs = [SMRTestDBPerson selectAll];
    assert(rs.count != 0);
    [SMRTestDBPerson deleteAll];
    rs = [SMRTestDBPerson selectAll];
    assert(rs.count == 0);
}

- (void)test_alter {
    [SMRTestDBPerson deleteAll];
    
    SMRTestDBPerson *xiaoming = [SMRTestDBPerson createXiaoMing];
    SMRTestDBPerson *xiaogang = [SMRTestDBPerson createXiaoGang];
    SMRTestDBPerson *xiaohua = [SMRTestDBPerson createXiaoHua];
    NSArray *p = @[xiaoming, xiaogang, xiaohua];
    assert([SMRTestDBPerson insertOrReplace:p primaryKeys:@[@"identifier"]]);
}

- (void)test_alter2 {
//    [SMRTestDBPerson deleteAll];
//
//    SMRTestDBPerson *xiaoming = [SMRTestDBPerson createXiaoMing];
//    SMRTestDBPerson *xiaogang = [SMRTestDBPerson createXiaoGang];
//    SMRTestDBPerson *xiaohua = [SMRTestDBPerson createXiaoHua];
//    NSArray *p = @[xiaoming, xiaogang, xiaohua];
//    assert([SMRTestDBPerson1 insertOrReplace:p primaryKeys:@[@"identifier"]]);
    
    NSLog(@"begin_empty:%@", @([[NSDate date] timeIntervalSince1970]));
    for (int i = 0; i < 10000; i++) {
        int a = 1 + 2;
    }
    NSLog(@"end_empty:%@", @([[NSDate date] timeIntervalSince1970]));
    
    
    NSLog(@"begin:%@", @([[NSDate date] timeIntervalSince1970]));
    for (int i = 0; i < 10000; i++) {
        [SMRTestDBPerson1 alterTableWithPrimaryKeys:@[@"identifier"]];
        [SMRTestDBPerson alterTableWithPrimaryKeys:@[@"identifier"] tableName:@"SMRTestDBPerson1"];
    }
    NSLog(@"end:%@", @([[NSDate date] timeIntervalSince1970]));
    
    NSLog(@"请查看数据库的表结构是否有变化");
}

- (void)test_alter3 {
    [SMRTestDBPerson setNeedsAlterTableWithPrimaryKeys:@[@"identifier"]];
    [SMRTestDBPerson1 setNeedsAlterTableWithPrimaryKeys:@[@"identifier"]];
    [SMRTestDBPerson setNeedsAlterTableWithPrimaryKeys:@[@"identifier"]];
    [SMRTestDBPerson1 setNeedsAlterTableWithPrimaryKeys:@[@"identifier"]];
    [SMRTestDBPerson setNeedsAlterTableWithPrimaryKeys:@[@"identifier"]];
    [SMRTestDBPerson1 setNeedsAlterTableWithPrimaryKeys:@[@"identifier"]];
    NSLog(@"即将执行表更新了哦!");
    [SMRTestDBPerson selectAll];
    [SMRTestDBPerson1 deleteAll];
}

- (void)test_add {
//    SMRTestDBPerson *xiaoming = [SMRTestDBPerson createXiaoMing];
    SMRTestDBPerson *xiaogang = [SMRTestDBPerson createXiaoGang];
    NSArray *p = @[xiaogang];
    assert([SMRTestDBPerson insertOrReplace:p primaryKeys:@[@"identifier"]]);
}

@end
