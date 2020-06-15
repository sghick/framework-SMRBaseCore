//
//  SMRUtilsVersionTests.m
//  SMRBaseCoreDemo
//
//  Created by 丁治文 on 2019/2/20.
//  Copyright © 2019 sumrise. All rights reserved.
//

#import "SMRUtilsVersionTests.h"
#import "SMRCommon.h"

#define version_code1(v) ([SMRUtils convertToCodeWithVersion:v])
#define version_code2(v) ([SMRUtils convertToCodeWithVersion:v buildNumber:YES])

#define compare_version1(a,b) ([SMRUtils compareVersion:a toVersion:b])
#define compare_version2(a,b) ([SMRUtils compareVersion:a toVersion:b buildNumber:YES])

@implementation SMRUtilsVersionTests

- (id)begin {
    [self testVersionCodeWithoutBuildNumber];
    [self testVersionCodeWithBuildNumber];
    
    [self testVersionCompareWithoutBuildNumber];
    [self testVersionCompareWithBuildNumber];
    
    return self;
}

- (void)testVersionCodeWithoutBuildNumber {
    assert(version_code1(@"2.2.1") == 20201);
    assert(version_code1(@"2.2.01") == 20201);
    assert(version_code1(@"2.2") == 20200);
    assert(version_code1(@"2.2.3.5") == 20203);
    assert(version_code1(@"2.2.3.0") == 20203);
    assert(version_code1(@"2.2.2.4.5.12") == 20202);
    assert(version_code1(@"3.1") == 30100);
    assert(version_code1(@"3.1.") == 30100);
}

- (void)testVersionCodeWithBuildNumber {
    assert(version_code2(@"2.2.1") == 2020100);
    assert(version_code2(@"2.2.01") == 2020100);
    assert(version_code2(@"2.2") == 2020000);
    assert(version_code2(@"2.2.3.5") == 2020305);
    assert(version_code2(@"2.2.3.0") == 2020300);
    assert(version_code2(@"2.2.2.4.5.12") == 2020204);
    assert(version_code2(@"3.1") == 3010000);
    assert(version_code2(@"3.1.") == 3010000);
}

- (void)testVersionCompareWithoutBuildNumber {
    assert(compare_version1(@"2.2.1", @"2.2.0") > 0);
    assert(compare_version1(@"2.2.1", @"2.1.9") > 0);
    assert(compare_version1(@"2.2.1", @"2.2.01") == 0);
    assert(compare_version1(@"2.2.1", @"2.2.1") == 0);
    assert(compare_version1(@"2.2", @"2.1.1") > 0);
    assert(compare_version1(@"2.2", @"2.2.1") < 0);
    assert(compare_version1(@"2.2", @"2.2.1.4.5") < 0);
    assert(compare_version1(@"2.2.3.4", @"2.2.4.4.5") < 0);
    assert(compare_version1(@"2.2.3.4.5.6", @"2.2.2.4.5.12") > 0);
    assert(compare_version1(@"3.1", @"3.1.") == 0);
    assert(compare_version1(@"2.2.3.4.5.6", @"2.2.3.4.5.12") == 0);
    
    assert(compare_version1(@"3.0.0.1", @"3.0.0.0.1") == 0);
    assert(compare_version1(@"2.2.3.1", @"2.2.3.5") == 0);
    assert(compare_version1(@"2.2.3.1", @"2.2.3.0") == 0);
}

- (void)testVersionCompareWithBuildNumber {
    assert(compare_version2(@"2.2.1", @"2.2.0") > 0);
    assert(compare_version2(@"2.2.1", @"2.1.9") > 0);
    assert(compare_version2(@"2.2.1", @"2.2.01") == 0);
    assert(compare_version2(@"2.2.1", @"2.2.1") == 0);
    assert(compare_version2(@"2.2", @"2.1.1") > 0);
    assert(compare_version2(@"2.2", @"2.2.1") < 0);
    assert(compare_version2(@"2.2", @"2.2.1.4.5") < 0);
    assert(compare_version2(@"2.2.3.4", @"2.2.4.4.5") < 0);
    assert(compare_version2(@"2.2.3.4.5.6", @"2.2.2.4.5.12") > 0);
    assert(compare_version2(@"3.1", @"3.1.") == 0);
    assert(compare_version2(@"2.2.3.4.5.6", @"2.2.3.4.5.12") == 0);
    
    assert(compare_version2(@"3.0.0.1", @"3.0.0.0.1") > 0);
    assert(compare_version2(@"2.2.3.1", @"2.2.3.5") < 0);
    assert(compare_version2(@"2.2.3.1", @"2.2.3.0") > 0);
}

@end
