//
//  SMRRankerLifecycleManager.h
//  SMRRankerDemo
//
//  Created by 丁治文 on 2018/7/28.
//  Copyright © 2018年 sumrise.com. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, SMRRankerLifecycle) {
    SMRRankerLifecycleLaunch           = 0,    // 每次启动为一周期
    SMRRankerLifecycleVersion          = 1,    // 每个版本为一周期
    SMRRankerLifecycleInstall          = 2,    // 每次安装为一周期
    SMRRankerLifecycleCustomTime       = 3,    // 自定义时间为一周期
};

@interface SMRRankerLifecycleManager : NSObject

@property (strong, nonatomic, readonly) NSString *launchUUID;       ///< 当前启动标识
@property (strong, nonatomic, readonly) NSString *version;          ///< app版本号
@property (strong, nonatomic, readonly) NSString *installUUID;      ///< 当前安装标识

+ (instancetype)shareInstance;

/**
 检查identifier在某生命周期中是否超过checkcount值
 
 @param lifecycle 指定生命周期类型
 @param checkcount 最大检查值,-1表示不限
 @param identifier 唯一标识
 @return YES:在生命周期指定值内;NO:不在指定值内
 */
+ (BOOL)checkIfWithinLifecycle:(SMRRankerLifecycle)lifecycle
                    checkcount:(NSInteger)checkcount
                withIdentifier:(NSString *)identifier;

/**
 检查identifier在某生命周期中是否超过checkcount值
 
 @param timerinterval 具体周期(s)
 @param checkcount 最大检查值,-1表示不限
 @param identifier 唯一标识
 @return YES:在生命周期指定值内;NO:不在指定值内
 */
+ (BOOL)checkIfWithinTimerinterval:(NSTimeInterval)timerinterval
                        checkcount:(NSInteger)checkcount
                    withIdentifier:(NSString *)identifier;

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
