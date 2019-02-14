//
//  SMRUIAdapter.m
//  SMRBaseCoreDemo
//
//  Created by 丁治文 on 2019/2/13.
//  Copyright © 2019 sumrise. All rights reserved.
//

#import "SMRUIAdapter.h"

@implementation SMRUIAdapter

+ (CGFloat)interfaceScale {
    return [UIScreen mainScreen].bounds.size.width / 375.0f;
}

+ (CGFloat)smr_adapterWithValue:(CGFloat)value {
    return value*[self interfaceScale];
}

+ (CGPoint)smr_adapterWithPoint:(CGPoint)point {
    return CGPointMake(point.x*[self interfaceScale], point.y*[self interfaceScale]);
}

+ (CGSize)smr_adapterWithSize:(CGSize)size {
    return CGSizeMake(size.width*[self interfaceScale], size.height*[self interfaceScale]);
}

+ (CGRect)smr_adapterWithRect:(CGRect)rect {
    CGSize size = rect.size;
    CGPoint point = rect.origin;
    CGFloat scale = [self interfaceScale];
    return CGRectMake(point.x*scale, point.y*scale, size.width*scale, size.height*scale);
}

+ (UIEdgeInsets)smr_adapterWithInsets:(UIEdgeInsets)insets {
    CGFloat scale = [self interfaceScale];
    return UIEdgeInsetsMake(insets.top*scale, insets.left*scale, insets.bottom*scale, insets.right*scale);
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
