//
//  SMRNetConfig.m
//  SMRNetworkDemo
//
//  Created by 丁治文 on 2018/12/18.
//  Copyright © 2018 sumrise. All rights reserved.
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

- (NSInteger)maxCountForDedounce {
    return -1;
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

#pragma mark - SMRAPIRetryDelegate

- (BOOL)canRetryWhenRecivedError:(NSError *)error api:(SMRNetAPI *)api {
    return YES;
}

- (SMRNetAPI *)canQueryNewAPIAndRetryWhenRecivedError:(NSError *)error api:(SMRNetAPI *)api {
    return nil;
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
