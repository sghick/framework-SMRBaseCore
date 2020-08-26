//
//  SMREnumVessel.m
//  SMRBaseCoreDemo
//
//  Created by Tinswin on 2020/7/29.
//  Copyright © 2020 sumrise. All rights reserved.
//

#import "SMREnumVessel.h"

#ifndef WECEnumXCTest
#define SMREnumXCAssert(condition, desc, ...)  NSAssert(condition, desc, ##__VA_ARGS__)
#else
#define SMREnumXCAssert(a, ...)
#endif

@implementation SMREnumVessel

+ (NSArray<NSNumber *> *)vesselEnums {
    return nil;
}

+ (NSArray<NSObject *> *)vesselObjects {
    return nil;
}

// private
+ (NSInteger)indexOfEnumKey:(NSInteger)enumKey {
    NSArray<NSNumber *> *enums = [self vesselEnums];
    if (enums == nil) {
        return enumKey;
    }
    
    BOOL notfind = YES;
    NSInteger index = 0;
    for (NSNumber *num in enums) {
        if (num.integerValue == enumKey) {
            notfind = NO;
            break;
        }
        index++;
    }
    if (notfind == YES) {
        return NSNotFound;
    } else {
        return index;
    }
}

// private
+ (NSInteger)indexOfObject:(NSObject *)obj {
    NSArray<NSObject *> *objs = [self vesselObjects];
    NSInteger index = [objs indexOfObject:obj];
    return index;
}

// private
+ (NSInteger)enumOfIndex:(NSInteger)index {
    NSArray<NSNumber *> *enums = [self vesselEnums];
    if (index == NSNotFound) {
        SMREnumXCAssert(NO, @"下标无效");
        return NSNotFound;
    }
    if ((enums == nil) || (enums.count == 0)) {
        return index;
    }
    if (enums.count > index) {
        return enums[index].integerValue;
    } else {
        SMREnumXCAssert(NO, @"超出枚举值定义");
        return NSNotFound;
    }
}

// private
+ (NSObject *)objectOfIndex:(NSInteger)index {
    NSArray<NSObject *> *objs = [self vesselObjects];
    if (index == NSNotFound) {
        SMREnumXCAssert(NO, @"下标无效");
        return nil;
    }
    if ((objs == nil) || (objs.count == 0)) {
        SMREnumXCAssert(NO, @"枚举对象未定义");
        return nil;
    }
    if (objs.count > index) {
        return objs[index];
    } else {
        SMREnumXCAssert(NO, @"超出枚举对象定义");
        return nil;
    }
}

+ (NSArray *)enumObjects {
    return [self vesselObjects];
}

+ (NSArray<NSNumber *> *)enumDefines {
    NSArray *arr = [self vesselEnums];
    if (!arr) {
        NSInteger count = [self vesselObjects].count;
        NSMutableArray *mutArr = [NSMutableArray array];
        for (NSInteger i = 0; i < count; i++) {
            [mutArr addObject:@(i)];
        }
        arr = [NSArray arrayWithArray:mutArr];
    }
    return arr;
}

+ (NSObject *)objectValue:(NSInteger)enumKey {
    NSInteger index = [self indexOfEnumKey:enumKey];
    return [self objectOfIndex:index];
}

+ (NSString *)stringValue:(NSInteger)enumKey {
    NSString *str = (NSString *)[self objectValue:enumKey];
    if (![str isKindOfClass:[NSString class]]) {
        return nil;
    }
    return str;
}

+ (NSInteger)enumKey:(NSObject *)obj {
    NSInteger index = [self indexOfObject:obj];
    return [self enumOfIndex:index];
}

@end
