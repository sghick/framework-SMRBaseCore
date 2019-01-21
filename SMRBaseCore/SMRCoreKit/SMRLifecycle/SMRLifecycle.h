//
//  SMRLifecycle.h
//  SMRLifecycleDemo
//
//  Created by 丁治文 on 2018/7/17.
//  Copyright © 2018年 sumrise.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SMRLifecycleLogDelegate.h"

typedef NS_ENUM(NSInteger, SMRLifecycleType) {
    SMRLifecycleTypeLaunch           = 0,    // 每次启动为一周期
    SMRLifecycleTypeVersion          = 1,    // 每个版本为一周期
    SMRLifecycleTypeCustomVersion    = 2,    // 每个自定义版本号为一周期
    SMRLifecycleTypeInstall          = 3,    // 每次安装为一周期
};

@interface SMRLifecycle : NSObject

@property (nonatomic, assign) BOOL isFirstLaunchForInstall;             ///< 是否为首次安装的第一次启动,默认YES
@property (nonatomic, assign, readonly) BOOL isFirstLaunchForVersion;   ///< 是否为当前版本的第一次启动,默认YES
@property (nonatomic, assign, readonly) NSTimeInterval firstLaunchTime; ///< 每次启动的时间

@property (nonatomic, strong, readonly) NSString *launchUUID;       ///< 当前启动标识
@property (nonatomic, strong, readonly) NSString *version;          ///< app版本号
@property (nonatomic, strong, readonly) NSString *customVersion;    ///< 自定义版本号
@property (nonatomic, strong, readonly) NSString *installUUID;      ///< 当前安装标识

/// 获取一个单例对象
+ (instancetype)shareInstance;

/// 设置接收log的代理
- (void)cacheLog:(id<SMRLifecycleLogDelegate>)delegate;

/// 在appDelegate的启动方法中设置,每次最多能生效一次
+ (void)setAppLaunch; ///<默认使用当前target的版本号
+ (void)setAppLaunchWithVersion:(NSString *)version;
+ (void)setAppLaunchWithVersion:(NSString *)version customVersion:(NSString *)customVersion;

/**
 检查identifier在某生命周期中是否超过checkcount值
 
 @param lifecycleType 指定生命周期类型
 @param checkcount 最大检查值,-1表示不限
 @param identifier 唯一标识
 @return YES:在生命周期指定值内;NO:不在指定值内
 */
+ (BOOL)checkIfWithinLifecycleType:(SMRLifecycleType)lifecycleType checkcount:(NSInteger)checkcount withIdentifier:(NSString *)identifier;

/**
 检查identifier在某生命周期中是否超过checkcount值
 
 @param timerinterval 具体周期(s)
 @param checkcount 最大检查值,-1表示不限
 @param identifier 唯一标识
 @return YES:在生命周期指定值内;NO:不在指定值内
 */
+ (BOOL)checkIfWithinTimerinterval:(NSTimeInterval)timerinterval checkcount:(NSInteger)checkcount withIdentifier:(NSString *)identifier;

/**
 标记identifier成功检查一次
 @param identifier 唯一标识
 */
+ (void)markSuccessCheckWithIdentifier:(NSString *)identifier;

/**
 清除identifier的生命周期记录
 
 @param identifier 唯一标识
 */
+ (void)clearLifecycleWithIdentifier:(NSString *)identifier;

@end
