//
//  NSError+SMRNetwork.h
//  SMRBaseCoreDemo
//
//  Created by 丁治文 on 2019/2/20.
//  Copyright © 2019 sumrise. All rights reserved.
//

#import "NSError+BaseCore.h"

NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXPORT NSErrorDomain const SMRNetworkDomain;

@interface NSError (SMRNetwork)

+ (instancetype)smr_errorForNetworkDomainWithCode:(NSInteger)code
                                           detail:(nullable NSString *)detail
                                          message:(nullable NSString *)message
                                         userInfo:(nullable NSDictionary<NSErrorUserInfoKey,id> *)dict;

@end

NS_ASSUME_NONNULL_END
