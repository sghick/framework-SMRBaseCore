//
//  SMRInterfaceAdapter.m
//  SMRBaseCoreDemo
//
//  Created by 丁治文 on 2019/1/21.
//  Copyright © 2019 sumrise. All rights reserved.
//

#import "SMRInterfaceAdapter.h"

@implementation smr_InterfaceAdapter

+ (CGFloat)interfaceScale {
    return [UIScreen mainScreen].bounds.size.width / 375.0f;
}

+ (CGFloat)smr_adapterWithValue:(CGFloat)value {
    return value * [self interfaceScale];
}

+ (CGPoint)smr_adapterWithPoint:(CGPoint)point {
    return CGPointMake(point.x * [self interfaceScale], point.y * [self interfaceScale]);
}

+ (CGSize)smr_adapterWithSize:(CGSize)size {
    return CGSizeMake(size.width * [self interfaceScale], size.height * [self interfaceScale]);
}

+ (CGRect)smr_adapterWithRect:(CGRect)rect {
    CGSize size = rect.size;
    CGPoint point = rect.origin;
    CGFloat scale = [self interfaceScale];
    return CGRectMake(point.x * scale, point.y * scale, size.width * scale, size.height * scale);
}

+ (BOOL)overtopiOS10 {
    return [SYSTEM_VERSION compare:@"10.0.0" options:NSNumericSearch] != NSOrderedAscending;
}

+ (BOOL)overtopiOS11 {
    return [SYSTEM_VERSION compare:@"11.0.0" options:NSNumericSearch] != NSOrderedAscending;
}

+ (BOOL)overtopiOS12 {
    return [SYSTEM_VERSION compare:@"12.0.0" options:NSNumericSearch] != NSOrderedAscending;
}

@end
