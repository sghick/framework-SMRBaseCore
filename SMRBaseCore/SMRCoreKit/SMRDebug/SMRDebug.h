//
//  SMRDebug.h
//  SMRDebugDemo
//
//  Created by 丁治文 on 2018/12/18.
//  Copyright © 2018 sumrise. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SMRLogSys.h"
#import "SMRLogScreen.h"

@interface SMRDebug : NSObject

/**
 判断是否开启调试模式
 */
+ (void)startDebugIfNeeded;

/**
 使用URL设置调试模式
 
 @param url scheme://host?ck=<时效令牌>&uk=<身份识别码>&ctype=<模式:screen/log/flex>&status=<状态:0/1>
 @param allowScheme 允许打开的scheme
 @return 进入调试模式,返回YES
 */
+ (BOOL)setDebugModelWithURL:(NSURL *)url allowScheme:(NSString *)allowScheme uk:(NSString *)uk;

/**
 直接打开/关闭调试模式
 */
+ (void)setDebug:(BOOL)debug;

/**
 生成令牌
 */
+ (NSString *)createCheckCodeWithKey:(NSString *)key date:(NSDate *)date;

@end
