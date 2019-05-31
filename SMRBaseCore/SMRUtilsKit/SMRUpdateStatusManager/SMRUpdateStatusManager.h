//
//  SMRUpdateStatusManager.h
//  SMRBaseCoreDemo
//
//  Created by 丁治文 on 2019/5/31.
//  Copyright © 2019 sumrise. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SMRUpdateStatus : NSObject

@property (copy  , nonatomic) NSString *key;
@property (assign, nonatomic) NSTimeInterval updateTime;

@property (assign, nonatomic) NSInteger type;
@property (assign, nonatomic) NSInteger count;
@property (copy  , nonatomic) NSString *text;
@property (strong, nonatomic) NSDictionary *userInfo;

@property (assign, nonatomic) BOOL hasNew;
@property (assign, nonatomic) BOOL hasMainNew;

@end

typedef NS_ENUM(NSInteger,kUpdateStatusType) {
    kUpdateStatusTypeNotSave, /** 没有缓存 */
    kUpdateStatusTypeNormal,  /** 没有被选中，没有被点击，没有出现过... */
    kUpdateStatusTypeSelected /** 已经被选中，已经被点击，已经出现过... */
};

@protocol SMRUpdateStatusManagerConfig <NSObject>

- (NSString *)userName;

@end

@interface SMRUpdateStatusManager : NSObject

/** 保证用户名发生变化时实时更新 */
@property (copy  , nonatomic) NSString *userName;

#pragma mark - Based Use

+ (instancetype)sharedManager;

- (void)startWithConfig:(id<SMRUpdateStatusManagerConfig>)config;

- (void)makeMainStateReadWithKey:(NSString *)key;
- (void)makeStateReadWithKey:(NSString *)key readTime:(NSTimeInterval)readTime;

- (void)setUpdateStatus:(SMRUpdateStatus *)updateStatus;

- (SMRUpdateStatus *)getUpdateStatusWithKey:(NSString *)key;
- (SMRUpdateStatus *)getAndSetUpdateStatusWithKey:(NSString *)key updateTime:(NSTimeInterval)updateTime discriminationByUser:(BOOL)discriminationByUser;

- (BOOL)updateStatusWithKey:(NSString *)key updateTime:(NSTimeInterval)updateTime discriminationByUser:(BOOL)discriminationByUser;

#pragma mark - Advanced Use

/**
 *  A.显示红点逻辑步骤:
 *  1.设置updateTime (有2个方法可以设置)
 *  2.获取SMRUpdateStatus对象
 *  3.默认情况:根据对象的'has_new'属性来设置是否显示红点, 同时刷新UI
 *
 *  B.置掉红点逻辑步骤:
 *  1.点击事件/被触发的事件中,使用makeStateReadWithKey:来更新SMRUpdateStatus对象
 *  3.默认情况:根据对象的'has_new'属性来设置是否显示红点, 同时刷新UI
 */
/** 获取更新状态的方法       -- 如果不存在会自动生成一个默认对象(推荐:单独获取更新状态) */
+ (SMRUpdateStatus *)getUpdateStatusWithKey:(NSString *)key;
/** 获取和设置更新状态的方法  -- 常规设置红点的方法,返回更新后的对象(推荐:设置新的更新状态) */
+ (SMRUpdateStatus *)getAndSetUpdateStatusWithKey:(NSString *)key updateTime:(NSTimeInterval)updateTime discriminationByUser:(BOOL)discrimination;

/** 置掉红点的方法          -- 置掉首页和当前页的红点，且更新read_time，count置为0 */
+ (void)makeStateReadWithKey:(NSString *)key;
/** 置掉红点的方法          -- 仅置掉首页的红点 */
+ (void)makeMainStateReadWithKey:(NSString *)key;

/** 设置更新状态的方法       -- 有更新状态变更,返回YES */
+ (BOOL)updateStatusWithKey:(NSString *)key updateTime:(int32_t)updateTime discriminationByUser:(BOOL)discrimination;
/** 附加方法               -- 写入到缓存 */
+ (void)setUpdateStatus:(SMRUpdateStatus *)updateStatus;

#pragma mark - General Use

/** 适合只有一个维度的简单状态变化 */
+ (kUpdateStatusType)getUpdateStatusTypeWithKey:(NSString *)key;
+ (void)setUpdateStatusWithKey:(NSString *)key andType:(kUpdateStatusType)updateStatusType;

@end
