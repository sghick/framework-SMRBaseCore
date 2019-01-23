//
//  SMRRankerManager.h
//  SMRRankerDemo
//
//  Created by 丁治文 on 2018/7/28.
//  Copyright © 2018年 sumrise.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SMRRankerConfig.h"
#import "SMRRankerLogDelegate.h"

////////////////////////////////////////////////////
//              SMRRankerManager
////////////////////////////////////////////////////

typedef void (^SMRActionSettingBlock)(SMRRankerAction *action);
typedef NS_ENUM(NSInteger, SMRRankerActionStatus);

@interface SMRRankerManager : NSObject

@property (copy  , nonatomic, readonly) NSString *groupId;

@property (assign, nonatomic) BOOL isEnable;///< default:YES,管理器可以用

/**
 配置,默认为defaultConfig
 */
@property (strong, nonatomic) id<SMRRankerConfig> config;

/// 日志输出代理
@property (strong, nonatomic) id<SMRRankerLogDelegate> logDelegate;

- (instancetype)init;
- (instancetype)initWithConfig:(id<SMRRankerConfig>)config;
- (instancetype)initWithGroupId:(NSString *)groupId;
- (instancetype)initWithGroupId:(NSString *)groupId config:(id<SMRRankerConfig>)config;///< 推荐使用

/**
 主动检测是否需要执行业务
 */
- (void)checkNeedsPop;

/**
 取出执行业务项目
 
 @param identifier 项目标识
 @return 执行业务项目
 */
- (SMRRankerAction *)actionWithIdentifier:(NSString *)identifier;

/**
 清除WCPopAction的生命周期记录
 */
- (void)clearLifecycleWithIdentifier:(NSString *)identifier;
- (void)clearLifecycleWithAction:(SMRRankerAction *)action;

/**
 注册执行业务项目
 
 @param identifier 项目标识(必填)
 @param settingBlock 设置初始参数
 return 注册成功返回YES
 */
- (BOOL)registActionWithIdentifier:(NSString *)identifier settingBlock:(SMRActionSettingBlock)settingBlock;
- (BOOL)registActionWithIdentifier:(NSString *)identifier;

/**
 注销
 */
- (void)unregistActionWithIdentifier:(NSString *)identifier;
- (void)unregistAllActions;

/**
 标记对应的actions生效
 */
- (void)enalbelActionsWithIdentifiers:(NSArray *)idnetifiers;

/**
 标记对应的actions暂时失效
 */
- (void)dialbelActionsWithIdentifiers:(NSArray *)idnetifiers;

/**
 标记执行业务项目可以执行业务,未标记的action不执行
 [注意]在注册后有效
 @param identifier 项目标识
 @param completionBlock 执行业务操作
 */
- (void)markActionReadyWithIdentifier:(NSString *)identifier completionBlock:(void(^)(SMRRankerAction *))completionBlock;
- (void)markActionReadyWithIdentifier:(NSString *)identifier;

/**
 增加执行业务操作
 [注意]在注册后有效
 @param identifier 项目标识
 @param completionBlock 执行业务操作
 */
- (void)setActionWithIdentifier:(NSString *)identifier completionBlock:(void(^)(SMRRankerAction *))completionBlock;

/**
 标记执行业务项目取消,取消标记的action不再执行
 [注意]在注册后有效
 @param identifier 项目标识
 */
- (void)markActionCancelWithIdentifier:(NSString *)identifier;

/**
 标记执行业务项目开始进入执行业务排队,未进入排队的action,且会等待所有action为ready的进入排队再执行action
 [注意]在注册后有效
 @param identifier 项目标识
 */
- (void)markActionBeginWithIdentifier:(NSString *)identifier;

/**
 标记执行业务项目失败,且当前action不再执行
 [注意]在注册后有效
 @param identifier 项目标识
 */
- (void)markActionFaildWithIdentifier:(NSString *)identifier;

/**
 标记执行业务项目关闭/结束,action不再执行
 [注意]在注册后有效
 @param identifier 项目标识
 */
- (void)markActionCloseWithIdentifier:(NSString *)identifier;

@end


////////////////////////////////////////////////////
//              SMRGlobalRankerManager
////////////////////////////////////////////////////

@interface SMRGlobalRankerManager : NSObject

+ (instancetype)shareInstance;

+ (void)addManger:(SMRRankerManager *)manager;
+ (SMRRankerManager *)managerWithGroupId:(NSString *)groupId;
+ (SMRRankerManager *)managerWithGroupId:(NSString *)groupId autoCreateWithConfig:(id<SMRRankerConfig>)config;

@end
