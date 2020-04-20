//
//  NSError+SMRNetwork.m
//  SMRBaseCoreDemo
//
//  Created by 丁治文 on 2019/2/20.
//  Copyright © 2019 sumrise. All rights reserved.
//

#import "NSError+SMRNetwork.h"

NSErrorDomain const BDSNetworkDomain = @"com.basecore.BDSNetworkDomain";

@implementation NSError (SMRNetwork)

+ (instancetype)smr_errorForNetworkDomainWithCode:(NSInteger)code
                                           detail:(nullable NSString *)detail
                                          message:(nullable NSString *)message
                                         userInfo:(nullable NSDictionary<NSErrorUserInfoKey,id> *)dict {
    return [self smr_errorWithDomain:BDSNetworkDomain code:code detail:detail message:message userInfo:dict];
}

@end
