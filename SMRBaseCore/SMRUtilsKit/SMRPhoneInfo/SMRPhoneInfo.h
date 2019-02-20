//
//  SMRPhoneInfo.h
//  SMRBaseCoreDemo
//
//  Created by 丁治文 on 2019/1/21.
//  Copyright © 2019 sumrise. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 本类中的IDFA和IDFV都使用了KeyChain作为持久存储
 */
@interface SMRPhoneInfo : NSObject

/**
 IDFA
 需要用户打开广告追踪开关,并且需要为Apple提供使用原因
 如果未获取到,将会返回一个随机生成的uuid,并且这个uuid将保存在系统keychain中
 */
+ (NSString *)imeiString;

/**
 IDFV
 [注意]对于运行在同一个设备，并且来自同一个供应商的所有App，这个值都是相同的。
 这个值首次执行app时会被保存在系统keychain中
 如果未获取到,将会返回一个随机生成的uuid,并且这个uuid将保存在系统keychain中
 */
+ (NSString *)imsiString;

/**
 手机系统名称:iOS
 */
+ (NSString *)systemName;

/**
 获取手机系统版本
 */
+ (NSString *)systemVersionString;

#warning Check: 推荐由后台进行识别,发新版本后,客户端需要配合后台更新对应的列表.
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
+ (NSString *)webUserAgent;

@end

NS_ASSUME_NONNULL_END
