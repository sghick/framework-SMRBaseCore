//
//  SMRNetDebouncer.m
//  SMRBaseCoreDemo
//
//  Created by 丁治文 on 2019/4/12.
//  Copyright © 2019 sumrise. All rights reserved.
//

#import "SMRNetDebouncer.h"
#import "SMRLog.h"

static dispatch_queue_t smr_netdebouncer_creation_queue() {
    static dispatch_queue_t t_smr_netdebouncer_creation_queue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        t_smr_netdebouncer_creation_queue = dispatch_queue_create("com.SMR.netdebouncer.queue.creation", DISPATCH_QUEUE_SERIAL);
    });
    
    return t_smr_netdebouncer_creation_queue;
}

@interface SMRNetDebouncer ()

@property (strong, nonatomic) NSMutableDictionary<NSString *, NSNumber *> *blackList;///< 暴力刷子列表

@property (strong, nonatomic) NSMutableArray *dedounceIdentifier;
@property (strong, nonatomic) NSMutableDictionary<NSString *, NSMutableArray *> *dedounceList;

@end

@implementation SMRNetDebouncer

- (void)dedounce:(id)obj
      identifier:(NSString *)identifier
        maxCount:(NSInteger)maxCount
     resultBlock:(void (^)(SMRNetDebouncer *, id))resultBlock {
    if (!obj || !identifier) {
        if (resultBlock) {
            resultBlock(self, obj);
        }
        return;
    }
    
    // 使用同步串行队列,保证线程安全
    dispatch_sync(smr_netdebouncer_creation_queue(), ^{
        // 阻止暴力刷子
        if (self.blackList[identifier].boolValue) {
            base_core_warning_log(@"异常自动处理:%@", identifier);
            return;
        }
        // 防抖处理
        if ([self.dedounceIdentifier containsObject:identifier]) {
            NSMutableArray *list = self.dedounceList[identifier];
            if (!list) {
                list = [NSMutableArray array];
                self.dedounceList[identifier] = list;
            }
            
            if (maxCount != -1) {
                if (list.count < maxCount) {
                    // 关闭暴力刷子防护
                    self.blackList[identifier] = nil;
                    // 在容量内,挂起
                    [list addObject:obj];
                } else {
                    // 超出容量,预警,开启暴力刷子防护
                    self.blackList[identifier] = @(YES);
                }
            } else {
                // 关闭暴力刷子防护
                self.blackList[identifier] = nil;
                // 不限容量,挂起
                [list addObject:obj];
            }
        } else {
            // 标记正在处理
            [self.dedounceIdentifier addObject:identifier];
            // 关闭暴力刷子标识
            self.blackList[identifier] = nil;
            [self p_callBackForDedounce:obj resultBlock:resultBlock];
        }
    });
}

- (void)p_callBackForDedounce:(id)obj resultBlock:(void (^)(SMRNetDebouncer *, id))resultBlock {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (resultBlock) {
            resultBlock(self, obj);
        }
    });
}

- (NSArray *)objectForDedouncedWithIdentifier:(NSString *)identifier {
    if (!identifier) {
        return nil;
    }
    NSMutableArray *list = self.dedounceList[identifier];
    return [list copy];
}

- (void)removeObjectForDedouncedWithIdentifier:(NSString *)identifier {
    if (!identifier) {
        return;
    }
    [self.dedounceIdentifier removeObject:identifier];
    [self.dedounceList removeObjectForKey:identifier];
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

- (NSMutableDictionary<NSString *, NSMutableArray *> *)dedounceList {
    if (!_dedounceList) {
        _dedounceList = [NSMutableDictionary dictionary];
    }
    return _dedounceList;
}

@end
