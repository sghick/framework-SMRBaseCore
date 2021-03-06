//
//  SMRRankerManager.m
//  SMRBaseCoreDemo
//
//  Created by 丁治文 on 2018/7/28.
//  Copyright © 2018年 baodashi.com. All rights reserved.
//

////////////////////////////////////////////////////
//              SMRRankerManager
////////////////////////////////////////////////////

#import "SMRRankerManager.h"
#import "SMRRankerAction.h"
#import "SMRRankerConfig.h"
#import "SMRRankerLifecycleManager.h"

static NSString * const SMRankerMangerLockName = @"com.baodashi.ranker.manager.lock";

static dispatch_queue_t smr_ranker_manager_creation_queue() {
    static dispatch_queue_t smr_in_ranker_manager_creation_queue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        smr_in_ranker_manager_creation_queue = dispatch_queue_create("com.baodashi.ranker.creation.queue", DISPATCH_QUEUE_SERIAL);
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
    _groupId = groupId?groupId:[self p_groupIdOfSerializer];
    _autoGroupId = groupId?NO:YES;
    _config = config?config:[SMRRankerConfig defaultConfig];
    _isEnable = YES;
    _lock = [[NSLock alloc] init];
    _lock.name = SMRankerMangerLockName;
    
    return self;
}

- (void)dealloc {
    [self unregistAllActions];
}

#pragma mark - Observer

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(__unused id)object change:(NSDictionary *)change context:(void *)context {
    if (context == SMRankerMangerActionObserverContext) {
        SMRRankerActionStatus oldN = (SMRRankerActionStatus)((NSNumber *)change[NSKeyValueChangeOldKey]).integerValue;
        SMRRankerActionStatus newN = (SMRRankerActionStatus)((NSNumber *)change[NSKeyValueChangeNewKey]).integerValue;
        if (oldN != newN) {
            [self checkNeedsPop];
        }
    }
}

#pragma mark - Privates

- (NSString *)p_groupIdOfSerializer {
    NSString *uuid = [[NSUUID UUID] UUIDString];
    return uuid;
}

- (void)p_addObserversForAction:(SMRRankerAction *)action {
    NSParameterAssert(action);
    [action addObserver:self forKeyPath:NSStringFromSelector(@selector(status)) options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:SMRankerMangerActionObserverContext];
}

- (void)p_removeObserversForAction:(SMRRankerAction *)action {
    NSParameterAssert(action);
    [action removeObserver:self forKeyPath:NSStringFromSelector(@selector(status)) context:SMRankerMangerActionObserverContext];
}

- (void)p_addAction:(SMRRankerAction *)action {
    NSParameterAssert(action);
    NSParameterAssert(action.identifier);
    [self.lock lock];
    self.actions[action.identifier] = action;
    [self.actionList addObject:action];
    [self p_addObserversForAction:action];
    [self.lock unlock];
}

- (void)p_removeActionWithIdentifier:(NSString *)identifier {
    NSParameterAssert(identifier);
    SMRRankerAction *action = [self actionWithIdentifier:identifier];
    [self.lock lock];
    if (action) {
        [self.actions removeObjectForKey:identifier];
        [self.actionList removeObject:action];
        [self p_removeObserversForAction:action];
    }
    [self.lock unlock];
}

- (void)p_markActionWithIdentifier:(NSString *)identifier withStatus:(SMRRankerActionStatus)status {
    NSParameterAssert(identifier);
    SMRRankerAction *action = [self actionWithIdentifier:identifier];
    if ([self.config shouldChangeStatusWithAction:action toStatus:status]) {
        // 标记成功
        if ((action.markStyle == SMRRankerSuccessMarkStyleClose) && (status == SMRRankerActionStatusClose)) {
            [self markSuccessCheckWithIdentifier:action.identifier];
        }
        action.status = status;
    }
}

- (BOOL)p_checkIfWithinLifecycleWithAction:(SMRRankerAction *)action {
    NSString *lifecycleId = [NSString stringWithFormat:@"__ranker_manager_%@_%@", self.autoGroupId?@"":self.groupId, action.identifier];
    return [SMRRankerLifecycleManager checkIfWithinLifecycle:action.lifecycle checkcount:action.checkCount withIdentifier:lifecycleId];
}

- (void)p_checkAndRemoveTheSamesGroupAction:(SMRRankerAction *)action {
    if (action.groupLabel) {
        for (SMRRankerAction *act in self.actionList) {
            if ([action.groupLabel isEqualToString:act.groupLabel]) {
                act.outOfGroup = YES;
            }
        }
    }
}

#pragma mark - Methods

