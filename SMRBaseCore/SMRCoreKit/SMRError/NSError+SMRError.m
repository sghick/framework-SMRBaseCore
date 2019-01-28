//
//  NSError+SMRError.m
//  SMRBaseCoreDemo
//
//  Created by 丁治文 on 2019/1/28.
//  Copyright © 2019 sumrise. All rights reserved.
//

#import "NSError+SMRError.h"

NSErrorUserInfoKey const kErrorUserInfoDetail = @"kSMRErrorUserInfoDetail";
NSErrorUserInfoKey const kErrorUserInfoMessage = @"kSMRErrorUserInfoMessage";;

@implementation NSError (SMRError)

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

- (nullable NSString *)smr_detail {
    return self.userInfo[kErrorUserInfoDetail];
}
- (nullable NSString *)smr_message {
    return self.userInfo[kErrorUserInfoMessage];
}

@end
