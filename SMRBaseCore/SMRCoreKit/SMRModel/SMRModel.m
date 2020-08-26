//
//  SMRModel.m
//  SMRModelDemo
//
//  Created by 丁治文 on 2018/12/18.
//  Copyright © 2018 sumrise. All rights reserved.
//

#import "SMRModel.h"
#import "YYModel.h"
#import "SMRLog.h"

@implementation NSObject (SMRModel)

+ (instancetype)smr_instanceWithDictionary:(NSDictionary *)dict {
    return [self yy_modelWithDictionary:dict];
}

+ (instancetype)smr_instanceWithDictionary:(NSDictionary *)dict key:(NSString *)key {
    if ([dict isKindOfClass:[NSArray class]]) {
        return nil;
    }
    NSDictionary *realDict = key ? dict[key] : dict;
    return [self yy_modelWithDictionary:realDict];
}

+ (NSArray *)smr_arrayWithArray:(NSArray *)array {
    if ([[self new] isKindOfClass:[NSArray class]]) {
        return array;
    }
    return [NSArray yy_modelArrayWithClass:[self class] json:array];
}

+ (NSArray *)smr_arrayWithDictionary:(NSDictionary *)dict key:(NSString *)key {
    if ([dict isKindOfClass:[NSArray class]]) {
        return [self smr_arrayWithArray:(NSArray *)dict];
    }
    NSArray *realArray = key ? dict[key] : nil;
    return [NSArray yy_modelArrayWithClass:[self class] json:realArray];
}

+ (instancetype)smr_instanceWithJsonString:(NSString *)jsonString {
    return [self smr_instanceWithDictionary:[self smr_jsonObjectWithJsonString:jsonString]];
}

+ (NSArray *)smr_arrayWithJsonString:(NSString *)jsonString {
    return [self smr_arrayWithArray:[self smr_jsonObjectWithJsonString:jsonString]];
}

+ (id)smr_jsonObjectWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    id jsonObj = [NSJSONSerialization JSONObjectWithData:jsonData
                                                         options:NSJSONReadingMutableContainers
                                                           error:&err];
    if (err) {
        base_core_warning_log(@"json解析失败：%@",err);
        return nil;
    }
    return jsonObj;
}

- (NSDictionary *)smr_toDictionary {
    NSDictionary *dict = [NSObject dictionaryWithJsonString:[self yy_modelToJSONString]];
    return dict;
}

- (NSString *)smr_toJSONString {
    return [self yy_modelToJSONString];
}

+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if (err) {
        base_core_warning_log(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

#pragma mark - SMRModelAPIParamsDelegate

- (NSDictionary *)createAPIParams {
    return [self smr_toDictionary];
}

+ (NSArray<NSDictionary *> *)createAPIParamsWithModels:(NSArray *)models {
    if (models == nil) {
        return nil;
    }
    NSMutableArray *array = [NSMutableArray array];
    for (NSObject *model in models) {
        NSDictionary *modelDict = [model createAPIParams];
        modelDict ? [array addObject:modelDict] : NULL;
    }
    return array;
}

#pragma mark - NSCoding
- (void)encodeWithCoder:(NSCoder *)aCoder {
    [self yy_modelEncodeWithCoder:aCoder];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [self init];
    [self yy_modelInitWithCoder:aDecoder];
    return self;
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone {
    return [self yy_modelCopy];
}

@end
