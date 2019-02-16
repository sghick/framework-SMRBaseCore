//
//  SMRUtils+Validate.h
//  SMRBaseCoreDemo
//
//  Created by 丁治文 on 2019/2/14.
//  Copyright © 2019 sumrise. All rights reserved.
//

#import "SMRUtils.h"

NS_ASSUME_NONNULL_BEGIN

/**
 正则表达式:http://www.runoob.com/regexp/regexp-syntax.html
 */
@interface SMRUtils (Validate)

/**
 使用正则获取第一个正确匹配到的结果,支付匹配group
 */
+ (NSArray<NSString *> *)matchFirstGroupsInString:(NSString *)content regex:(NSString *)regex;

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

/** 验证姓名（只能中文和英文）*/
+ (BOOL)validateName:(NSString *)string;

@end

NS_ASSUME_NONNULL_END
