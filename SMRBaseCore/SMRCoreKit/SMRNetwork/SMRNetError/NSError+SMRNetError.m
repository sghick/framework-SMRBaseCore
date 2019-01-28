//
//  NSError+SMRNetError.m
//  SMRBaseCoreDemo
//
//  Created by 丁治文 on 2019/1/28.
//  Copyright © 2019 sumrise. All rights reserved.
//

#import "NSError+SMRNetError.h"

NSErrorDomain const SMRNetworkDomain = @"com.basecore.SMRNetworkDomain";

@implementation NSError (SMRNetwork)

+ (instancetype)smr_errorForNetworkDomainWithCode:(NSInteger)code
                                           detail:(nullable NSString *)detail
                                          message:(nullable NSString *)message
                                         userInfo:(nullable NSDictionary<NSErrorUserInfoKey,id> *)dict {
    return [self smr_errorWithDomain:SMRNetworkDomain code:code detail:detail message:message userInfo:dict];
}

@end
