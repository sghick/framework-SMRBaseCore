//
//  SMRRankerLifecycleManager.m
//  SMRRankerDemo
//
//  Created by 丁治文 on 2018/7/28.
//  Copyright © 2018年 sumrise.com. All rights reserved.
//

#import "SMRRankerLifecycleManager.h"

NSString * const kPrefixHeaderForRankerLifecycle = @"kPrefixHeaderForRankerLifecycle";

@interface SMRRankerLifecycleManager ()

@property (nonatomic, assign) BOOL didSetAppLaunch;

@end

@implementation SMRRankerLifecycleManager
@synthesize launchUUID = _launchUUID;
@synthesize version = _version;
@synthesize installUUID = _installUUID;

static SMRRankerLifecycleManager *_rankerlifecyclemanager = nil;
static dispatch_once_t _rankerlifecyclemanageronceToken;

+ (void)load {
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    [[SMRRankerLifecycleManager shareInstance] setVersion:app_Version];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _version = [[NSUserDefaults standardUserDefaults]
                    objectForKey:[NSString stringWithFormat:@"%@_%@", kPrefixHeaderForRankerLifecycle, @"version"]];
        _installUUID = [[NSUserDefaults standardUserDefaults]
                        objectForKey:[NSString stringWithFormat:@"%@_%@", kPrefixHeaderForRankerLifecycle, @"installUUID"]];
    }
    return self;
}

+ (instancetype)shareInstance {
    dispatch_once(&_rankerlifecyclemanageronceToken, ^{
        _rankerlifecyclemanager = [[self alloc] init];
    });
    return _rankerlifecyclemanager;
}

#pragma mark - Setters

- (void)setLaunchUUID:(NSString *)launchUUID {
    _launchUUID = launchUUID;
}

- (void)setVersion:(NSString *)version {
    _version = version;
    [[NSUserDefaults standardUserDefaults] setObject:version forKey:[NSString stringWithFormat:@"%@_%@", kPrefixHeaderForRankerLifecycle, @"version"]];
}

- (void)setInstallUUID:(NSString *)installUUID {
    _installUUID = installUUID;
    [[NSUserDefaults standardUserDefaults] setObject:installUUID forKey:[NSString stringWithFormat:@"%@_%@", kPrefixHeaderForRankerLifecycle, @"installUUID"]];
}

#pragma mark - Getters

- (NSString *)launchUUID {
    if (_launchUUID == nil) {
        _launchUUID = [NSUUID UUID].UUIDString;
    }
    return _launchUUID;
}

- (NSString *)installUUID {
    if (_installUUID == nil) {
        self.installUUID = [NSUUID UUID].UUIDString;
    }
    return _installUUID;
}

//private
- (BOOL)checkIfLifecycleChangedForLifecycle:(SMRRankerLifecycle)lifecycle lifecycleInfo:(NSDictionary *)lifecycleInfo {
    NSString *launchUUIDStr = lifecycleInfo[@"launchUUID"];
    NSString *versionStr = lifecycleInfo[@"version"];
    NSString *installUUIDStr = lifecycleInfo[@"installUUID"];
    BOOL lifecycleChanged = NO;
    switch (lifecycle) {
        case SMRRankerLifecycleLaunch: {
            if (![self.launchUUID isEqualToString:launchUUIDStr]) {
                lifecycleChanged = YES;
            }
        }
            break;
        case SMRRankerLifecycleVersion: {
            if (![self.version isEqualToString:versionStr]) {
                lifecycleChanged = YES;
            }
        }
            break;
        case SMRRankerLifecycleInstall: {
            if (![self.installUUID isEqualToString:installUUIDStr]) {
                lifecycleChanged = YES;
            }
        }
            break;
            
        default:
            break;
    }
    return lifecycleChanged;
}

- (BOOL)checkIfWithinLifecycle:(SMRRankerLifecycle)lifecycle
                    checkcount:(NSInteger)checkcount
                withIdentifier:(NSString *)identifier {
    NSString *udKey = [NSString stringWithFormat:@"%@_%@", kPrefixHeaderForRankerLifecycle, identifier];
    NSDictionary *lifecycleInfo = [[NSUserDefaults standardUserDefaults] objectForKey:udKey];
    // 更新当前的lifecyleType
    NSMutableDictionary *changedInfo = [lifecycleInfo mutableCopy];
    [changedInfo setObject:@(lifecycle) forKey:@"lastCheckLifecycle"];
    [[NSUserDefaults standardUserDefaults] setObject:changedInfo forKey:udKey];
    // 判断生命周期是否变化
    NSNumber *curcountNum = lifecycleInfo[@"curcount"];
    BOOL lifecycleChanged = [self checkIfLifecycleChangedForLifecycle:lifecycle lifecycleInfo:lifecycleInfo];
    if (lifecycleChanged) {
        // 生命周期发生变化时,验证通过
        [self clearLifecycleWithIdentifier:identifier];
        return YES;
    } else if (checkcount == -1) {
        // 不限制次数
        return YES;
    } else if (curcountNum.integerValue < checkcount) {
        // 生命周期未发生变化时,在允许值范围内,验证通过
        return YES;
    } else {
        // 验证不能过
        return NO;
    }
}

