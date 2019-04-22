//
//  SMRNetConfig.m
//  SMRNetworkDemo
//
//  Created by 丁治文 on 2018/10/6.
//  Copyright © 2018年 sumrise.com. All rights reserved.
//

#import "SMRNetConfig.h"
#import "AFHTTPSessionManager.h"
#import "AFNetworkActivityIndicatorManager.h"
#import "SMRNetAPI.h"
#import "NSError+SMRNetwork.h"

@interface SMRNetConfig ()

@end

@implementation SMRNetConfig

- (void)configPrepare {
    
}

#pragma mark - SMRRequestDelegate

- (NSSet *)HTTPMethodsEncodingParametersInURI {
    return [NSSet setWithObjects:@"GET", @"HEAD", @"DELETE", nil];
}

- (void)configRequestBeforeDataTask:(NSMutableURLRequest *)request api:(SMRNetAPI *)api {
    
}

- (NSTimeInterval)timerIntervalForDedounce {
    return 1.0;
}

- (NSInteger)maxCountForDedounce {
    return 1;
}

- (NSTimeInterval)invalidateDuration {
    return 60;
}

#pragma mark - SMRResponseDelegate

- (NSSet *)setForAcceptableContentTypes {
    NSArray *acceptableContentTypes = @[
                                        @"text/javascript",
                                        @"application/json",
                                        @"text/json",
                                        @"text/plain",
                                        @"text/html",
                                        ];
    return [NSSet setWithArray:acceptableContentTypes];
}

- (NSIndexSet *)setForAcceptableStatusCodes {
    return [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(100, 300)];
}

- (NSError *)validateServerErrorWithAPI:(SMRNetAPI *)api response:(NSURLResponse *)response responseObject:(id)responseObject error:(NSError *)error {
    if (!error) {
        return nil;
    }
    NSError *err = [NSError smr_errorForNetworkDomainWithCode:((NSString *)responseObject[@"code"]).integerValue
                                                       detail:responseObject[@"detail"]
                                                      message:responseObject[@"message"]
                                                     userInfo:error.userInfo];
    return err;
}

- (id)responseObjectWithError:(NSError *)error {
    id data = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
    if (data && [data isKindOfClass:[NSData class]]) {
        id responseObject = nil;
        if ([NSJSONSerialization isValidJSONObject:data]) {
            responseObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        } else {
            responseObject = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        }
        return responseObject;
    } else {
        return nil;
    }
}

#pragma mark - SMRAPIRetryDelegate

- (BOOL)canRetryWhenRecivedError:(NSError *)error api:(SMRNetAPI *)api {
    return YES;
}

#pragma mark - SMRAPIInitDelegate

- (SMRNetAPI *)apiForInitialization {
    return nil;
}

- (BOOL)canQueryInitAPIWhenRecivedError:(NSError *)error currentAPI:(SMRNetAPI *)currentAPI {
    return NO;
}

- (BOOL)apiInitSuccessed:(SMRNetAPI *)api response:(id)response {
    return YES;
}

- (void)apiInitFaild:(NSError *)error {
    
}

#pragma mark - SMRNetIndicatorDelegate

- (BOOL)enableForStatuBarIndicator {
    return YES;
}

#pragma mark - SMRNetworkReachabilityDelegate

- (BOOL)enableNetworkReachability {
    return YES;
}

- (void)didChangedNetworkWithWithStatus:(SMRNetworkReachabilityStatus)status {
    
}

@end
