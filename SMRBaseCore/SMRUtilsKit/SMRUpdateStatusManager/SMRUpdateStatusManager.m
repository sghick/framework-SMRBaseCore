//
//  SMRUpdateStatusManager.m
//  SMRBaseCoreDemo
//
//  Created by 丁治文 on 2019/5/31.
//  Copyright © 2019 sumrise. All rights reserved.
//

#import "SMRUpdateStatusManager.h"
#import "SMRNetInfo.h"

NSString * const _discriminationUserName             = @"discriminationUserName_updateStatus03a7jf";
NSString * const _smr_update_status_prefix           = @"smr_update_status_prefix_";

@implementation SMRUpdateStatus

+ (instancetype)createUsingDict:(NSDictionary *)dict {
    SMRUpdateStatus *status = [[SMRUpdateStatus alloc] init];
    status.isNotEmpty = [dict[@"isNotEmpty"] boolValue];
    status.discrimination = [dict[@"discrimination"] boolValue];
    status.local_username = dict[@"local_username"];
    status.key = dict[@"key"];
    status.update_time = [dict[@"update_time"] doubleValue];
    status.has_new = [dict[@"has_new"] boolValue];
    status.main_has_new = [dict[@"main_has_new"] boolValue];
    status.read_time = [dict[@"read_time"] doubleValue];
    status.count = [dict[@"count"] intValue];
    status.type = [dict[@"type"] intValue];
    status.title = dict[@"title"];
    status.detail = dict[@"detail"];
    status.user_info = dict[@"user_info"];
    return status;
}

- (NSDictionary *)createDictionary {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"isNotEmpty"] = @(self.isNotEmpty);
    dict[@"discrimination"] = @(self.discrimination);
    dict[@"local_username"] = self.local_username;
    dict[@"key"] = self.key;
    dict[@"update_time"] = @(self.update_time);
    dict[@"has_new"] = @(self.has_new);
    dict[@"main_has_new"] = @(self.main_has_new);
    dict[@"read_time"] = @(self.read_time);
    dict[@"count"] = @(self.count);
    dict[@"type"] = @(self.type);
    dict[@"title"] = self.title;
    dict[@"detail"] = self.detail;
    dict[@"user_info"] = self.user_info;
    return dict;
}

- (NSComparisonResult)compareUpdateStatusUpdateTimeWhenHasNew:(SMRUpdateStatus *)object {
    // 降序
    NSComparisonResult result = NSOrderedSame;
    if (self.has_new > object.has_new) {
        result = NSOrderedAscending;
    } else if (self.has_new < object.has_new) {
        result = NSOrderedDescending;
    } else {
        if (self.has_new == YES) {
            if (self.update_time > object.update_time) {
                result = NSOrderedAscending;
            } else if ((self.update_time < object.update_time)) {
                result = NSOrderedDescending;
            } else {
                result = NSOrderedSame;
            }
        } else {
            result = NSOrderedSame;
        }
    }
    return result;
}

@end

@interface SMRUpdateStatusManager ()

@property (strong, nonatomic) id<SMRUpdateStatusManagerConfig> config;

@end

@implementation SMRUpdateStatusManager

#pragma mark - Based Use

+ (instancetype)sharedManager {
    static SMRUpdateStatusManager *_updateStatusManagerInstance = nil;
    static dispatch_once_t _updateStatusManagerOnceToken;
    dispatch_once(&_updateStatusManagerOnceToken, ^{
        _updateStatusManagerInstance = [[SMRUpdateStatusManager alloc] init];
    });
    return _updateStatusManagerInstance;
}

- (void)startWithConfig:(id<SMRUpdateStatusManagerConfig>)config {
    _config = config;
}

- (NSString *)userName {
    if ([self.config respondsToSelector:@selector(userName)]) {
        return [self.config userName];
    }
    return @"";
}

- (void)autoMakeStateReadIfNeededWithUpdateStatus:(SMRUpdateStatus *)updateStatus {
    if ([self.config respondsToSelector:@selector(shouldAutoReadWithStatus:)]) {
        BOOL autoMakeRead = [self.config shouldAutoReadWithStatus:updateStatus];
        if (autoMakeRead) {
            [self makeStateReadWithKey:updateStatus.key readTime:[[SMRNetInfo syncedDate] timeIntervalSince1970]];
        }
    }
}

- (void)makeMainStateReadWithKey:(NSString *)key {
    SMRUpdateStatus *updateStatus = [self getUpdateStatusWithKey:key];
    updateStatus.main_has_new = NO;
    [self setUpdateStatus:updateStatus];
}
- (void)makeStateReadWithKey:(NSString *)key readTime:(NSTimeInterval)readTime {
    SMRUpdateStatus *updateStatus = [self getUpdateStatusWithKey:key];
    updateStatus.main_has_new = NO;
    updateStatus.has_new = NO;
    updateStatus.count = 0;
    updateStatus.read_time = readTime;
    [self setUpdateStatus:updateStatus];
}

- (void)setUpdateStatus:(SMRUpdateStatus *)updateStatus {
    if (updateStatus.discrimination == NO) {
        [self insertOrReplaceUpdateStatus:updateStatus withUsername:_discriminationUserName];
        [self deleteUpdateStatusWithKey:updateStatus.key andUsername:self.userName];
    } else {
        [self insertOrReplaceUpdateStatus:updateStatus withUsername:self.userName];
        [self deleteUpdateStatusWithKey:updateStatus.key andUsername:_discriminationUserName];
    }
}

