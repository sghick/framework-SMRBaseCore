//
//  SMRUIAdapter.m
//  SMRBaseCoreDemo
//
//  Created by 丁治文 on 2019/2/13.
//  Copyright © 2019 sumrise. All rights reserved.
//

#import "SMRUIAdapter.h"
#import "SMRBaseCoreInfoHelper.h"

@implementation SMRUIAdapter

+ (CGFloat)scale {
    return [UIScreen mainScreen].bounds.size.width / 375.0f;
}

+ (CGFloat)value:(CGFloat)value {
    return value * [self scale];
}

+ (CGPoint)point:(CGPoint)point {
    return CGPointMake(point.x * [self scale], point.y * [self scale]);
}

+ (CGSize)size:(CGSize)size {
    return CGSizeMake(size.width * [self scale], size.height * [self scale]);
}

+ (CGRect)rect:(CGRect)rect {
    CGSize size = rect.size;
    CGPoint point = rect.origin;
    CGFloat scale = [self scale];
    return CGRectMake(point.x * scale, point.y * scale, size.width * scale, size.height * scale);
}

+ (UIEdgeInsets)insets:(UIEdgeInsets)insets {
    CGFloat scale = [self scale];
    return UIEdgeInsetsMake(insets.top*scale, insets.left*scale, insets.bottom*scale, insets.right*scale);
}

+ (CGSize)fitSize:(CGSize)size withHeight:(CGFloat)height {
    if (!size.height) {
        return CGSizeZero;
    }
    CGFloat width = height*size.width/size.height;
    return CGSizeMake(width, height);
}
+ (CGSize)fitSize:(CGSize)size withWidth:(CGFloat)width {
    if (!size.width) {
        return CGSizeZero;
    }
    CGFloat height = width*size.height/size.width;
    return CGSizeMake(width, height);
}

static CGFloat _margin = -1;
+ (CGFloat)margin {
    if (_margin == -1) {
        _margin = [SMRBaseCoreInfoHelper marginWithScale:[self scale]];
    }
    return _margin;
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
