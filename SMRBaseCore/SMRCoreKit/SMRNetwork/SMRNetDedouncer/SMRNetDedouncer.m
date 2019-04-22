//
//  SMRNetDedouncer.m
//  SMRBaseCoreDemo
//
//  Created by 丁治文 on 2019/4/12.
//  Copyright © 2019 ibaodashi. All rights reserved.
//

#import "SMRNetDedouncer.h"

static dispatch_queue_t smr_netdedouncer_creation_queue() {
    static dispatch_queue_t t_smr_netdedouncer_creation_queue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        t_smr_netdedouncer_creation_queue = dispatch_queue_create("com.SMR.netdedouncer.queue.creation", DISPATCH_QUEUE_SERIAL);
    });
    
    return t_smr_netdedouncer_creation_queue;
}

@interface SMRNetDedouncer ()

@property (strong, nonatomic) NSMutableDictionary<NSString *, NSNumber *> *blackList;///< 暴力刷子列表

@property (strong, nonatomic) NSMutableArray *dedounceIdentifier;
@property (strong, nonatomic) NSMutableDictionary<NSString *, NSMutableArray *> *dedounceGroupTagList;
@property (strong, nonatomic) NSMutableDictionary<NSString *, NSMutableArray *> *dedounceList;

@end

@implementation SMRNetDedouncer

- (instancetype)init {
    self = [super init];
    if (self) {
        _invalidateDuration = 60;
    }
    return self;
}

- (void)dedounce:(id)obj
      identifier:(NSString *)identifier
      withinTime:(NSTimeInterval)withinTime
        maxCount:(NSInteger)maxCount
     resultBlock:(void (^)(SMRNetDedouncer *, NSTimeInterval, id))resultBlock {
    if (!obj || !identifier) {
        if (resultBlock) {
            resultBlock(self, [[NSDate date] timeIntervalSince1970], obj);
        }
        return;
    }
    
    // 使用同步串行队列,保证线程安全
    dispatch_sync(smr_netdedouncer_creation_queue(), ^{
        // 获取当前时间
        NSTimeInterval nowTime = [[NSDate date] timeIntervalSince1970];
        
        // 阻止暴力刷子
        if (self.blackList[identifier].integerValue > nowTime) {
            NSLog(@"异常自动处理:%@", identifier);
            return;
        }
        
        // 获取tag列表
        NSMutableArray<NSNumber *> *tags = self.dedounceGroupTagList[identifier];
        if (!tags) {
            tags = [NSMutableArray array];
            self.dedounceGroupTagList[identifier] = tags;
        }
        
        // 计算当前任务的tag
        NSTimeInterval newTag = nowTime;
        
        // 获取最新tag
        NSTimeInterval groupTag = tags.lastObject.doubleValue;
        if ((newTag - groupTag) > withinTime) {
            // 超出频段,设置新的tag
            groupTag = newTag;
            [tags addObject:@(newTag)];
        } else {
            // 当前频段,tag不变
        }
        
        // 组合key
        NSString *key = [identifier stringByAppendingFormat:@"_%@", @(groupTag)];
        // 防抖处理
        if ([self.dedounceIdentifier containsObject:key]) {
            NSMutableArray *list = self.dedounceList[key];
            if (!list) {
                list = [NSMutableArray array];
                self.dedounceList[key] = list;
            }
            if (list.count < maxCount) {
                // 在容量内,挂起
                [list addObject:obj];
            } else {
                // 超出容量,预警,开启暴力刷子防护
                self.blackList[identifier] = @(nowTime + self.invalidateDuration);
                NSAssert(NO, @"检测到异常:%@, 请检查同一标识是否有重复.", identifier);
            }
        } else {
            // 标记正在处理
            [self.dedounceIdentifier addObject:key];
            // 关闭暴力刷子标识
            self.blackList[identifier] = nil;
            if (resultBlock) {
                resultBlock(self, groupTag, obj);
            }
        }
    });
}

- (NSArray *)objectForDedouncedWithIdentifier:(NSString *)identifier groupTag:(NSTimeInterval)groupTag {
    if (!identifier) {
        return nil;
    }
    NSString *key = [identifier stringByAppendingFormat:@"_%@", @(groupTag)];
    NSMutableArray *list = self.dedounceList[key];
    return [list copy];
}

- (void)removeObjectForDedouncedWithIdentifier:(NSString *)identifier groupTag:(NSTimeInterval)groupTag {
    if (!identifier) {
        return;
    }
    NSString *key = [identifier stringByAppendingFormat:@"_%@", @(groupTag)];
    [self.dedounceIdentifier removeObject:key];
    [self.dedounceList removeObjectForKey:key];
    
    NSMutableArray<NSNumber *> *tags = self.dedounceGroupTagList[identifier];
    [tags removeObject:@(groupTag)];
}

- (NSMutableDictionary<NSString *,NSNumber *> *)blackList {
    if (!_blackList) {
        _blackList = [NSMutableDictionary dictionary];
    }
    return _blackList;
}

- (NSMutableArray *)dedounceIdentifier {
    if (!_dedounceIdentifier) {
        _dedounceIdentifier = [NSMutableArray array];
    }
    return _dedounceIdentifier;
}

- (NSMutableDictionary<NSString *, NSMutableArray *> *)dedounceGroupTagList {
    if (!_dedounceGroupTagList) {
        _dedounceGroupTagList = [NSMutableDictionary dictionary];
    }
    return _dedounceGroupTagList;
}

- (NSMutableDictionary<NSString *, NSMutableArray *> *)dedounceList {
    if (!_dedounceList) {
        _dedounceList = [NSMutableDictionary dictionary];
    }
    return _dedounceList;
}

@end
