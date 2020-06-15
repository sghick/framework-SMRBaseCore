//
//  NSError+SMRError.h
//  SMRBaseCoreDemo
//
//  Created by 丁治文 on 2019/1/28.
//  Copyright © 2019 sumrise. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXPORT NSErrorUserInfoKey const kErrorUserInfoDetail;
FOUNDATION_EXPORT NSErrorUserInfoKey const kErrorUserInfoMessage;

@interface NSError (BaseCore)

+ (instancetype)smr_errorWithDomain:(NSErrorDomain)domain
                               code:(NSInteger)code
                           userInfo:(NSDictionary<NSErrorUserInfoKey,id> *)dict;

+ (instancetype)smr_errorWithDomain:(NSErrorDomain)domain
                               code:(NSInteger)code
                             detail:(nullable NSString *)detail
                            message:(nullable NSString *)message
                           userInfo:(nullable NSDictionary<NSErrorUserInfoKey,id> *)dict;

+ (instancetype)smr_error:(NSError *)error underlyingError:(NSError *)underlyingError;

- (nullable NSString *)smr_detail;
- (nullable NSString *)smr_message;

@end

NS_ASSUME_NONNULL_END
