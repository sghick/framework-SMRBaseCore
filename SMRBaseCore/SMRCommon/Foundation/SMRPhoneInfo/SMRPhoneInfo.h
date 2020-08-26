//
//  SMRPhoneInfo.h
//  SMRBaseCoreDemo
//
//  Created by 丁治文 on 2019/1/2.
//  Copyright © 2019 sumrise. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 本类中的IDFA和IDFV都使用了KeyChain作为持久存储
 */
@interface SMRPhoneInfo : NSObject

/**
 存在keychain中的UUID
 */
+ (NSString *)originalUUID;

/**
 IDFA
 */
+ (NSString *)imeiString __deprecated_msg("已废弃");

/**
 IDFV
 与本账号下其它App进行沟通的标识
 [注意]对于运行在同一个设备，并且来自同一个供应商的所有App，这个值都是相同的。
 这个值首次执行app时会被保存在系统keychain中
 如果未获取到,将会返回一个随机生成的uuid,并且这个uuid将保存在系统keychain中
 */
+ (NSString *)imsiString __deprecated_msg("已废弃");

/**
 IDFA
 与其它厂商App进行沟通的标识
 需要用户打开广告追踪开关,并且需要为Apple提供使用原因
*/
+ (NSString *)IDFAString;

/**
 IDFV
 与本账号下其它App进行沟通的标识
 [注意]对于运行在同一个设备，并且来自同一个供应商的所有App，这个值都是相同的。
*/
+ (NSString *)IDFVString;

/**
 手机系统名称:Apple
 */
+ (NSString *)systemName;

/**
 获取手机系统版本
 */
+ (NSString *)systemVersionString;

/**
 获取手机型号,如: "iPhone10,2" 表示 "iPhone 8 Plus"
 */
+ (NSString *)machineString;

/**
 手机品牌:Apple
 */
+ (NSString *)phoneBrand;

/**
 网络运营商,CountryCode+NetworkCode
 */
+ (NSString *)netOperator;

/**
 web的UserAgent
 */
+ (void)webUserAgentForWK:(void (^)(NSString *ua))completion;

/**
 app的UserAgent
 */
+ (NSString *)appUserAgent;

@end

NS_ASSUME_NONNULL_END
