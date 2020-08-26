//
//  SMRURLTests.m
//  SMRBaseCoreDemo
//
//  Created by Tinswin on 2020/4/20.
//  Copyright © 2020 sumrise. All rights reserved.
//

#import "SMRURLTests.h"
#import "NSURL+BaseCore.h"

@implementation SMRURLTests

- (id)begin {
    [self test_creates];
    [self test_encode_query];
    [self test_encode_all];
    [self test_decode];
    [self test_params_append];
    [self test_paraseredParams];
    [self test_changeArrayType];
    [self test_changeInstanceType];
    return self;
}

- (void)test_creates {
    // 正常链接
    NSString *urlString = @"https://www.baidu.com?aaa=1&bbb=2";
    NSURL *url = [NSURL smr_URLWithString:urlString];
    NSAssert([urlString isEqualToString:url.absoluteString], @"");
    // 过滤空格
    NSString *urlString2 = @" https://www.baidu.com? aaa=1&bbb=2 ";
    NSURL *url2 = [NSURL smr_URLWithString:urlString2];
    NSAssert([urlString isEqualToString:url2.absoluteString], @"");
    // 重复参数
    NSString *urlString3 = @"https://www.baidu.com?aaa=1&bbb=2&bbb=3";
    NSURL *url3 = [NSURL smr_URLWithString:urlString3];
    NSAssert([urlString3 isEqualToString:url3.absoluteString], @"");
    // 非法链接
    NSString *urlString4 = @"https://www.baidu.com?aaa=参数1&bbb=参数2";
    NSURL *url4 = [NSURL smr_URLWithString:urlString4];
    NSAssert(!url4, @"");
}

- (void)test_encode_query {
    // encode urlString 中的 query部分
    NSString *urlString = @"https://www.baidu.com?aaa=参数1&bbb=参数2&bbb=参数3";
    NSString *urlString2 = @"https://www.baidu.com?aaa=%e5%8f%82%e6%95%b01&bbb=%e5%8f%82%e6%95%b02&bbb=%e5%8f%82%e6%95%b03";
    NSString *urlString3 = [NSURL smr_encodeURLQueryStringWithString:urlString];
    NSAssert([urlString2.lowercaseString isEqualToString:urlString3.lowercaseString], @"");
}

- (void)test_encode_all {
    // encode 整个 urlString
    NSString *urlString = @"https://www.baidu.com?aaa=参数1&bbb=参数2&bbb=参数3";
    NSString *urlString2 = @"https%3a%2f%2fwww.baidu.com%3faaa%3d%e5%8f%82%e6%95%b01%26bbb%3d%e5%8f%82%e6%95%b02%26bbb%3d%e5%8f%82%e6%95%b03";
    NSString *urlString3 = [NSURL smr_encodeURLStringWithString:urlString];
    NSAssert([urlString2.lowercaseString isEqualToString:urlString3.lowercaseString], @"");
}

- (void)test_decode {
    // encode 整个 urlString
    NSString *urlString = @"https://www.baidu.com?aaa=参数1&bbb=参数2&bbb=参数3";
    NSString *urlString2 = @"https%3a%2f%2fwww.baidu.com%3faaa%3d%e5%8f%82%e6%95%b01%26bbb%3d%e5%8f%82%e6%95%b02%26bbb%3d%e5%8f%82%e6%95%b03";
    NSString *urlString3 = [NSURL smr_decodeURLStringWithString:urlString2];
    NSAssert([urlString.lowercaseString isEqualToString:urlString3.lowercaseString], @"");
    
    // encode urlString
    NSString *urlString4 = @"https://www.baidu.com?aaa=%e5%8f%82%e6%95%b01&bbb=%e5%8f%82%e6%95%b02&bbb=%e5%8f%82%e6%95%b03";
    NSString *urlString5 = [NSURL smr_decodeURLStringWithString:urlString4];
    NSAssert([urlString.lowercaseString isEqualToString:urlString5.lowercaseString], @"");
}

- (void)test_params_append {
    NSString *urlString = @"https://www.baidu.com?aaa=1&bbb=2&bbb=3&bbb=4&ccc=5";
    NSURL *url = [NSURL smr_URLWithString:@"https://www.baidu.com?aaa=1&bbb=2&bbb=3"];
    // 增加一个字典作为参数
    NSDictionary *params = @{@"bbb":@"4",
                             @"ccc":@"5"};
    NSURL *url2 = [url smr_URLByAppendParams:params];
    NSAssert([urlString isEqualToString:url2.absoluteString], @"");
    
    // 增加参数
    NSURL *url3 = [url smr_URLByAppendKey:@"bbb" value:@"4"];
    url3 = [url3 smr_URLByAppendKey:@"ccc" value:@"5"];
    NSAssert([urlString isEqualToString:url3.absoluteString], @"");
    
    // 增加一个字典作为参数
    NSURL *url4 = [NSURL smr_URLWithString:@"https://www.baidu.com?aaa=1"];
    NSDictionary *params4 = @{@"bbb":@[@"2", @"3", @"4"],
                              @"ccc":@"5"};
    NSURL *url5 = [url4 smr_URLByAppendParams:params4];
    NSAssert([urlString isEqualToString:url5.absoluteString], @"");
    
    // 增加一个字典作为参数2
    NSURL *url6 = [NSURL smr_URLWithString:@"https://www.baidu.com?aaa=1&bbb=2"];
    NSDictionary *params6 = @{@"bbb":@[@"3", @"4"],
                              @"ccc":@"5"};
    NSURL *url7 = [url6 smr_URLByAppendParams:params6];
    NSAssert([urlString isEqualToString:url7.absoluteString], @"");
    
    // 增加嵌套了数组的字典作为参数23
    NSURL *url8 = [NSURL smr_URLWithString:@"https://www.baidu.com?aaa=1"];
    NSDictionary *params8 = @{@"bbb":@[@"2", @[@"3", @"4"]],
                              @"ccc":@"5"};
    NSURL *url9 = [url8 smr_URLByAppendParams:params8];
    NSAssert([urlString isEqualToString:url9.absoluteString], @"");
}

- (void)test_paraseredParams {
    NSString *urlString = @"https://www.baidu.com?aaa=1&bbb=2&bbb=3&bbb=4&ccc=5";
    NSURL *url = [NSURL smr_URLWithString:urlString];
    NSDictionary *params = [url smr_parseredParams];
    NSDictionary *params2 = @{@"aaa":@"1",
                              @"bbb":@[@"2", @"3", @"4"],
                              @"ccc":@"5"};
    NSAssert([params isEqualToDictionary:params2], @"");
}

- (void)test_changeArrayType {
    NSString *stringValue = @"aaaa";
    NSArray *arrValue = @[stringValue];
    
    NSArray *arr = [NSURL smr_buildArrayTypeWithParam:stringValue];
    NSAssert([arrValue isEqualToArray:arr], @"");
    
    NSArray *arr2 = [NSURL smr_buildArrayTypeWithParam:arrValue];
    NSAssert([arrValue isEqualToArray:arr2], @"");
}

- (void)test_changeInstanceType {
    NSString *stringValue = @"aaaa";
    NSArray *arrValue = @[stringValue];
    
    NSString *string = [NSURL smr_buildInstanceTypeWithParam:stringValue];
    NSAssert([stringValue isEqualToString:string], @"");
    
    NSString *string2 = [NSURL smr_buildInstanceTypeWithParam:arrValue];
    NSAssert([stringValue isEqualToString:string2], @"");
}

@end
