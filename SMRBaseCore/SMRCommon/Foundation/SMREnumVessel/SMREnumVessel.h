//
//  SMREnumVessel.h
//  SMRBaseCoreDemo
//
//  Created by Tinswin on 2020/7/29.
//  Copyright © 2020 sumrise. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol SMREnumVesselProtocol <NSObject>

@optional
+ (NSArray<NSNumber *> *)vesselEnums;
@required
+ (NSArray<NSObject *> *)vesselObjects;

@end

@interface SMREnumVessel : NSObject<SMREnumVesselProtocol>

/**
 获取枚举对应的字符串或者对象

 @return 获取枚举对应的字符串
 */
+ (NSArray *)enumObjects;

/**
 获取枚举对应的item

 @return 获取枚举对应的item
 */
+ (NSArray<NSNumber *> *)enumDefines;

/**
 枚举值 转 对应对象

 @param enumKey 枚举值
 @return 枚举值对应的对象
 */
+ (NSObject *)objectValue:(NSInteger)enumKey;

/**
 枚举值 转 对应字符串
 
 @param enumKey 枚举值
 @return 枚举值对应的字符串
 */
+ (NSString *)stringValue:(NSInteger)enumKey;

/**
 使用相应字符串或对象获取对应枚举值,通过根据地址指针来判断

 @param obj 字符串或对象
 @return 字符串/对象对应的枚举值
 */
+ (NSInteger)enumKey:(NSObject *)obj;

@end

NS_ASSUME_NONNULL_END