- (BOOL)checkIfWithinTimerinterval:(NSTimeInterval)timerinterval checkcount:(NSInteger)checkcount withIdentifier:(NSString *)identifier {
    NSDictionary *lifecycleInfo = [[NSUserDefaults standardUserDefaults]
                                   objectForKey:[NSString stringWithFormat:@"%@_%@", kPrefixHeaderForRankerLifecycle, identifier]];
    NSNumber *curcountNum = lifecycleInfo[@"curcount"];
    NSNumber *lastsuccesstimeNum = lifecycleInfo[@"lastsuccesstime"];
    NSTimeInterval now = [[NSDate date] timeIntervalSince1970];
    BOOL lifecycleChanged = ((lastsuccesstimeNum.doubleValue + timerinterval) < now);
    if (lifecycleChanged) {
        // 生命周期发生变化时,验证通过
        [self clearLifecycleWithIdentifier:identifier];
        return YES;
    } else if (checkcount == -1) {
        // 不限制次数
        return YES;
    } else if (curcountNum.integerValue < checkcount) {
        // 生命周期未发生变化时,在允许值范围内,验证通过
        return YES;
    } else {
        // 验证不能过
        return NO;
    }
}

// private
- (void)clearLifecycleWithIdentifier:(NSString *)identifier {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:[NSString stringWithFormat:@"%@_%@", kPrefixHeaderForRankerLifecycle, identifier]];
}

- (void)markSuccessCheckWithIdentifier:(NSString *)identifier {
    NSDictionary *lifecycleInfo = [[NSUserDefaults standardUserDefaults]
                                   objectForKey:[NSString stringWithFormat:@"%@_%@", kPrefixHeaderForRankerLifecycle, identifier]];
    NSNumber *lastCheckLifecyleType = lifecycleInfo[@"lastCheckLifecycle"];
    NSNumber *curcountNum = lifecycleInfo[@"curcount"];
    NSMutableDictionary *mutInfo = [NSMutableDictionary dictionaryWithDictionary:lifecycleInfo];
    [mutInfo setObject:self.launchUUID?self.launchUUID:@"" forKey:@"launchUUID"];
    [mutInfo setObject:self.version?self.version:@"" forKey:@"version"];
    [mutInfo setObject:self.installUUID?self.installUUID:@"" forKey:@"installUUID"];
    // 如果是lifecycle型的,生命周期发生变化后,将curcount重置
    [mutInfo setObject:@(curcountNum.integerValue + 1) forKey:@"curcount"];
    if (lastCheckLifecyleType) {
        BOOL lifecycleChanged = [self checkIfLifecycleChangedForLifecycle:lastCheckLifecyleType.integerValue lifecycleInfo:lifecycleInfo];
        if (lifecycleChanged) {
            [mutInfo setObject:@(1) forKey:@"curcount"];
        }
    }
    [mutInfo setObject:@([[NSDate date] timeIntervalSince1970]) forKey:@"lastsuccesstime"];
    [[NSUserDefaults standardUserDefaults] setObject:[NSDictionary dictionaryWithDictionary:mutInfo]
                                              forKey:[NSString stringWithFormat:@"%@_%@", kPrefixHeaderForRankerLifecycle, identifier]];
}

#pragma mark - Utils

+ (void)setAppLaunchWithVersion:(NSString *)version {
    SMRRankerLifecycleManager *manager = [SMRRankerLifecycleManager shareInstance];
    if (manager.didSetAppLaunch == NO) {
        manager.didSetAppLaunch = YES;
        manager.version = version;
        NSLog(@"launchUUID:%@", manager.launchUUID);
        NSLog(@"version:%@", manager.version);
        NSLog(@"installUUID:%@", manager.installUUID);
    }
}

+ (BOOL)checkIfWithinLifecycle:(SMRRankerLifecycle)lifecycle checkcount:(NSInteger)checkcount withIdentifier:(NSString *)identifier {
    SMRRankerLifecycleManager *manager = [SMRRankerLifecycleManager shareInstance];
    return [manager checkIfWithinLifecycle:lifecycle checkcount:checkcount withIdentifier:identifier];
}

+ (BOOL)checkIfWithinTimerinterval:(NSTimeInterval)timerinterval checkcount:(NSInteger)checkcount withIdentifier:(NSString *)identifier {
    SMRRankerLifecycleManager *manager = [SMRRankerLifecycleManager shareInstance];
    return [manager checkIfWithinTimerinterval:timerinterval checkcount:checkcount withIdentifier:identifier];
}

+ (void)markSuccessCheckWithIdentifier:(NSString *)identifier {
    SMRRankerLifecycleManager *manager = [SMRRankerLifecycleManager shareInstance];
    [manager markSuccessCheckWithIdentifier:identifier];
}

+ (void)clearLifecycleWithIdentifier:(NSString *)identifier {
    SMRRankerLifecycleManager *manager = [SMRRankerLifecycleManager shareInstance];
    [manager clearLifecycleWithIdentifier:identifier];
}

@end
