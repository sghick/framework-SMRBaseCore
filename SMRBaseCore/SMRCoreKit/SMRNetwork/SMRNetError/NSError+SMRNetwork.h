//
//  NSError+SMRNetwork.h
//  SMRBaseCoreDemo
//
//  Created by 丁治文 on 2019/2/20.
//  Copyright © 2019 sumrise. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSError+SMRError.h"

FOUNDATION_EXPORT NSErrorDomain const SMRNetworkDomain;

NS_ASSUME_NONNULL_BEGIN

@interface NSError (SMRNetwork)

+ (instancetype)smr_errorForNetworkDomainWithCode:(NSInteger)code
                                           detail:(nullable NSString *)detail
                                          message:(nullable NSString *)message
                                         userInfo:(nullable NSDictionary<NSErrorUserInfoKey,id> *)dict;

@end

NS_ASSUME_NONNULL_END
