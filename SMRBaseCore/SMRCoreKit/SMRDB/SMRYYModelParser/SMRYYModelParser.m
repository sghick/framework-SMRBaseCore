//
//  SMRYYModelParser.m
//  SMRDBDemo
//
//  Created by 丁治文 on 2018/9/23.
//  Copyright © 2018年 sumrise.com. All rights reserved.
//

#import "SMRYYModelParser.h"
#import "SMRDBMapper.h"
#import "SMRDBColumn.h"
#import "YYModel.h"

@implementation SMRYYModelParser

- (NSDictionary *)sqlParamsDictFromModel:(NSObject *)obj withDBMapper:(SMRDBMapper *)dbMapper {
    if (!obj) {
        return nil;
    }
    if (!dbMapper) {
        return nil;
    }
    
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    for (NSString *name in dbMapper.all_column_names) {
        if (![obj respondsToSelector:NSSelectorFromString(name)]) {
            NSAssert(NO, @"请检查是否有bug");
            continue;
        }
        id value = [obj valueForKey:name];
        SMRDBColumn *column = [dbMapper columnWithColumnName:name];
        NSData *objectValue = [SMRYYModelParser parserToDBParamsWithValue:value withColumn:column];
        [dict setValue:(objectValue?objectValue:[NSNull null]) forKey:name];
    }
    return [NSDictionary dictionaryWithDictionary:dict];
}

- (id)modelFromDict:(NSDictionary *)dict class:(Class)cls withDBMapper:(SMRDBMapper *)dbMapper {
    if (!dict) {
        return nil;
    }
    if (!cls) {
        return nil;
    }
    if (!dbMapper) {
        return nil;
    }
    
    NSMutableDictionary *mutDict = [NSMutableDictionary dictionary];
    for (NSString *name in dbMapper.all_column_names) {
        id value = dict[name];
        if (value && ![value isKindOfClass:[NSNull class]]) {
            SMRDBColumn *column = [dbMapper columnWithColumnName:name];
            id jsonObject = [SMRYYModelParser parserToObjectWithValue:value withColumn:column];
            if (jsonObject) {
                [mutDict setObject:jsonObject forKey:name];
            }
        }
    }
    NSObject *obj = [cls yy_modelWithDictionary:mutDict];
    return obj;
}

#pragma mark - JSON Utils
+ (id)parserToDBParamsWithValue:(id)value withColumn:(SMRDBColumn *)column {
    if (!value || [value isKindOfClass:[NSNull class]]) {
        return nil;
    }
    
    switch (column.property_type) {
        case SMRDBPropertyTypeCustom: {
            if ([column.dbTypeSymbol isEqualToString:dbColumnTypeBlob]) {
                NSData *objectValue = [value yy_modelToJSONData];
                return objectValue;
            }
        }
            break;
        case SMRDBPropertyTypeArray: {
            if ([column.dbTypeSymbol isEqualToString:dbColumnTypeBlob]) {
                NSData *objectValue = [value yy_modelToJSONData];
                return objectValue;
            }
        }
            break;
        case SMRDBPropertyTypeDictionary: {
            if ([column.dbTypeSymbol isEqualToString:dbColumnTypeBlob]) {
                NSData *objectValue = [value yy_modelToJSONData];
                return objectValue;
            }
        }
            break;
            
        default:
            break;
    }
    return value;
}

+ (id)parserToObjectWithValue:(id)value withColumn:(SMRDBColumn *)column {
    switch (column.property_type) {
        case SMRDBPropertyTypeCustom: {
            id jsonObject = [SMRYYModelParser parserToCustomOrDictionaryOrArray:value withColumn:column];
            return jsonObject;
        }
            break;
        case SMRDBPropertyTypeArray: {
            id jsonObject = [SMRYYModelParser parserToCustomOrDictionaryOrArray:value withColumn:column];
            return jsonObject;
        }
            break;
        case SMRDBPropertyTypeDictionary: {
            id jsonObject = [SMRYYModelParser parserToCustomOrDictionaryOrArray:value withColumn:column];
            return jsonObject;
        }
            break;
            
        default:
            break;
    }
    return value;
}

+ (id)parserToCustomOrDictionaryOrArray:(NSData *)data withColumn:(SMRDBColumn *)column {
    if (![data isKindOfClass:[NSData class]]) {
        return nil;
    }
    NSError *err;
    id responseObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&err];
    //data转换成dic或者数组
    if (err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return responseObject;
}

@end
