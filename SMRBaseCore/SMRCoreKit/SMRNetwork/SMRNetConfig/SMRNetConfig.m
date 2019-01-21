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
#import "SMRNetError.h"

@interface SMRNetConfig ()

@end

@implementation SMRNetConfig

- (void)configPrepare {
    
}

#pragma mark - SMRRequestDelegate

- (void)configRequestBeforeDataTask:(NSMutableURLRequest *)request api:(SMRNetAPI *)api {
    
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
    return [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(100, 400)];
}

- (SMRNetError *)validateServerErrorWithAPI:(SMRNetAPI *)api response:(NSURLResponse *)response responseObject:(id)responseObject error:(NSError *)error {
    if (!error) {
        return nil;
    }
    return [SMRNetError smr_errorWithBaseError:error];
}

- (id)responseObjectWithError:(NSError *)error {
    id data = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
    if (data && [data isKindOfClass:[NSData class]]) {
        id responseObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        return responseObject;
    } else {
        return nil;
    }
}

#pragma mark - SMRAPIRetryDelegate

- (BOOL)canRetryWhenRecivedError:(SMRNetError *)error api:(SMRNetAPI *)api {
    return YES;
}

#pragma mark - SMRAPIInitDelegate

- (SMRNetAPI *)shouldQueryInitAPIWithCurrentAPI:(SMRNetAPI *)currentAPI error:(SMRNetError *)error {
    return nil;
}

- (BOOL)apiInitSuccessed:(SMRNetAPI *)api response:(id)response {
    return YES;
}

- (void)apiInitFaild:(SMRNetError *)error {
    
}

#pragma mark - SMRNetIndicatorDelegate

- (BOOL)enableForStatuBarIndicator {
    return YES;
}

@end
