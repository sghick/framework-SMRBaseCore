//
//  SMRUtils+Version.m
//  SMRBaseCoreDemo
//
//  Created by 丁治文 on 2019/2/20.
//  Copyright © 2019 sumrise. All rights reserved.
//

#import "SMRUtils+Version.h"

@implementation SMRUtils (Version)

static NSString *_format = nil;
+ (void)setVersionFormat:(NSString *)format {
    _format = format;
}

+ (NSComparisonResult)compareVersion:(NSString *)version toVersion:(NSString *)toVersion {
    return [self compareVersion:version toVersion:toVersion buildNumber:NO];
}

+ (NSComparisonResult)compareVersion:(NSString *)version toVersion:(NSString *)toVersion buildNumber:(BOOL)buildNumber {
    int32_t result = [self convertToCodeWithVersion:version buildNumber:buildNumber] - [self convertToCodeWithVersion:toVersion buildNumber:buildNumber];
    if (result > 0) {
        return NSOrderedDescending;
    } else if (result < 0) {
        return NSOrderedAscending;
    } else {
        return NSOrderedSame;
    }
}

+ (int32_t)convertToCodeWithVersion:(NSString *)version {
    return [self convertToCodeWithVersion:version buildNumber:NO];
}

+ (int32_t)convertToCodeWithVersion:(NSString *)version buildNumber:(BOOL)buildNumber {
    return [self p_convertToCodeWithVersion:version buildNumber:buildNumber format:_format];
}

+ (int32_t)p_convertToCodeWithVersion:(NSString *)version buildNumber:(BOOL)buildNumber format:(nullable NSString *)format {
    if (!version.length) {
        return 0;
    }
    int32_t bitLimit = buildNumber ? 4 : 3;
    NSArray<NSString *> *vers = [version componentsSeparatedByString:@"."];
    NSArray<NSString *> *fms = [format componentsSeparatedByString:@"."];
    if (vers.count < bitLimit) {
        return [self p_convertToCodeWithVersion:[version stringByAppendingString:@".0"] buildNumber:buildNumber format:format];
    }
    NSString *defm = @"%02d"; /// 默认使用此format
    NSString *rtn = @"";
    for (int i = 0; i < bitLimit; i++) {
        NSString *vb = vers[i];
        NSString *fm = (fms.count > i) ? fms[i] : defm;
        rtn = [rtn stringByAppendingFormat:fm, vb.intValue];
    }
    return rtn.intValue;
}

@end
