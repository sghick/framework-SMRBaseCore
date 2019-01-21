//
//  SMRNetError.m
//  SMRNetworkDemo
//
//  Created by 丁治文 on 2018/10/29.
//  Copyright © 2018年 sumrise.com. All rights reserved.
//

#import "SMRNetError.h"

SMRNetErrorDomain const SMRNetErrorDomainSerivceError = @"SMRNetErrorDomainSerivceError";

@implementation SMRNetError

@synthesize baseErrorDomain = _baseErrorDomain;
@synthesize errorResponseObject = _errorResponseObject;

- (void)setBaseErrorDomain:(NSString *)baseErrorDomain {
    _baseErrorDomain = baseErrorDomain;
}

- (void)setErrorResponseObject:(id)errorResponseObject {
    _errorResponseObject = errorResponseObject;
}

- (NSString *)description {
    NSString *body = [NSString stringWithFormat:@"error:{\n\tBase Error Domain=%@\n\tError Object=%@\n\t%@\n\t}", self.baseErrorDomain, self.errorResponseObject, [super description]];
    return body;
}

#pragma mark - Errors

+ (instancetype)smr_errorWithBaseError:(NSError *)baseError {
    SMRNetError *error = [SMRNetError smr_errorWithBaseError:baseError code:baseError.code userInfo:baseError.userInfo];
    return error;
}

+ (instancetype)smr_errorWithBaseError:(NSError *)baseError code:(SMRErrorCode)code userInfo:(id)userInfo {
    SMRNetError *error = [SMRNetError errorWithDomain:SMRNetErrorDomainSerivceError code:code userInfo:userInfo];
    error.baseErrorDomain = baseError.domain;
    return error;
}

@end
