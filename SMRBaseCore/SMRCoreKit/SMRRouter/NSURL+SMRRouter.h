//
//  NSURL+SMRRouter.h
//  SMRRouterDemo
//
//  Created by 丁治文 on 2018/10/3.
//  Copyright © 2018年 sumrise.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURL (SMRRouter)

/// 通过字符串创建一个正确格式的URL,自动去除空格
+ (NSURL *)smr_URLWithString:(NSString *)string;
/// query部分encode
+ (NSString *)smr_encodeURLQueryStringWithString:(NSString *)string;
/// all encode,包括 '&','='
+ (NSString *)smr_encodeURLStringWithString:(NSString *)string;
/// decode
+ (NSString *)smr_decodeURLStringWithString:(NSString *)string;

/// 拼接url参数
- (NSURL *)smr_URLByAppendParam:(NSString *)param value:(NSString *)value;
/// 获取url参数
- (NSDictionary *)smr_parseredParams;

/// 获取一个数据类型的参数
+ (NSArray *)smr_buildArrayTypeWithParam:(id)param;
/// 获取一个 数字或者字符串 类型的参数
+ (id)smr_buildInstanceTypeWithParam:(id)param;

@end
