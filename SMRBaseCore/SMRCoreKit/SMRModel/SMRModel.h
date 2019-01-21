//
//  SMRModel.h
//  SMRModelDemo
//
//  Created by 丁治文 on 2018/7/21.
//  Copyright © 2018年 sumrise.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SMRModelParserDelegate.h"
#import "SMRModelAPIParamsDelegate.h"

@interface NSObject (SMRModel) <
SMRModelParserDelegate,
SMRModelAPIParamsDelegate,
NSCoding,
NSCopying>

// ============================================================ //
//                  json 转 model/数组<model>
// ============================================================ //
/**
 根据字典创建本类的实例
 
 @param dict 数据源,
 @return 如果dict是: nil -> nil, @{} -> nil, 非字典类型 -> nil
 */
+ (instancetype)smr_instanceWithDictionary:(NSDictionary *)dict;
/**
 根据字典[key]创建本类的实例
 
 @param dict 数据源
 @param key 要转换的其中的key
 @return 如果dict[key]是: nil -> nil, @{} -> nil, 非字典类型 -> nil
 */
+ (instancetype)smr_instanceWithDictionary:(NSDictionary *)dict key:(NSString *)key;
/**
 根据数组<字典>创建装有本类实例的数组
 
 @param array 数据源
 @return 如果array是: nil -> nil, @[] -> nil, 非数组类型 -> nil
 */
+ (NSArray *)smr_arrayWithArray:(NSArray *)array;
/**
 根据字典[key]创建装有本类实例的数组
 
 @param dict 数据源
 @param key 要转换的其中的key
 @return 如果dict[key]是: nil -> nil, @[] -> nil, 非数组类型 -> nil
 */
+ (NSArray *)smr_arrayWithDictionary:(NSDictionary *)dict key:(NSString *)key;

/**
 model转成字典
 
 @return 字典对象
 */
- (NSDictionary *)smr_toDictionary;

@end
