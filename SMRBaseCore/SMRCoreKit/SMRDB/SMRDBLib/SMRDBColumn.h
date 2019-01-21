//
//  SMRDBColumn.h
//  SMRDBDemo
//
//  Created by 丁治文 on 2018/9/22.
//  Copyright © 2018年 sumrise.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

// dbColumnType
extern NSString * const dbColumnTypeText;
extern NSString * const dbColumnTypeBlob;
extern NSString * const dbColumnTypeDate;
extern NSString * const dbColumnTypeReal;
extern NSString * const dbColumnTypeInteger;
extern NSString * const dbColumnTypeFloat;
extern NSString * const dbColumnTypeDouble;
extern NSString * const dbColumnTypeBoolean;
extern NSString * const dbColumnTypeSmallint;
extern NSString * const dbColumnTypeCurrency;
extern NSString * const dbColumnTypeVarchar;
extern NSString * const dbColumnTypeBinary;
extern NSString * const dbColumnTypeTime;
extern NSString * const dbColumnTypeTimestamp;

typedef NS_ENUM(NSInteger, SMRDBPropertyType) {
    SMRDBPropertyTypeUnknow      = 0,    // 未知
    SMRDBPropertyTypeValue       = 1,    // 数值
    SMRDBPropertyTypeArray       = 2,    // 数组
    SMRDBPropertyTypeDictionary  = 3,    // 字典
    SMRDBPropertyTypeDate        = 4,    // 日期
    SMRDBPropertyTypeCustom      = 5,    // 自定义类
};

@interface SMRDBColumn : NSObject

@property (nonatomic, copy) NSString *dbTypeSymbol;                 ///< if none, return dbType, default is none
@property (nonatomic, strong, readonly) NSString *dbType;           ///< dbColumnType

@property (nonatomic, assign) SMRDBPropertyType property_type;       ///< 类型区分

// property info
@property (nonatomic, strong, readonly) NSString *name;             ///< property's name
@property (nonatomic, strong, readonly) NSString *typeEncoding;     ///< property's encoding value
@property (nonatomic, strong, readonly) NSString *ivarName;         ///< property's ivar name
@property (nonatomic, assign, readonly) Class cls;                  ///< may be nil

+ (instancetype)dbColumnWithAttributeString:(objc_property_t)property;
- (instancetype)initWithName:(NSString *)name typeEncoding:(NSString *)typeEncoding ivarName:(NSString *)ivarName cls:(Class)cls;

- (BOOL)isEqualToDBColumn:(SMRDBColumn *)column;///< dbName,dbType is compared
- (NSString *)column_description;///< dbName,dbType,dbTypeSymbol is show

- (NSString *)description;

@end