- (void)checkNeedsPop {
    if (self.config) {
        dispatch_async(smr_ranker_manager_creation_queue(), ^{
            [self.lock lock];
            SMRRankerAction *action = [self.config nextExcuteActionFromActions:self.actionList];
            if (![self.config shouldExcuteAction:action fromActions:self.actionList]) {
                action = nil;
            }
            if (self.isEnable && action && action.enable) {
                // 执行即标记成功
                if (action.markStyle == SMRRankerSuccessMarkStyleExcute) {
                    [self markSuccessCheckWithIdentifier:action.identifier];
                }
                if (![self p_checkIfWithinLifecycleWithAction:action]) {
                    action.outOfLifecycle = YES;// 标记已删除,在列表中无效
                }
                // 标记相同分组的action的删除
                [self p_checkAndRemoveTheSamesGroupAction:action];
                action.status = SMRRankerActionStatusAppear;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [action performAction];
                });
            }
            [self.lock unlock];
        });
    }
}

- (SMRRankerAction *)actionWithIdentifier:(NSString *)identifier {
    NSParameterAssert(identifier);
    SMRRankerAction *action = nil;
    [self.lock lock];
    action = self.actions[identifier];
    [self.lock unlock];
    return action;
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

- (void)clearLifecycleWithIdentifier:(NSString *)identifier {
    NSString *lifecycleId = [NSString stringWithFormat:@"__ranker_manager_%@_%@", self.autoGroupId?@"":self.groupId, identifier];
    [SMRRankerLifecycleManager clearLifecycleWithIdentifier:lifecycleId];
}

- (void)markSuccessCheckWithIdentifier:(NSString *)identifier {
    NSString *lifecycleId = [NSString stringWithFormat:@"__ranker_manager_%@_%@", self.autoGroupId?@"":self.groupId, identifier];
    [SMRRankerLifecycleManager markSuccessCheckWithIdentifier:lifecycleId];
}

- (void)enalbelForGroupActionsWithIdentifiers:(NSArray *)idnetifiers {
    for (NSString *actid in idnetifiers) {
        SMRRankerAction *action = [self actionWithIdentifier:actid];
        action.outOfGroup = YES;
    }
}

- (void)enalbelForLifecycleActionsWithIdentifiers:(NSArray *)idnetifiers {
    for (NSString *actid in idnetifiers) {
        SMRRankerAction *action = [self actionWithIdentifier:actid];
        action.outOfLifecycle = NO;
    }
}

#pragma mark - Utils

- (void)registActionWithIdentifier:(NSString *)identifier completionBlock:(void(^)(SMRRankerAction *))completionBlock {
    SMRRankerAction *action = [[SMRRankerAction alloc] initWithIdentifier:identifier completionBlock:completionBlock];
    [self p_addAction:action];
}

- (BOOL)registActionWithIdentifier:(NSString *)identifier settingBlock:(SMRActionSettingBlock)settingBlock {
    SMRRankerAction *action = [[SMRRankerAction alloc] initWithIdentifier:identifier];
    if (settingBlock) {
        settingBlock(action);
    }
    if ([self p_checkIfWithinLifecycleWithAction:action]) {
        [self p_addAction:action];
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
    [self p_removeActionWithIdentifier:identifier];
}

- (void)unregistAllActions {
    for (SMRRankerAction *action in self.actionList) {
        [self p_removeObserversForAction:action];
    }
    [self.actionList removeAllObjects];
    self.actionList = nil;
}

- (void)markActionReadyWithIdentifier:(NSString *)identifier completionBlock:(SMRRankerActionCompletionBlock)completionBlock {
    if (completionBlock) {
        [self setActionWithIdentifier:identifier completionBlock:completionBlock];
    }
    [self p_markActionWithIdentifier:identifier withStatus:SMRRankerActionStatusReady];
}

- (void)markActionReadyWithIdentifier:(NSString *)identifier {
    [self markActionReadyWithIdentifier:identifier completionBlock:nil];
}

- (void)setActionWithIdentifier:(NSString *)identifier completionBlock:(SMRRankerActionCompletionBlock)completionBlock {
    NSParameterAssert(identifier);
    SMRRankerAction *action = [self actionWithIdentifier:identifier];
    if (action) {
        action.completionBlock = completionBlock;
    } else {
        // 未注册或者在当前生命周期中无效
    }
}

- (void)markActionCancelWithIdentifier:(NSString *)identifier {
    [self p_markActionWithIdentifier:identifier withStatus:SMRRankerActionStatusCancel];
}

- (void)markActionFaildWithIdentifier:(NSString *)identifier {
    [self p_markActionWithIdentifier:identifier withStatus:SMRRankerActionStatusFaild];
}

- (void)markActionBeginWithIdentifier:(NSString *)identifier {
    [self p_markActionWithIdentifier:identifier withStatus:SMRRankerActionStatusBegin];
}

- (void)markActionCloseWithIdentifier:(NSString *)identifier {
    [self p_markActionWithIdentifier:identifier withStatus:SMRRankerActionStatusClose];
}

#pragma mark - Getters

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
    return [self managerWithGroupId:groupId autoCreateWithConfig:nil];
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
