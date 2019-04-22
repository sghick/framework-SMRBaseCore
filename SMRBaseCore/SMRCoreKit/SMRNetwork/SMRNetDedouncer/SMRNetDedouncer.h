//
//  SMRNetDedouncer.h
//  SMRBaseCoreDemo
//
//  Created by 丁治文 on 2019/4/12.
//  Copyright © 2019 ibaodashi. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 线程安全,但是需要保证对象的创建在加锁的情况下操作
 */
@class NSArray<ObjectType>;
@interface SMRNetDedouncer<ObjectType> : NSObject

/** 防止恶意刷子设置,时间段(s),如果抖动超过最大容量时,默认60s内当前表示自动废弃 */
@property (assign, nonatomic) NSTimeInterval invalidateDuration;

/**
 防抖处理,处理结果只会回调当前容量中第一个对象,其它的会进入一个队列,并且无回调

 @param obj 处理对象
 @param identifier 唯一标识
 @param withinTime 分段频率,单位为ms
 @param maxCount 分段容量,超出后直接舍弃
 @param resultBlock 处理结果,单位为ms
 */
- (void)dedounce:(ObjectType)obj
      identifier:(NSString *)identifier
      withinTime:(NSTimeInterval)withinTime
        maxCount:(NSInteger)maxCount
     resultBlock:(void (^)(SMRNetDedouncer *dedouncer, NSTimeInterval groupTag, ObjectType obj))resultBlock;

/**
 返回被截流的对象
 */
- (NSArray<ObjectType> *)objectForDedouncedWithIdentifier:(NSString *)identifier groupTag:(NSTimeInterval)groupTag;

/**
 删除队列中保存的被截流的对象
 */
- (void)removeObjectForDedouncedWithIdentifier:(NSString *)identifier groupTag:(NSTimeInterval)groupTag;

@end
