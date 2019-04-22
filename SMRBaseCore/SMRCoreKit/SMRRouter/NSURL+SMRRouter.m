//
//  NSURL+SMRRouter.m
//  SMRRouterDemo
//
//  Created by 丁治文 on 2018/10/3.
//  Copyright © 2018年 sumrise.com. All rights reserved.
//

#import "NSURL+SMRRouter.h"

@implementation NSURL (SMRRouter)

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

- (NSURL *)smr_URLByAppendParam:(NSString *)param value:(NSString *)value {
    if (!param || !value) {
        return self;
    }
    NSDictionary *params = [self smr_parseredParams];
    NSString *urlString = self.absoluteString;
    if (!params || (params.allKeys.count == 0)) {
        urlString = [urlString stringByAppendingString:@"?"];
    } else {
        urlString = [urlString stringByAppendingString:@"&"];
    }
    urlString = [urlString stringByAppendingFormat:@"%@=%@", param, [NSURL smr_encodeURLStringWithString:value]];
    NSURL *rtnUrl = [NSURL URLWithString:urlString];
    return rtnUrl;
}

- (NSDictionary *)smr_parseredParams {
    NSString *urlQuery = self.query;
    if (urlQuery.length == 0) return nil;
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if ([urlQuery containsString:@"&"]) {
        NSArray *urlComponents = [urlQuery componentsSeparatedByString:@"&"];
        
        for (NSString *keyValuePair in urlComponents) {
            NSArray *pairComponents = [keyValuePair componentsSeparatedByString:@"="];
            NSString *key = [pairComponents.firstObject stringByRemovingPercentEncoding];
            NSString *value = [pairComponents.lastObject stringByRemovingPercentEncoding];
            
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
        if (pairComponents.count == 1) {
            return nil;
        }
        
        NSString *key = [pairComponents.firstObject stringByRemovingPercentEncoding];
        NSString *value = [pairComponents.lastObject stringByRemovingPercentEncoding];
        
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
