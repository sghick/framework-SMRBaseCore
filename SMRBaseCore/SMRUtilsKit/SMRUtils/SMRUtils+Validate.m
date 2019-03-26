//
//  SMRUtils+Validate.m
//  SMRBaseCoreDemo
//
//  Created by 丁治文 on 2019/2/14.
//  Copyright © 2019 sumrise. All rights reserved.
//

#import "SMRUtils+Validate.h"

NSString * const SMRValidateFormatRealName = @"^[a-zA-Z\u4e00-\u9fa5 ]+$";
NSString * const SMRValidateFormatAccount = @"^[a-zA-Z0-9]{1,20}+$";
NSString * const SMRValidateFormatPassword = @"^[a-zA-Z0-9]{1,20}+$";
NSString * const SMRValidateFormatPhoneNumber = @"^(1)\\d{10}$";
NSString * const SMRValidateFormatNumber4 = @"^[0-9]{4}$";
NSString * const SMRValidateFormatNumber6 = @"^[0-9]{6}$";

@implementation SMRUtils (Validate)

+ (NSArray<NSString *> *)matchFirstGroupsInString:(NSString *)content regex:(NSString *)regex {
    NSRegularExpressionOptions options = NSRegularExpressionCaseInsensitive;
    NSError *error = NULL;
    NSRegularExpression *reg = [NSRegularExpression regularExpressionWithPattern:regex options:options error:&error];
    NSTextCheckingResult *result = [reg firstMatchInString:content options:0 range:NSMakeRange(0, [content length])];
    if (result.numberOfRanges > 0) {
        NSMutableArray *retArray = [NSMutableArray array];
        for (int i = 0; i < result.numberOfRanges; i++) {
            NSString *retString = [content substringWithRange:[result rangeAtIndex:i]];
            [retArray addObject:retString];
        }
        return [retArray copy];
    }
    return nil;
}

+ (NSArray<NSArray<NSString *> *> *)matchGroupsInString:(NSString *)content regex:(NSString *)regex {
    NSRegularExpressionOptions options = NSRegularExpressionCaseInsensitive;
    NSError *error = NULL;
    NSRegularExpression *reg = [NSRegularExpression regularExpressionWithPattern:regex options:options error:&error];
    NSArray<NSTextCheckingResult *> *results = [reg matchesInString:content options:0 range:NSMakeRange(0, [content length])];
    NSMutableArray<NSArray *> *rtn = [NSMutableArray array];
    for (NSTextCheckingResult *result in results) {
        if (result.numberOfRanges > 0) {
            NSMutableArray *arr = [NSMutableArray array];
            for (int i = 0; i < result.numberOfRanges; i++) {
                NSString *retString = [content substringWithRange:[result rangeAtIndex:i]];
                [arr addObject:retString];
            }
            [rtn addObject:[arr copy]];
        }
    }
    if (rtn.count > 0) {
        return [rtn copy];
    } else {
        return nil;
    }
}

+ (BOOL)validateString:(NSString *)validateString predicateFormat:(NSString *)predicateFormat regex:(NSString *)regex {
    BOOL isValid = NO;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%@ %@", predicateFormat, regex];
    isValid = [predicate evaluateWithObject:validateString];
    return isValid;
}

+ (BOOL)validateString:(NSString *)validateString regex:(NSString *)regex {
    BOOL isValid = NO;
    NSRange range = [validateString rangeOfString:regex options:NSRegularExpressionSearch];
    if (range.location != NSNotFound) {
        isValid = YES;
    }
    return isValid;
}

+ (BOOL)validateString:(NSString *)validateString options:(NSRegularExpressionOptions)options regex:(NSString *)regex {
    BOOL isValid = NO;
    NSError *error = NULL;
    NSRegularExpression *reg = [NSRegularExpression regularExpressionWithPattern:regex options:options error:&error];
    NSTextCheckingResult *result = [reg firstMatchInString:validateString options:0 range:NSMakeRange(0, [validateString length])];
    if (result) {
        isValid = YES;
    }
    return isValid;
}

+ (BOOL)validateIdWithString:(NSString *)string {
    BOOL isValid = NO;
    if (string.length == 15) {
        isValid = [self validateString:string regex:@"^[1-9]\\d{7}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])\\d{3}$"];
    } else if (string.length == 18) {
        isValid = [self validateString:string regex:@"^[1-9]\\d{5}[1-2]\\d{3}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])((\\d{4})|\\d{3}[Xx])$"];
    }
    
    if (string.length == 18 && isValid) {
        // 检验18位身份证的校验码是否正确。
        // 校验位按照ISO 7064:1983.MOD 11-2的规定生成，X可以认为是数字10。
        NSString *num = string.uppercaseString;
        int arrInt[] = {7, 9, 10, 5, 8, 4, 2, 1, 6, 3, 7, 9, 10, 5, 8, 4, 2};
        char arrCh[] = {'1', '0', 'X', '9', '8', '7', '6', '5', '4', '3', '2'};
        int nTemp = 0;
        for (int i = 0; i < 17; i ++) {
            nTemp += [num substringWithRange:NSMakeRange(i, 1)].intValue*arrInt[i];
        }
        int valnum = arrCh[nTemp%11];
        if (![[num substringWithRange:NSMakeRange(17, 1)] isEqualToString:[NSString stringWithFormat:@"%c", valnum]]) {
            isValid = NO;
        }
    }
    return isValid;
}

@end
