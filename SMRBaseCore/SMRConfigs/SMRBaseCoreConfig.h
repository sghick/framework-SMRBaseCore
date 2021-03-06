//
//  SMRBaseCoreConfig.h
//  SMRBaseCoreDemo
//
//  Created by 丁治文 on 2019/5/6.
//  Copyright © 2019 sumrise. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SMRBaseCore.h"

NS_ASSUME_NONNULL_BEGIN

/**
 BaseCore的所有配置项
 */
@interface SMRBaseCoreConfig : NSObject

#pragma mark - BaseCore部分

/** 路由配置 */
@property (strong, nonatomic) SMRRouterConfig *routerConfig;
/** 网络配置 */
@property (strong, nonatomic) SMRNetConfig *netConfig;
@property (strong, nonatomic) SMRSession *session;
/** Web配置 */
@property (strong, nonatomic) id<SMRWebReplaceConfig> webReplaceConfig;
/** Web导航条UI配置 */
@property (strong, nonatomic) id<SMRWebNavigationViewConfig> webNavigationViewConfig;
/** WebJS配置 */
@property (strong, nonatomic) id<SMRWebJSRegisterConfig> webJSRegisterConfig;

/** 数据库名,无则不使用(创建)数据库 */
@property (strong, nonatomic) NSString *dbName;
/** 数据库版本号, 默认0 */
@property (assign, nonatomic) double dbVersion;

#pragma mark - BaseUI部分

/** 设置NavigationView全局默认属性的block */
@property (nonatomic, copy  ) NavigationViewAppearanceBlock appearanceBlock;

/** 设置AlertView全局默认属性的style,默认black */
@property (assign, nonatomic) SMRAlertViewStyle alertViewStyle __deprecated_msg("废弃,使用+[SMRAlertView initialConfig]");
@property (strong, nonatomic) UIColor *alertTitleColor __deprecated_msg("废弃,使用+[SMRAlertView initialConfig]");

#pragma mark - BaseUtils部分

@property (strong, nonatomic) id<SMRUpdateStatusManagerConfig> updateStatusManagerConfig;

/** 单例 */
+ (instancetype)sharedInstance;

/** 配置初始化,使用BaseCore前必须调用的方法,且重复调用无效,推荐在AppDelegate中最早的位置处调用 */
- (void)configInitialization;

@end

NS_ASSUME_NONNULL_END
