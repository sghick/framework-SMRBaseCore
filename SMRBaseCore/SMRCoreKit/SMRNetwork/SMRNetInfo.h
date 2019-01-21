//
//  SMRNetInfo.h
//  SMRBaseCoreDemo
//
//  Created by 丁治文 on 2019/1/21.
//  Copyright © 2019 sumrise. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SMRNetInfo : NSObject

/**
 同步NetInfo中的所有信息
 */
+ (void)syncNetInfoWithResponse:(NSHTTPURLResponse *)response;

/**
 服务器时间
 */
+ (void)syncDateWithServerDate:(NSDate *)serverDate;
+ (NSDate *)syncedDate;

/**
 rfc时间
 */
+ (NSDate *)dateFromRFC1123:(NSString *)value;
+ (NSString *)rfc1123StringWithDate:(NSDate *)date;

/**
 Cookie
 */
+ (NSString *)getCookie;
+ (void)setCookie:(NSString *)cookie;

/**
 Session
 */
+ (NSString *)getSession;
+ (void)setSession:(NSString *)session;

@end

NS_ASSUME_NONNULL_END
