//
//  SMRUtils+Validate.h
//  SMRBaseCoreDemo
//
//  Created by 丁治文 on 2019/2/14.
//  Copyright © 2019 sumrise. All rights reserved.
//

#import "SMRUtils.h"

NS_ASSUME_NONNULL_BEGIN

/// +[validateString:regex:]方法中的regex参数
extern NSString * const SMRValidateFormatRealName;      ///< 姓名（只能中文和英文）
extern NSString * const SMRValidateFormatAccount;       ///< 账号(1-20个字母和数字组合)
extern NSString * const SMRValidateFormatPassword;      ///< 密码(1-20个字母和数字组合)
extern NSString * const SMRValidateFormatPhoneNumber;   ///< 手机号
extern NSString * const SMRValidateFormatEmail;         ///< 邮箱
extern NSString * const SMRValidateFormatNumber4;       ///< 4位纯数字
extern NSString * const SMRValidateFormatNumber6;       ///< 6位纯数字

/**
 正则表达式:http://www.runoob.com/regexp/regexp-syntax.html
 */
@interface SMRUtils (Validate)

/**
 使用正则获取第一个正确匹配到的第一个结果,支持匹配group,返回数组中第1个为完整结果,之后的为group中的子结果,获取失败返回nil
 */
+ (NSArray<NSString *> *)matchFirstGroupsInString:(NSString *)content regex:(NSString *)regex;

/**
 使用正则获取正确匹配到的所有结果,支持匹配group,返回数组中第1个为完整结果,之后的为group中的子结果,获取失败返回nil
 */
+ (NSArray<NSArray<NSString *> *> *)matchGroupsInString:(NSString *)content regex:(NSString *)regex;

/**
 系统自带的谓词匹配
 
 @param validateString 待匹配的字符串
 @param predicateFormat 谓词
 1.比较运算符>,<,==,>=,<=,!=
 2.范围运算符：IN、BETWEEN
 3.字符串本身:SELF
 4.字符串相关：BEGINSWITH、ENDSWITH、CONTAINS
 5.通配符：LIKE
 6.正则表达式：MATCHES
 @param regex 正则表达式
 @return 验证结果
 */
+ (BOOL)validateString:(NSString *)validateString predicateFormat:(NSString *)predicateFormat regex:(NSString *)regex;

/** 使用字符串验证 */
+ (BOOL)validateString:(NSString *)validateString regex:(NSString *)regex;

/** 使用正则表达式类验证 */
+ (BOOL)validateString:(NSString *)validateString options:(NSRegularExpressionOptions)options regex:(NSString *)regex;

/** 验证身份证号(支持15位和18位) */
+ (BOOL)validateIdWithString:(NSString *)string;

@end

NS_ASSUME_NONNULL_END
