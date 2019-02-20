//
//  SMRUtils+Version.m
//  SMRBaseCoreDemo
//
//  Created by 丁治文 on 2019/2/20.
//  Copyright © 2019 sumrise. All rights reserved.
//

#import "SMRUtils+Version.h"

@implementation SMRUtils (Version)

+ (NSComparisonResult)compareVersion:(NSString *)version toVersion:(NSString *)toVersion {
    return [self compareVersion:version toVersion:toVersion buildNumber:NO];
}

+ (NSComparisonResult)compareVersion:(NSString *)version toVersion:(NSString *)toVersion buildNumber:(BOOL)buildNumber {
    return [self convertToCodeWithVersion:version buildNumber:buildNumber] - [self convertToCodeWithVersion:toVersion buildNumber:buildNumber];
}

+ (int32_t)convertToCodeWithVersion:(NSString *)version {
    return [self convertToCodeWithVersion:version buildNumber:NO];
}

+ (int32_t)convertToCodeWithVersion:(NSString *)version buildNumber:(BOOL)buildNumber {
    int32_t bitLimit = buildNumber ? 4 : 3;
    NSArray<NSString *> *vers = [version componentsSeparatedByString:@"."];
    if (vers.count < bitLimit) {
        return [self convertToCodeWithVersion:[version stringByAppendingString:@".0"] buildNumber:buildNumber];
    }
    NSString *rtn = @"";
    for (int i = 0; i < bitLimit; i++) {
        NSString *vb = vers[i];
        rtn = [rtn stringByAppendingFormat:@"%02d", vb.intValue];
    }
    return rtn.intValue;
}

@end
