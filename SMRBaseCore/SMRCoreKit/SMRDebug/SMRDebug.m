//
//  SMRDebug.m
//  SMRDebugDemo
//
//  Created by 丁治文 on 2018/12/18.
//  Copyright © 2018 sumrise. All rights reserved.
//

#import "SMRDebug.h"
#import "SMRLogScreen.h"

@implementation SMRDebug

NSString * const _kDebugStatusForScreen = @"kDgStForSMRScreen";

+ (void)startDebugIfNeeded {
    BOOL status = [[NSUserDefaults standardUserDefaults] boolForKey:_kDebugStatusForScreen];
    if (status) {
        [SMRLogScreen show];
    } else {
        [SMRLogScreen hide];
    }
}

+ (BOOL)setDebugModelWithURL:(NSURL *)url allowScheme:(NSString *)allowScheme uk:(NSString *)uk {
    if (!url) {
        return NO;
    }
    if (allowScheme && ![allowScheme isEqualToString:url.scheme]) {
        return NO;
    }
    
    if ([@"debug" isEqualToString:url.host]) {
        NSDictionary *params = [self p_debug_parseredParamsWithURL:url];
        NSString *status = params[@"status"];
        NSString *puk = params[@"uk"];
        // 验证身份,如果代码中使用uk,则打开的链接中必须有uk且对应上才能打开.
        if (!uk || (uk && [uk isEqualToString:puk])) {
            [[NSUserDefaults standardUserDefaults] setBool:status.boolValue forKey:_kDebugStatusForScreen];
            [self startDebugIfNeeded];
        }
    }
    return YES;
}

+ (void)setDebug:(BOOL)debug {
    [[NSUserDefaults standardUserDefaults] setBool:debug forKey:_kDebugStatusForScreen];
    [self startDebugIfNeeded];
}

+ (NSDictionary *)p_debug_parseredParamsWithURL:(NSURL *)url {
    NSString *urlQuery = url.query;
    NSMutableDictionary *queryStringDictionary = [NSMutableDictionary dictionary];
    NSArray *urlComponents = [urlQuery componentsSeparatedByString:@"&"];
    for (NSString *keyValuePair in urlComponents) {
        NSArray *pairComponents = [keyValuePair componentsSeparatedByString:@"="];
        if (pairComponents.count >= 2) {
            NSString *key = [pairComponents objectAtIndex:0];
            NSString *value = [[pairComponents objectAtIndex:0] stringByRemovingPercentEncoding];
            [queryStringDictionary setObject:value forKey:key];
        }
    }
    NSDictionary *params = [NSDictionary dictionaryWithDictionary:queryStringDictionary];
    return params;
}

@end
