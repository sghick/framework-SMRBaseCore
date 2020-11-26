//
//  NSNumber+SMRCents.m
//  SMRBaseCoreDemo
//
//  Created by Tinswin on 2019/4/3.
//  Copyright © 2019年 sumrise. All rights reserved.
//

#import "NSNumber+SMRCents.h"

@implementation NSNumber (SMRCents)

- (NSString *)smr_yuan {
    uint64_t cents = [self unsignedIntegerValue];
    return [self reviseString:(cents/100.0)];
}

- (NSString *)smr_string {
    return [self reviseString:self.doubleValue];
}

/*!
 @brief 修正浮点型精度丢失
 @param conversionValue 传入接口取到的数据
 @return 修正精度后的数据
 */
- (NSString *)reviseString:(double)conversionValue {
    //直接传入精度丢失有问题的Double类型
    NSString *doubleString = [NSString stringWithFormat:@"%lf", conversionValue];
    NSDecimalNumber *decNumber = [NSDecimalNumber decimalNumberWithString:doubleString];
    return [decNumber stringValue];
}

@end
