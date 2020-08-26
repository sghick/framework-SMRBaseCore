//
//  SMRReuseQueue.m
//  SMRBaseCoreDemo
//
//  Created by Tinswin on 2020/7/25.
//  Copyright © 2020 Tinswin. All rights reserved.
//

#import "SMRReuseQueue.h"

@interface SMRReuseQueue ()

@property (nonatomic, strong) NSMutableDictionary *clsMapper;
@property (nonatomic, strong) NSMutableDictionary *queuesMapper;
@property (nonatomic, strong) NSMutableDictionary *creatorsMapper;

@end

@implementation SMRReuseQueue

- (__kindof UIView *)dequeueWithTag:(id)tag {
    NSMutableArray<UIView *> *queue = self.queuesMapper[tag];
    if (!queue) {
        queue = [NSMutableArray array];
        self.queuesMapper[tag] = queue;
    }
    UIView *view = [self _fetchFirstAvailableInQueue:queue];
    if (view == nil) {
        Class cClass = self.clsMapper[tag];
        if (cClass) {
            view = [self _createWithClass:cClass tag:tag];
            [queue addObject:view];
        }
    } else {
        if (![queue.lastObject isEqual:view]) {
            [queue removeObject:view];
            [queue addObject:view];
        }
    }
    return view;
}

- (UIView *)_fetchFirstAvailableInQueue:(NSMutableArray<UIView *> *)queue {
    UIView *r = nil;
    for (UIView *view in queue) {
        if (!view.superview) {
            r = view;
            break;
        }
    }
    return r;
}

- (UIView *)_createWithClass:(Class)cls tag:(id)tag {
    UIView *view = nil;
    SMRReuseQueueCreator block = self.creatorsMapper[tag];
    if (block) {
        view = block(cls, tag);
    }
    if (!view) {
        view = [[cls alloc] init];
    }
    return view;
}

- (void)registerClass:(Class)cls forTag:(id)tag {
    [self registerClass:cls forTag:tag creator:nil];
}
- (void)registerClass:(Class)cls forTag:(id)tag creator:(SMRReuseQueueCreator)creator {
    if (![cls isSubclassOfClass:UIView.class]) {
        NSAssert(NO, @"请注册UIView及其子类");
        return;
    }
    self.clsMapper[tag] = cls;
    self.creatorsMapper[tag] = creator;
}

- (void)clear {
    _queuesMapper = nil;
}
- (void)clearForTag:(id)tag {
    _queuesMapper[tag] = nil;
}

#pragma mark - Getters

- (NSMutableDictionary *)clsMapper {
    if (!_clsMapper) {
        _clsMapper = [NSMutableDictionary dictionary];
    }
    return _clsMapper;
}

- (NSMutableDictionary *)queuesMapper {
    if (!_queuesMapper) {
        _queuesMapper = [NSMutableDictionary dictionary];
    }
    return _queuesMapper;
}

- (NSMutableDictionary *)creatorsMapper {
    if (!_creatorsMapper) {
        _creatorsMapper = [NSMutableDictionary dictionary];
    }
    return _creatorsMapper;
}

@end
