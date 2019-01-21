//
//  SMRModel.m
//  SMRModelDemo
//
//  Created by 丁治文 on 2018/7/21.
//  Copyright © 2018年 sumrise.com. All rights reserved.
//

#import "SMRModel.h"
#import "YYModel.h"

@implementation NSObject (SMRModel)

+ (instancetype)smr_instanceWithDictionary:(NSDictionary *)dict {
    return [self yy_modelWithDictionary:dict];
}

+ (instancetype)smr_instanceWithDictionary:(NSDictionary *)dict key:(NSString *)key {
    NSDictionary *realDict = key ? dict[key] : dict;
    return [self yy_modelWithDictionary:realDict];
}

+ (NSArray *)smr_arrayWithArray:(NSArray *)array {
    return [NSArray yy_modelArrayWithClass:[self class] json:array];
}

+ (NSArray *)smr_arrayWithDictionary:(NSDictionary *)dict key:(NSString *)key {
    NSArray *realArray = key ? dict[key] : nil;
    return [NSArray yy_modelArrayWithClass:[self class] json:realArray];
}

- (NSDictionary *)smr_toDictionary {
    NSDictionary *dict = [NSObject dictionaryWithJsonString:[self yy_modelToJSONString]];
    return dict;
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
        NSLog(@"json解析失败：%@",err);
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
