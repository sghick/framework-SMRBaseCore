//
//  NSNumber+SMRCents.m
//  SMRBaseCoreDemo
//
//  Created by Tinswin on 2020/6/15.
//  Copyright © 2020 sumrise. All rights reserved.
//

#import "NSNumber+SMRCents.h"

@implementation NSNumber (SMRCents)

- (NSString *)smr_yuan {
    int32_t cents = [self intValue];
    NSString *centstr = [NSString stringWithFormat:@"%@", @(cents/100.0)];
    NSDecimalNumber *dec =
    [NSDecimalNumber decimalNumberWithString:centstr];
    return dec.stringValue;
}

@end
