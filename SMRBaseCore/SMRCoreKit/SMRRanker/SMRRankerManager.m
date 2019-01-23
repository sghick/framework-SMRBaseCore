//
//  SMRRankerManager.m
//  SMRRankerDemo
//
//  Created by 丁治文 on 2018/7/28.
//  Copyright © 2018年 sumrise.com. All rights reserved.
//

////////////////////////////////////////////////////
//              SMRRankerManager
////////////////////////////////////////////////////

#import "SMRRankerManager.h"
#import "SMRRankerAction.h"
#import "SMRRankerConfig.h"
#import "SMRRankerLifecycleManager.h"

static NSString * const SMRankerMangerLockName = @"com.sumrise.ranker.manager.lock";

static dispatch_queue_t smr_ranker_manager_creation_queue() {
    static dispatch_queue_t smr_in_ranker_manager_creation_queue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        smr_in_ranker_manager_creation_queue = dispatch_queue_create("com.sumrise.ranker.creation.queue", DISPATCH_QUEUE_SERIAL);
    });
    
    return smr_in_ranker_manager_creation_queue;
}

@interface SMRRankerManager ()

@property (strong, nonatomic) NSMutableDictionary<NSString *, SMRRankerAction *> *actions;
@property (strong, nonatomic) NSMutableArray<SMRRankerAction *> *actionList;
@property (strong, nonatomic) NSLock *lock;
@property (assign, nonatomic) BOOL autoGroupId;///< 是否自动设置groupId

@end

static void *SMRankerMangerActionObserverContext = &SMRankerMangerActionObserverContext;

@implementation SMRRankerManager

- (instancetype)init {
    return [self initWithGroupId:nil config:nil];
}

- (instancetype)initWithConfig:(id<SMRRankerConfig>)config {
    return [self initWithGroupId:nil config:config];
}

- (instancetype)initWithGroupId:(NSString *)groupId {
    return [self initWithGroupId:groupId config:nil];
}

- (instancetype)initWithGroupId:(NSString *)groupId config:(id<SMRRankerConfig>)config {
    self = [super init];
    if (!self) return nil;
    _groupId = groupId?groupId:[self groupIdOfSerializer];
    _autoGroupId = groupId?NO:YES;
    _config = config?config:[SMRRankerConfig defaultConfig];
    _isEnable = YES;
    _lock = [[NSLock alloc] init];
    _lock.name = SMRankerMangerLockName;
    
    return self;
}

- (NSString *)groupIdOfSerializer {
    NSString *uuid = [[NSUUID UUID] UUIDString];
    return uuid;
}

// private
- (void)addObserversForAction:(SMRRankerAction *)action {
    NSParameterAssert(action);
    [action addObserver:self forKeyPath:NSStringFromSelector(@selector(status)) options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:SMRankerMangerActionObserverContext];
}

// private
- (void)removeObserversForAction:(SMRRankerAction *)action {
    NSParameterAssert(action);
    [action removeObserver:self forKeyPath:NSStringFromSelector(@selector(status)) context:SMRankerMangerActionObserverContext];
}

- (void)dealloc {
    [self unregistAllPopActions];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(__unused id)object change:(NSDictionary *)change context:(void *)context {
    if (context == SMRankerMangerActionObserverContext) {
        SMRRankerActionStatus oldN = (SMRRankerActionStatus)((NSNumber *)change[NSKeyValueChangeOldKey]).integerValue;
        SMRRankerActionStatus newN = (SMRRankerActionStatus)((NSNumber *)change[NSKeyValueChangeNewKey]).integerValue;
        if (oldN != newN) {
            [self checkNeedsPop];
        }
    }
}

- (void)checkNeedsPop {
    if (self.config) {
        dispatch_async(smr_ranker_manager_creation_queue(), ^{
            [self.lock lock];
            SMRRankerAction *action = [self.config nextExcuteActionFromActions:self.actionList];
            if (self.isEnable && action && action.enable) {
                [self markSuccessCheckWithAction:action];
                if (![self checkIfWithinLifecycleWithAction:action]) {
                    action.markDeleted = YES;// 标记已删除,在列表中无效
                }
                action.status = SMRRankerActionStatusAppear;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [action performAction];
                });
            }
            [self.lock unlock];
        });
    }
}

