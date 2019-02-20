//
//  SMRUtils+Version.h
//  SMRBaseCoreDemo
//
//  Created by 丁治文 on 2019/2/20.
//  Copyright © 2019 sumrise. All rights reserved.
//

#import "SMRUtils.h"

NS_ASSUME_NONNULL_BEGIN

@interface SMRUtils (Version)

/** 比较2个版本号的大小,忽略build号 */
+ (NSComparisonResult)compareVersion:(NSString *)version toVersion:(NSString *)toVersion;

/** 比较2个版本号的大小,可包括build号 */
+ (NSComparisonResult)compareVersion:(NSString *)version toVersion:(NSString *)toVersion buildNumber:(BOOL)buildNumber;

/** 将版本号转换成整数,忽略build号 */
+ (int32_t)convertToCodeWithVersion:(NSString *)version;

/** 将版本号转换成整数,可包括build号 */
+ (int32_t)convertToCodeWithVersion:(NSString *)version buildNumber:(BOOL)buildNumber;

@end

NS_ASSUME_NONNULL_END
