//
//  NSError+BaseCore.m
//  SMRBaseCoreDemo
//
//  Created by 丁治文 on 2019/1/24.
//  Copyright © 2019 sumrise. All rights reserved.
//

#import "NSError+BaseCore.h"

NSErrorUserInfoKey const kErrorUserInfoDetail = @"kSMRErrorUserInfoDetail";
NSErrorUserInfoKey const kErrorUserInfoMessage = @"kSMRErrorUserInfoMessage";;

@implementation NSError (BaseCore)

+ (instancetype)smr_errorWithDomain:(NSErrorDomain)domain
                               code:(NSInteger)code
                           userInfo:(NSDictionary<NSErrorUserInfoKey,id> *)dict {
    return [NSError errorWithDomain:domain code:code userInfo:dict];
}

+ (instancetype)smr_errorWithDomain:(NSErrorDomain)domain
                               code:(NSInteger)code
                             detail:(nullable NSString *)detail
                            message:(nullable NSString *)message
                           userInfo:(nullable NSDictionary<NSErrorUserInfoKey,id> *)dict {
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithDictionary:dict];
    userInfo[kErrorUserInfoDetail] = detail;
    userInfo[kErrorUserInfoMessage] = message;
    return [NSError errorWithDomain:domain code:code userInfo:[userInfo copy]];
}

+ (instancetype)smr_error:(NSError *)error underlyingError:(NSError *)underlyingError {
    if (!error) {
        return underlyingError;
    }

    if (!underlyingError || error.userInfo[NSUnderlyingErrorKey]) {
        return error;
    }

    NSMutableDictionary *mutableUserInfo = [error.userInfo mutableCopy];
    mutableUserInfo[NSUnderlyingErrorKey] = underlyingError;

    return [[NSError alloc] initWithDomain:error.domain code:error.code userInfo:mutableUserInfo];
}

- (nullable NSString *)smr_detail {
    return self.userInfo[kErrorUserInfoDetail];
}
- (nullable NSString *)smr_message {
    return self.userInfo[kErrorUserInfoMessage];
}

@end
