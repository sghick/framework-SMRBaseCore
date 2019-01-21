//
//  SMRNetError.h
//  SMRNetworkDemo
//
//  Created by 丁治文 on 2018/10/29.
//  Copyright © 2018年 sumrise.com. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NSString * SMRNetErrorDomain NS_STRING_ENUM;
extern SMRNetErrorDomain const SMRNetSerivceErrorDomain;

typedef NS_ENUM(NSInteger, SMRErrorCode);

@interface SMRNetError : NSError

@property (copy  , nonatomic) id errorResponseObject;
@property (copy  , nonatomic, readonly) NSString *baseErrorDomain;

/**
 创建一个error
 */
+ (instancetype)smr_errorWithBaseError:(NSError *)baseError;
+ (instancetype)smr_errorWithBaseError:(NSError *)baseError code:(SMRErrorCode)code userInfo:(id)userInfo;

@end
