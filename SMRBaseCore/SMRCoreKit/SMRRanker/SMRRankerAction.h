//
//  SMRRankerAction.h
//  SMRRankerDemo
//
//  Created by 丁治文 on 2018/7/28.
//  Copyright © 2018年 sumrise.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SMRRankerAction;

typedef NS_ENUM(NSInteger, SMRRankerActionStatus) {
    SMRRankerActionStatusRegist     = 0, // 注册
    SMRRankerActionStatusReady      = 1, // 预备
    SMRRankerActionStatusCancel     = 2, // 取消
    SMRRankerActionStatusBegin      = 3, // 开始(这个状态将进入执行业务队列)
    SMRRankerActionStatusAppear     = 4, // 呈现(这个状态下,check将无效)
    SMRRankerActionStatusFaild      = 5, // 失败
    SMRRankerActionStatusClose      = 6, // 结束/关闭
};

typedef NS_ENUM(NSInteger, SMRRankerLifecycle);
typedef void (^SMRRankerActionCompletionBlock)(SMRRankerAction *action);

@interface SMRRankerAction : NSObject

@property (assign, nonatomic) BOOL markDeleted;///< 被标记为删除

@property (copy  , nonatomic, readonly) NSString *identifier;
@property (assign, nonatomic) SMRRankerActionStatus status;
@property (copy  , nonatomic) SMRRankerActionCompletionBlock completionBlock;
@property (assign, nonatomic) BOOL enable;///< 是否可用,默认YES
@property (strong, nonatomic) NSDictionary *userInfo;///< 附加信息
@property (strong, nonatomic) id object;///< 附加信息

@property (assign, nonatomic, readonly) SMRRankerLifecycle lifecycle;///< 生命周期,默认:WCPopActionLifecycleEverLaunch
@property (assign, nonatomic, readonly) NSTimeInterval customTime;///< 自定义生命周期,lifecycle为WCPopActionLifecycleEverCustomTime
@property (assign, nonatomic, readonly) NSInteger checkCount;///< 在生命周期内的执行次数,-1表示无限次,默认:1次

- (NSString *)description;

- (instancetype)initWithIdentifier:(NSString *)identifier;
- (instancetype)initWithIdentifier:(NSString *)identifier
                   completionBlock:(SMRRankerActionCompletionBlock)completionBlock;

/**
 如果要使用生命周期,请在manager中记录下groupId,不同的manager被认为不同生命周期
 */
- (void)setLifecycle:(SMRRankerLifecycle)lifecycle checkCount:(NSInteger)checkCount;
- (void)setCustomTime:(NSTimeInterval)customTime checkCount:(NSInteger)checkCount;
- (void)performAction;

@end
