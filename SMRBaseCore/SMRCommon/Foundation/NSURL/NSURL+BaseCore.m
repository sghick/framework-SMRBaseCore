//
//  NSURL+BaseCore.m
//  SMRBaseCoreDemo
//
//  Created by Tinswin on 2020/4/20.
//  Copyright © 2020 sumrise. All rights reserved.
//

#import "NSURL+BaseCore.h"

@implementation NSURL (BaseCore)

+ (NSURL *)smr_URLWithString:(NSString *)string {
    NSURL *url = [NSURL URLWithString:[string stringByReplacingOccurrencesOfString:@" " withString:@""]];
    return url;
}

+ (NSString *)smr_encodeURLQueryStringWithString:(NSString *)string {
    NSCharacterSet *encodeUrlSet = [NSCharacterSet URLQueryAllowedCharacterSet];
    NSString *encodeUrl = [string stringByAddingPercentEncodingWithAllowedCharacters:encodeUrlSet];
    return encodeUrl;
}
+ (NSString *)smr_encodeURLStringWithString:(NSString *)string {
    NSCharacterSet *encodeUrlSet = [NSCharacterSet URLUserAllowedCharacterSet];
    NSString *encodeUrl = [string stringByAddingPercentEncodingWithAllowedCharacters:encodeUrlSet];
    // 强行替换'='
    encodeUrl = [encodeUrl stringByReplacingOccurrencesOfString:@"=" withString:@"%3D"];
    encodeUrl = [encodeUrl stringByReplacingOccurrencesOfString:@"&" withString:@"%26"];
    return encodeUrl;
}
+ (NSString *)smr_decodeURLStringWithString:(NSString *)string {
    NSString *decodeUrl = [string stringByRemovingPercentEncoding];
    return decodeUrl;
}

#pragma mark - components

- (NSDictionary *)smr_urlParams {
    NSString *urlQuery = self.query;
    if (urlQuery.length == 0) return nil;
    NSURLComponents *urlCmp = [NSURLComponents componentsWithURL:self resolvingAgainstBaseURL:YES];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    for (NSURLQueryItem *item in urlCmp.queryItems) {
        NSString *key = [item.name stringByRemovingPercentEncoding];
        NSString *value = [item.value stringByRemovingPercentEncoding];
        if (!key.length || value == nil) {
            continue;
        }

        id existValue = [parameters valueForKey:key];
        if (existValue) {
            if ([existValue isKindOfClass:[NSArray class]]) {
                NSMutableArray *items = [existValue mutableCopy];
                [items addObject:value];
                parameters[key] = items;
            } else {
                parameters[key] = @[existValue, value];
            }
        } else {
            parameters[key] = value;
        }
    }
    return [parameters copy];
}

#pragma mark - Utils

- (NSURL *)smr_URLByAppendKey:(NSString *)key value:(id)value {
    if (!key || !value) {
        return self;
    }
    return [self smr_URLByAppendParams:@{key:value}];
}
- (NSURL *)smr_URLByAppendParams:(NSDictionary *)params {
    if (!params.count) {
        return self;
    }
    NSURLComponents *urlCmp = [NSURLComponents componentsWithURL:self resolvingAgainstBaseURL:YES];
    NSMutableArray<NSURLQueryItem *> *queryItems = [NSMutableArray array];
    [queryItems addObjectsFromArray:urlCmp.queryItems];
    [queryItems addObjectsFromArray:[self p_queryItemsWithParams:params]];
    urlCmp.queryItems = queryItems;
    return urlCmp.URL;
}

- (NSURL *)smr_URLByReplaceKey:(NSString *)key value:(id)value {
    if (!key || !value) {
        return self;
    }
    return [self smr_URLByReplaceParams:@{key:value}];
}
- (NSURL *)smr_URLByReplaceParams:(NSDictionary *)params {
    if (!params.count) {
        return self;
    }
    NSMutableDictionary *realParams = [self.smr_urlParams mutableCopy];
    [realParams setValuesForKeysWithDictionary:params];
    NSURLComponents *urlCmp = [NSURLComponents componentsWithURL:self resolvingAgainstBaseURL:YES];
    urlCmp.queryItems = [self p_queryItemsWithParams:realParams];
    return urlCmp.URL;
}

- (NSURL *)smr_URLByRemoveKey:(NSString *)key {
    NSMutableDictionary *realParams = [self.smr_urlParams mutableCopy];
    realParams[key] = nil;
    NSURLComponents *urlCmp = [NSURLComponents componentsWithURL:self resolvingAgainstBaseURL:YES];
    urlCmp.queryItems = [self p_queryItemsWithParams:realParams];
    return urlCmp.URL;
}

#pragma mark - Privates

- (NSString *)p_querySign {
    NSMutableString *string = [NSMutableString string];
    NSURLComponents *urlCmp = [NSURLComponents componentsWithURL:self resolvingAgainstBaseURL:YES];
    for (NSURLQueryItem *item in urlCmp.queryItems) {
        [string appendFormat:@"&%@=%@", item.name, item.value];
    }
    return [string copy];
}

- (NSArray<NSURLQueryItem *> *)p_queryItemsWithParams:(NSDictionary *)params {
    if (!params.count) {
        return nil;
    }
    NSMutableArray<NSURLQueryItem *> *queryItems = [NSMutableArray array];
    for (NSString *key in params) {
        NSArray<NSURLQueryItem *> *items = [self p_queryItemsWithKey:key value:params[key]];
        [queryItems addObjectsFromArray:items];
    }
    return [queryItems copy];
}

- (NSArray<NSURLQueryItem *> *)p_queryItemsWithKey:(NSString *)key value:(id)value {
    if (!key.length || !value) {
        return nil;
    }
    NSMutableArray<NSURLQueryItem *> *queryItems = [NSMutableArray array];
    if ([value isKindOfClass:[NSString class]]) {
        NSURLQueryItem *item = [NSURLQueryItem queryItemWithName:key value:[NSURL smr_encodeURLStringWithString:value]];
        [queryItems addObject:item];
    } else if ([value isKindOfClass:[NSArray class]]) {
        NSArray *objs = (NSArray *)value;
        for (id obj in objs) {
            NSArray<NSURLQueryItem *> *items = [self p_queryItemsWithKey:key value:obj];
            [queryItems addObjectsFromArray:items];
        }
    } else {
        NSURLQueryItem *item = [NSURLQueryItem queryItemWithName:key value:[NSString stringWithFormat:@"%@", value]];
        [queryItems addObject:item];
    }
    return [queryItems copy];
}

#pragma mark - Static Utils

+ (NSArray *)smr_buildArrayTypeWithParam:(id)param {
    id rtn = param;
    if (param && ![param isKindOfClass:[NSArray class]]) {
        rtn = @[param];
    }
    return rtn;
}

+ (id)smr_buildInstanceTypeWithParam:(id)param {
    id rtn = param;
    if (param && [param isKindOfClass:[NSArray class]]) {
        rtn = ((NSArray *)param).lastObject;
    }
    return rtn;
}

@end