// private
- (void)addAction:(SMRRankerAction *)action {
    NSParameterAssert(action);
    NSParameterAssert(action.identifier);
    [self.lock lock];
    self.actions[action.identifier] = action;
    [self.actionList addObject:action];
    [self addObserversForAction:action];
    [self.lock unlock];
}

// private
- (void)removeActionWithIdentifier:(NSString *)identifier {
    NSParameterAssert(identifier);
    SMRRankerAction *action = [self actionWithIdentifier:identifier];
    [self.lock lock];
    if (action) {
        [self.actions removeObjectForKey:identifier];
        [self.actionList removeObject:action];
        [self removeObserversForAction:action];
    }
    [self.lock unlock];
}

- (SMRRankerAction *)actionWithIdentifier:(NSString *)identifier {
    NSParameterAssert(identifier);
    SMRRankerAction *action = nil;
    [self.lock lock];
    action = self.actions[identifier];
    [self.lock unlock];
    return action;
}

- (void)clearLifecycleWithIdentifier:(NSString *)identifier {
    SMRRankerAction *action = [self actionWithIdentifier:identifier];
    [self clearLifecycleWithAction:action];
}

- (void)clearLifecycleWithAction:(SMRRankerAction *)action {
    NSParameterAssert(action);
    NSString *lifecycleId = [NSString stringWithFormat:@"__ranker_manager_%@_%@", self.autoGroupId?@"":self.groupId, action.identifier];
    [SMRRankerLifecycleManager clearLifecycleWithIdentifier:lifecycleId];
}

- (void)markActionWithIdentifier:(NSString *)identifier withStatus:(SMRRankerActionStatus)status {
    NSParameterAssert(identifier);
    SMRRankerAction *action = [self actionWithIdentifier:identifier];
    if ([self.config shouldChangeStatusWithAction:action toStatus:status]) {
        action.status = status;
    }
}

- (BOOL)checkIfWithinLifecycleWithAction:(SMRRankerAction *)action {
    NSString *lifecycleId = [NSString stringWithFormat:@"__ranker_manager_%@_%@", self.autoGroupId?@"":self.groupId, action.identifier];
    return [SMRRankerLifecycleManager checkIfWithinLifecycle:action.lifecycle checkcount:action.checkCount withIdentifier:lifecycleId];
}

- (void)markSuccessCheckWithAction:(SMRRankerAction *)action {
    NSString *lifecycleId = [NSString stringWithFormat:@"__ranker_manager_%@_%@", self.autoGroupId?@"":self.groupId, action.identifier];
    [SMRRankerLifecycleManager markSuccessCheckWithIdentifier:lifecycleId];
}

#pragma mark - Utils

- (void)registActionWithIdentifier:(NSString *)identifier completionBlock:(void(^)(SMRRankerAction *))completionBlock {
    SMRRankerAction *action = [[SMRRankerAction alloc] initWithIdentifier:identifier completionBlock:completionBlock];
    [self addAction:action];
}

- (BOOL)registActionWithIdentifier:(NSString *)identifier settingBlock:(SMRActionSettingBlock)settingBlock {
    SMRRankerAction *action = [[SMRRankerAction alloc] initWithIdentifier:identifier];
    if (settingBlock) {
        settingBlock(action);
    }
    if ([self checkIfWithinLifecycleWithAction:action]) {
        [self addAction:action];
        return YES;
    } else {
        // 超出生命周期,注册失效
        return NO;
    }
}

- (BOOL)registActionWithIdentifier:(NSString *)identifier {
    return [self registActionWithIdentifier:identifier settingBlock:nil];
}

- (void)unregistActionWithIdentifier:(NSString *)identifier {
    [self markActionCancelWithIdentifier:identifier];
    [self removeActionWithIdentifier:identifier];
}

- (void)unregistAllPopActions {
    for (SMRRankerAction *action in self.actionList) {
        [self removeObserversForAction:action];
    }
    [self.actionList removeAllObjects];
    self.actionList = nil;
}

- (void)enalbelActionsWithIdentifiers:(NSArray *)idnetifiers {
    for (NSString *actid in idnetifiers) {
        SMRRankerAction *action = [self actionWithIdentifier:actid];
        action.enable = YES;
    }
}

