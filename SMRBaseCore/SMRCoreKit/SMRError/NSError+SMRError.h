//
//  NSError+SMRError.h
//  SMRBaseCoreDemo
//
//  Created by 丁治文 on 2019/1/28.
//  Copyright © 2019 sumrise. All rights reserved.
//

#import <Foundation/Foundation.h>

FOUNDATION_EXPORT NSErrorUserInfoKey const kErrorUserInfoDetail;
FOUNDATION_EXPORT NSErrorUserInfoKey const kErrorUserInfoMessage;

NS_ASSUME_NONNULL_BEGIN

@interface NSError (SMRError)

+ (instancetype)smr_errorWithDomain:(NSErrorDomain)domain
                               code:(NSInteger)code
                           userInfo:(NSDictionary<NSErrorUserInfoKey,id> *)dict;

+ (instancetype)smr_errorWithDomain:(NSErrorDomain)domain
                               code:(NSInteger)code
                             detail:(nullable NSString *)detail
                            message:(nullable NSString *)message
                           userInfo:(nullable NSDictionary<NSErrorUserInfoKey,id> *)dict;

- (nullable NSString *)smr_detail;
- (nullable NSString *)smr_message;

@end

NS_ASSUME_NONNULL_END
