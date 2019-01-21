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
    NSURL *url = [NSURL URLWithString:[self smr_encodeURLQueryStringWithString:string]];
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
    NSMutableDictionary *queryStringDictionary = [NSMutableDictionary dictionary];
    NSArray *urlComponents = [urlQuery componentsSeparatedByString:@"&"];
    for (NSString *keyValuePair in urlComponents) {
        NSArray *pairComponents = [keyValuePair componentsSeparatedByString:@"="];
        if (pairComponents.count >= 2) {
            NSString *key = [pairComponents objectAtIndex:0];
            NSString *value = [NSURL smr_decodeURLStringWithString:[pairComponents objectAtIndex:1]];
            [queryStringDictionary setObject:value forKey:key];
        }
    }
    NSDictionary *params = [NSDictionary dictionaryWithDictionary:queryStringDictionary];
    return params;
}

@end
