//
//  SMRUtils+Jump.h
//  SMRBaseCoreDemo
//
//  Created by 丁治文 on 2019/3/26.
//  Copyright © 2019 sumrise. All rights reserved.
//

#import "SMRUtils.h"

NS_ASSUME_NONNULL_BEGIN

@interface SMRUtils (Jump)

/**
 对所有URL的响应方法[推荐使用此方法]
 */
+ (void)jumpToAnyURL:(NSString *)url;
+ (void)jumpToAnyURL:(NSString *)url webTitle:(nullable NSString *)webTitle forceToApp:(BOOL)forceToApp;

/**
 对web URL的响应方法
 */
+ (void)jumpToWeb:(NSString *)url title:(nullable NSString *)title;

/**
 是否为web的URL
 */
+ (BOOL)checkWebURL:(NSString *)url;

@end

NS_ASSUME_NONNULL_END
