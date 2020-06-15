//
//  SMRRankerConfig.h
//  SMRRankerDemo
//
//  Created by 丁治文 on 2018/7/28.
//  Copyright © 2018年 sumrise.com. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, SMRRankerActionStatus);

@class SMRRankerAction;
@protocol SMRRankerConfig <NSObject>

@required

/**
 检查这一组action中,如果有符合条件的执行业务,就返回,没有则返回nil
 
 @param actions 一组action
 @return 符合条件的执行业务
 */
- (SMRRankerAction *)nextExcuteActionFromActions:(NSArray<SMRRankerAction *> *)actions;

/**
 检测当前action是否符合执行业务条件
 
 @param action 当前action
 @param actions 所有注册过的action
 @return YES,符合条件;NO,不符合条件
 */
- (BOOL)shouldExcuteAction:(SMRRankerAction *)action fromActions:(NSArray<SMRRankerAction *> *)actions;

/**
 校验是否允许某个从状态变化到另一个状态
 
 @param action 原action
 @param toStatus 新的状态
 @return 允许则返回YES
 */
- (BOOL)shouldChangeStatusWithAction:(SMRRankerAction *)action toStatus:(SMRRankerActionStatus)toStatus;

@end

/**
 理解比喻:一个team从公共汽车去旅游,去的人先报名(regist),
 出发前,要等所有人都到齐了(ready)才上车,
 上车(begin)要按顺序来点名,这个顺序是按照报名顺序来的,点到的人可以上车
 如果有人不来了则不用等他来(cancel)
 如果前一个人已经上车了则不会再点到了(close)
 如果这时有人说去不了了(faild),则不再点他的名,但是已经上车的人不用care,爱走不走,反正也不点名了
 如果是2个人在点名,则正在点名的(appear)或者已经点过的都不应该再被点到名了
 直到最后一个人点名结束
 超时时间为,这趟旅行必须要去,人可以不用去齐,然后时间(timeoutInterval)不够了,于是不再点名,没点到的就回家去
 对于点名的顺序和规则可以重写config来控制
 */
@interface SMRRankerConfig : NSObject<SMRRankerConfig>

/**
 执行业务顺序:按注册顺序
 执行业务条件:高优先级执行业务状态为regist(close/cancel/faild)时,弹出最早regist的action状态为begin状态的action
 不执行业务条件:未满足执行业务条件时
 
 @return 配置对象
 */
+ (instancetype)defaultConfig;

@end
