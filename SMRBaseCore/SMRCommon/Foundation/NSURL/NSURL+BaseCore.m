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

- (NSURL *)smr_URLByAppendKey:(NSString *)key value:(id)value {
    if (!key || !value) {
        return self;
    }
    return [self smr_URLByAppendParams:@{key:value}];
}

- (NSURL *)smr_URLByAppendParams:(NSDictionary *)params {
    if (!params) {
        return self;
    }
    NSString *query = @"";
    for (NSString *key in params) {
        query = [query stringByAppendingString:[self smr_URLParamWithKey:key value:params[key]]];
    }
    return [self smr_URLByAppendQuery:query];
}

- (NSURL *)smr_URLByAppendQuery:(NSString *)query {
    NSString *urlString = self.absoluteString;
    if (self.query.length) {
        urlString = [urlString stringByAppendingString:@"&"];
    } else {
        urlString = [urlString stringByAppendingString:@"?"];
    }
    NSString *realQuery = query;
    if (realQuery.length && ([realQuery hasPrefix:@"&"] || [realQuery hasPrefix:@"?"])) {
        realQuery = [realQuery substringFromIndex:1];
    }
    urlString = [urlString stringByAppendingString:realQuery];
    NSURL *rtnUrl = [NSURL URLWithString:urlString];
    return rtnUrl;
}

/** 前面会带一个 & 符号 */
- (NSString *)smr_URLParamWithKey:(NSString *)key value:(id)value {
    if (!key || !value) {
        return nil;
    }
    NSString *query = @"";
    if ([value isKindOfClass:[NSString class]]) {
        query = [NSString stringWithFormat:@"&%@=%@", key, [NSURL smr_encodeURLStringWithString:value]];
    } else if ([value isKindOfClass:[NSArray class]]) {
        NSArray *objs = (NSArray *)value;
        for (id obj in objs) {
            NSString *pQuery = [self smr_URLParamWithKey:key value:obj];
            query = [query stringByAppendingString:pQuery];
        }
    } else {
        query = [NSString stringWithFormat:@"&%@=%@", key, value];
    }
    return query;
}

- (NSDictionary *)smr_parseredParams {
    NSString *urlQuery = self.query;
    if (urlQuery.length == 0) return nil;
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if ([urlQuery containsString:@"&"]) {
        NSArray *urlComponents = [urlQuery componentsSeparatedByString:@"&"];
        
        for (NSString *keyValuePair in urlComponents) {
            NSArray *pairComponents = [keyValuePair componentsSeparatedByString:@"="];
            if (pairComponents.count < 2) {
                continue;
            }
            NSString *key = [pairComponents[0] stringByRemovingPercentEncoding];
            NSString *value = [pairComponents[1] stringByRemovingPercentEncoding];
            
            if (key == nil || value == nil) {
                continue;
            }
            
            id existValue = [parameters valueForKey:key];
            if (existValue != nil) {
                if ([existValue isKindOfClass:[NSArray class]]) {
                    NSMutableArray *items = [NSMutableArray arrayWithArray:existValue];
                    [items addObject:value];
                    [parameters setValue:items forKey:key];
                } else {
                    [parameters setValue:@[existValue, value] forKey:key];
                }
            } else {
                [parameters setValue:value forKey:key];
            }
        }
    } else {
        NSArray *pairComponents = [urlQuery componentsSeparatedByString:@"="];
        if (pairComponents.count < 2) {
            return nil;
        }
        NSString *key = [pairComponents[0] stringByRemovingPercentEncoding];
        NSString *value = [pairComponents[1] stringByRemovingPercentEncoding];
        if (key == nil || value == nil) {
            return nil;
        }
        [parameters setValue:value forKey:key];
    }
    
    return [parameters copy];
}

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