- (void)dialbelActionsWithIdentifiers:(NSArray *)idnetifiers {
    for (NSString *actid in idnetifiers) {
        SMRRankerAction *action = [self actionWithIdentifier:actid];
        action.enable = NO;
    }
}

- (void)markActionReadyWithIdentifier:(NSString *)identifier completionBlock:(void (^)(SMRRankerAction *))completionBlock {
    if (completionBlock) {
        [self setActionWithIdentifier:identifier completionBlock:completionBlock];
    }
    [self markActionWithIdentifier:identifier withStatus:SMRRankerActionStatusReady];
}

- (void)markActionReadyWithIdentifier:(NSString *)identifier {
    [self markActionReadyWithIdentifier:identifier completionBlock:nil];
}

- (void)setActionWithIdentifier:(NSString *)identifier completionBlock:(void (^)(SMRRankerAction *))completionBlock {
    NSParameterAssert(identifier);
    SMRRankerAction *action = [self actionWithIdentifier:identifier];
    if (action) {
        action.completionBlock = completionBlock;
    } else {
        // 未注册或者在当前生命周期中无效
    }
}

- (void)markActionCancelWithIdentifier:(NSString *)identifier {
    [self markActionWithIdentifier:identifier withStatus:SMRRankerActionStatusCancel];
}

- (void)markActionFaildWithIdentifier:(NSString *)identifier {
    [self markActionWithIdentifier:identifier withStatus:SMRRankerActionStatusFaild];
}

- (void)markActionBeginWithIdentifier:(NSString *)identifier {
    [self markActionWithIdentifier:identifier withStatus:SMRRankerActionStatusBegin];
}

- (void)markActionCloseWithIdentifier:(NSString *)identifier {
    [self markActionWithIdentifier:identifier withStatus:SMRRankerActionStatusClose];
}

- (NSMutableDictionary<NSString *,SMRRankerAction *> *)actions {
    if (_actions == nil) {
        _actions = [NSMutableDictionary dictionary];
    }
    return _actions;
}

- (NSMutableArray<SMRRankerAction *> *)actionList {
    if (_actionList == nil) {
        _actionList = [NSMutableArray array];
    }
    return _actionList;
}

@end

////////////////////////////////////////////////////
//              SMRGlobalRankerManager
////////////////////////////////////////////////////

@interface SMRGlobalRankerManager ()

@property (strong, nonatomic) NSMutableDictionary<NSString *, SMRRankerManager *> *managers;

@end

static SMRGlobalRankerManager *_shareGlobalRankerManger = nil;
static dispatch_once_t _globalRankerMangerOnceToken;

@implementation SMRGlobalRankerManager

+ (instancetype)shareInstance {
    dispatch_once(&_globalRankerMangerOnceToken, ^{
        _shareGlobalRankerManger = [[self alloc] init];
    });
    return _shareGlobalRankerManger;
}

- (void)addManger:(SMRRankerManager *)manager {
    NSParameterAssert(manager);
    NSParameterAssert(manager.groupId);
    self.managers[manager.groupId] = manager;
}

- (SMRRankerManager *)managerWithGroupId:(NSString *)groupId {
    NSParameterAssert(groupId);
    return self.managers[groupId];
}

- (NSMutableDictionary<NSString *,SMRRankerManager *> *)managers {
    if (_managers == nil) {
        _managers = [NSMutableDictionary dictionary];
    }
    return _managers;
}

+ (void)addManger:(SMRRankerManager *)manager {
    [[SMRGlobalRankerManager shareInstance] addManger:manager];
    
}

+ (SMRRankerManager *)managerWithGroupId:(NSString *)groupId {
    return [[SMRGlobalRankerManager shareInstance] managerWithGroupId:groupId];
}

+ (SMRRankerManager *)managerWithGroupId:(NSString *)groupId autoCreateWithConfig:(id<SMRRankerConfig>)config {
    SMRRankerManager *manager = [[SMRGlobalRankerManager shareInstance] managerWithGroupId:groupId];
    if (!manager) {
        manager = [[SMRRankerManager alloc] initWithGroupId:groupId config:config];
        [self addManger:manager];
    }
    return manager;
}

@end
