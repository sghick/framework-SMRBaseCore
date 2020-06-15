//
//  SMRUtilsValidateTests.m
//  SMRBaseCoreDemo
//
//  Created by 丁治文 on 2019/2/17.
//  Copyright © 2019 sumrise. All rights reserved.
//

#import "SMRUtilsValidateTests.h"
#import "SMRCommon.h"

@implementation SMRUtilsValidateTests

- (id)begin {
    [self testMatchStringRegex001];
    [self testMatchStringRegex002];
    return self;
}

- (void)testMatchStringRegex001 {
    NSString *content = @"SDFG host = ['www.baidu.com','www.google.com']; host = ['www.baidu2.com','www.google2.com'];";
    NSString *regex = @"host = \\[([a-z0-9\\.\\/:\\-',\\s]+)\\];";
    NSArray *results = [SMRUtils matchFirstGroupsInString:content regex:regex];
    NSLog(@"测试结果1:\n%@", results);
}

- (void)testMatchStringRegex002 {
    NSString *content = @"SDFG host = ['www.baidu.com','www.google.com']; host = ['www.baidu2.com','www.google2.com'];";
    NSString *regex = @"host = \\[[a-z0-9\\.\\/:\\-',\\s]+\\];";
    NSArray *results = [SMRUtils matchFirstGroupsInString:content regex:regex];
    NSLog(@"测试结果2:\n%@", results);
}

@end
