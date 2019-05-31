//
//  SMRUpdateStatusManager.m
//  SMRBaseCoreDemo
//
//  Created by 丁治文 on 2019/5/31.
//  Copyright © 2019 sumrise. All rights reserved.
//

#import "SMRUpdateStatusManager.h"
#import "SMRNetInfo.h"

@implementation SMRUpdateStatus

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

- (void)makeMainStateReadWithKey:(NSString *)key {
    
}
- (void)makeStateReadWithKey:(NSString *)key readTime:(NSTimeInterval)readTime {
    
}

- (void)setUpdateStatus:(SMRUpdateStatus *)updateStatus {
    
}

- (SMRUpdateStatus *)getUpdateStatusWithKey:(NSString *)key {
    return nil;
}
- (SMRUpdateStatus *)getAndSetUpdateStatusWithKey:(NSString *)key updateTime:(NSTimeInterval)updateTime discriminationByUser:(BOOL)discriminationByUser {
    return nil;
}

- (BOOL)updateStatusWithKey:(NSString *)key updateTime:(NSTimeInterval)updateTime discriminationByUser:(BOOL)discriminationByUser {
    return NO;
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
