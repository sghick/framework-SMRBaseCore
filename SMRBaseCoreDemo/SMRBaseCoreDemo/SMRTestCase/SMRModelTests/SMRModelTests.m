//
//  SMRModelTests.m
//  SMRBaseCoreDemo
//
//  Created by 丁治文 on 2019/3/4.
//  Copyright © 2019 sumrise. All rights reserved.
//

#import "SMRModelTests.h"
#import "SMRTestPersonModels.h"

@implementation SMRModelTests

- (id)begin {
    [self testCreateAPIParams];
    [SMRUtils showHUD];
    return self;
}

- (void)testCreateAPIParams {
    SMRPerson *person = [[SMRPerson alloc] init];
    person.name = @"小明";
    person.sex = nil;
    person.age = 0;
    NSDictionary *params = [person createAPIParams];
    assert([params[@"name"] isEqualToString:person.name]);
    assert(params[@"sex"] == nil);
    assert([params[@"age"] isEqual:@(0)]);
}

@end