- (SMRUpdateStatus *)getUpdateStatusWithKey:(NSString *)key {
    // 先判断是不是被标记为不区分用户
    SMRUpdateStatus *updateStatus = [self selectUpdateStatusWithKey:key andUsername:_discriminationUserName];
    if (updateStatus == nil) {
        updateStatus = [self selectUpdateStatusWithKey:key andUsername:self.userName];
    }
    // 如果不存在会自动生成一个默认对象
    if (updateStatus == nil) {
        updateStatus = [[SMRUpdateStatus alloc] init];
        updateStatus.local_username = self.userName;
        updateStatus.key = key;
        updateStatus.isNotEmpty = NO;
    } else {
        updateStatus.isNotEmpty = YES;
    }
    return updateStatus;
}
- (SMRUpdateStatus *)getAndSetUpdateStatusWithKey:(NSString *)key updateTime:(NSTimeInterval)updateTime discriminationByUser:(BOOL)discriminationByUser {
    [self updateStatusWithKey:key updateTime:updateTime discriminationByUser:discriminationByUser];
    SMRUpdateStatus *updateStatus = [self getUpdateStatusWithKey:key];
    return updateStatus;
}

- (BOOL)updateStatusWithKey:(NSString *)key updateTime:(NSTimeInterval)updateTime discriminationByUser:(BOOL)discriminationByUser {
    SMRUpdateStatus *updateStatus = [self getUpdateStatusWithKey:key];
    // 比较更新时间最近的显示
    if ((updateTime > 0) && (updateStatus.update_time < updateTime) && (updateStatus.read_time < updateTime)) {
        updateStatus.update_time = updateTime;
        updateStatus.has_new = YES;
        updateStatus.main_has_new = YES;
        updateStatus.discrimination = discriminationByUser;
        [self setUpdateStatus:updateStatus];
        [self autoMakeStateReadIfNeededWithUpdateStatus:updateStatus];
        return YES;
    }
    return NO;
}

#pragma mark - Caches

- (SMRUpdateStatus *)selectUpdateStatusWithKey:(NSString *)key andUsername:(NSString *)userName {
    NSString *realKey = [NSString stringWithFormat:@"%@%@%@", _smr_update_status_prefix, key, userName];
    NSDictionary *result = [[NSUserDefaults standardUserDefaults] objectForKey:realKey];
    if (result && [result isKindOfClass:[NSDictionary class]]) {
        SMRUpdateStatus *status = [SMRUpdateStatus createUsingDict:result];
        return status;
    }
    return nil;
}

- (BOOL)insertOrReplaceUpdateStatus:(SMRUpdateStatus *)status withUsername:(NSString *)userName {
    NSDictionary *result = [status createDictionary];
    if (result) {
        NSString *realKey = [NSString stringWithFormat:@"%@%@%@", _smr_update_status_prefix, status.key, userName];
        [[NSUserDefaults standardUserDefaults] setObject:result forKey:realKey];
        return YES;
    }
    return NO;
}

- (BOOL)deleteUpdateStatusWithKey:(NSString *)key andUsername:(NSString *)userName {
    NSString *realKey = [NSString stringWithFormat:@"%@%@%@", _smr_update_status_prefix, key, userName];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:realKey];
    return YES;
}

#pragma mark - Advanced Use

+ (SMRUpdateStatus *)getUpdateStatusWithKey:(NSString *)key {
    SMRUpdateStatusManager *manager = [SMRUpdateStatusManager sharedManager];
    return [manager getUpdateStatusWithKey:key];
}

+ (SMRUpdateStatus *)getAndSetUpdateStatusWithKey:(NSString *)key updateTime:(NSTimeInterval)updateTime discriminationByUser:(BOOL)discrimination {
    SMRUpdateStatusManager *manager = [SMRUpdateStatusManager sharedManager];
    return [manager getAndSetUpdateStatusWithKey:key updateTime:updateTime discriminationByUser:discrimination];
}

+ (void)makeStateReadWithKey:(NSString *)key {
    SMRUpdateStatusManager *manager = [SMRUpdateStatusManager sharedManager];
    [manager makeStateReadWithKey:key readTime:[[SMRNetInfo syncedDate] timeIntervalSince1970]];
}

+ (void)makeMainStateReadWithKey:(NSString *)key {
    SMRUpdateStatusManager *manager = [SMRUpdateStatusManager sharedManager];
    [manager makeMainStateReadWithKey:key];
}

+ (BOOL)updateStatusWithKey:(NSString *)key updateTime:(int32_t)updateTime discriminationByUser:(BOOL)discrimination {
    SMRUpdateStatusManager *manager = [SMRUpdateStatusManager sharedManager];
    return [manager updateStatusWithKey:key updateTime:updateTime discriminationByUser:discrimination];
}

+ (void)setUpdateStatus:(SMRUpdateStatus *)updateStatus {
    SMRUpdateStatusManager *manager = [SMRUpdateStatusManager sharedManager];
    [manager setUpdateStatus:updateStatus];
}

#pragma mark - General Use

+ (kUpdateStatusType)getUpdateStatusTypeWithKey:(NSString *)key {
    SMRUpdateStatus *updateStatus = [self getUpdateStatusWithKey:key];
    return updateStatus.type;
}

+ (void)setUpdateStatusWithKey:(NSString *)key andType:(kUpdateStatusType)updateStatusType {
    SMRUpdateStatus *updateStatus = [[SMRUpdateStatus alloc] init];
    updateStatus.key = key;
    updateStatus.type = updateStatusType;
    [self setUpdateStatus:updateStatus];
}

@end
