//
//  SMRUtils+Jump.h
//  SMRBaseCoreDemo
//
//  Created by 丁治文 on 2019/3/26.
//  Copyright © 2019 sumrise. All rights reserved.
//

#import "SMRUtils.h"

NS_ASSUME_NONNULL_BEGIN

@class SMRWebParameter;
@interface SMRUtils (Jump)

/**
 对所有URL的响应方法[推荐使用此方法]
 */
+ (void)jumpToAnyURL:(NSString *)url;
+ (void)jumpToAnyURL:(NSString *)url webParameter:(nullable SMRWebParameter *)webParameter;
+ (void)jumpToAnyURL:(NSString *)url webParameter:(nullable SMRWebParameter *)webParameter forceToApp:(BOOL)forceToApp;


/**
 对web URL的响应方法
 
 @param url web URL
 @param webParameter web需要的参数 如分享相关参数
 */
+ (void)jumpToWeb:(NSString *)url webParameter:(nullable SMRWebParameter*)webParameter;

/**
 是否为web的URL
 */
+ (BOOL)checkWebURL:(NSString *)url;

@end

NS_ASSUME_NONNULL_END
