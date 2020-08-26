//
//  SMRTestDBModels.m
//  SMRBaseCoreDemo
//
//  Created by Tinswin on 2020/6/22.
//  Copyright © 2020 sumrise. All rights reserved.
//

#import "SMRTestDBModels.h"

@implementation SMRTestDBModels

@end

@implementation SMRTestDBPerson

- (BOOL)isEqual:(id)object {
    SMRTestDBPerson *ps = object;
    if (![self.identifier isEqualToString:ps.identifier]) {
        return NO;
    }
    if (![self.name isEqualToString:ps.name]) {
        return NO;
    }
    if (self.sex != ps.sex) {
        return NO;
    }
    if (self.age != ps.age) {
        return NO;
    }
    return YES;
}

+ (instancetype)createXiaoMing {
    SMRTestDBPerson *person = [[SMRTestDBPerson alloc] init];
    person.identifier = @"123456200107271111";
    person.name = @"xiao ming";
    person.sex = 1;
    person.age = 19;
//    person.height = 175;
//    person.weight = 55;
    return person;
}
+ (instancetype)createXiaoGang {
    SMRTestDBPerson *person = [[SMRTestDBPerson alloc] init];
    person.identifier = @"123456200501032222";
    person.name = @"xiao gang";
    person.sex = 1;
    person.age = 15;
    return person;
}
+ (instancetype)createXiaoHua {
    SMRTestDBPerson *person = [[SMRTestDBPerson alloc] init];
    person.identifier = @"123456200702063333";
    person.name = @"xiao Hua";
    person.sex = 2;
    person.age = 17;
    return person;
}

@end

@implementation SMRTestDBPerson1

@end
