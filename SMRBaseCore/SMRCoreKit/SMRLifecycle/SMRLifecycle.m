//
//  SMRLifecycle.m
//  SMRLifecycleDemo
//
//  Created by 丁治文 on 2018/7/17.
//  Copyright © 2018年 sumrise.com. All rights reserved.
//

#import "SMRLifecycle.h"

NSString * const kPrefixHeaderForLifecycleManager = @"kLifecycleADERIUASDKJ21349LKJAF3";

@interface SMRLifecycle ()

@property (nonatomic, assign) BOOL didInstalled;
@property (nonatomic, assign) BOOL didSetAppLaunch;
@property (nonatomic, weak  ) id<SMRLifecycleLogDelegate> logDelegate;

@end

@implementation SMRLifecycle
@synthesize isFirstLaunchForInstall = _isFirstLaunchForInstall;
@synthesize isFirstLaunchForVersion = _isFirstLaunchForVersion;
@synthesize launchUUID = _launchUUID;
@synthesize version = _version;
@synthesize customVersion = _customVersion;
@synthesize installUUID = _installUUID;

static SMRLifecycle *_lifecyclemanager = nil;
static dispatch_once_t _lifecyclemanageronceToken;

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initializeWithInstance:self];
    }
    return self;
}

+ (instancetype)shareInstance {
    dispatch_once(&_lifecyclemanageronceToken, ^{
        _lifecyclemanager = [[super alloc] init];
    });
    return _lifecyclemanager;
}

- (void)initializeWithInstance:(SMRLifecycle *)instance {
    _isFirstLaunchForVersion = YES;
    _isFirstLaunchForInstall = YES;
    _firstLaunchTime = [[NSDate date] timeIntervalSince1970];
    _version = [[NSUserDefaults standardUserDefaults]
                objectForKey:[NSString stringWithFormat:@"%@_%@", kPrefixHeaderForLifecycleManager, @"version"]];
    _customVersion = [[NSUserDefaults standardUserDefaults]
                      objectForKey:[NSString stringWithFormat:@"%@_%@", kPrefixHeaderForLifecycleManager, @"customVersion"]];
    _installUUID = [[NSUserDefaults standardUserDefaults]
                    objectForKey:[NSString stringWithFormat:@"%@_%@", kPrefixHeaderForLifecycleManager, @"installUUID"]];
}

#pragma mark - Log

- (void)cacheLog:(id<SMRLifecycleLogDelegate>)delegate {
    _logDelegate = delegate;
}

- (void)log:(NSString *)log {
    if ([self.logDelegate respondsToSelector:@selector(didRecivedLifecycle:log:)]) {
        [self.logDelegate didRecivedLifecycle:self log:log];
    }
}

#pragma mark - Setters

- (void)setIsFirstLaunchForInstall:(BOOL)isFirstLaunchForInstall {
    _isFirstLaunchForInstall = isFirstLaunchForInstall;
}

- (void)setIsFirstLaunchForVersion:(BOOL)isFirstLaunchForVersion {
    _isFirstLaunchForVersion = isFirstLaunchForVersion;
}

- (void)setLaunchUUID:(NSString *)launchUUID {
    _launchUUID = launchUUID;
}

- (void)setVersion:(NSString *)version {
    _version = version;
    [[NSUserDefaults standardUserDefaults] setObject:version forKey:[NSString stringWithFormat:@"%@_%@", kPrefixHeaderForLifecycleManager, @"version"]];
}

- (void)setCustomVersion:(NSString *)customVersion {
    _customVersion = customVersion;
    [[NSUserDefaults standardUserDefaults] setObject:customVersion forKey:[NSString stringWithFormat:@"%@_%@", kPrefixHeaderForLifecycleManager, @"customVersion"]];
}

- (void)setInstallUUID:(NSString *)installUUID {
    _installUUID = installUUID;
    [[NSUserDefaults standardUserDefaults] setObject:installUUID forKey:[NSString stringWithFormat:@"%@_%@", kPrefixHeaderForLifecycleManager, @"installUUID"]];
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

#pragma mark - Utils

- (void)markAppLaunch {
    NSString *didinstalledVersion = [[NSUserDefaults standardUserDefaults]
                                     objectForKey:[NSString stringWithFormat:@"%@_%@", kPrefixHeaderForLifecycleManager, @"didinstalledVersion"]];
    NSString *nextVersionCount = [self.version stringByAppendingString:@".n1"];
    // 设置首次安装的标记
    if (didinstalledVersion != nil) {
        NSArray *versionSplit = [didinstalledVersion componentsSeparatedByString:@".n"];
        NSString *lastVersion = versionSplit.firstObject;
        if ([self.version isEqualToString:lastVersion]) {
            // 不区分几次安装,非首次启动
            _isFirstLaunchForInstall = NO;
            _isFirstLaunchForVersion = NO;
            [[NSUserDefaults standardUserDefaults] setObject:nextVersionCount forKey:[NSString stringWithFormat:@"%@_%@", kPrefixHeaderForLifecycleManager, @"didinstalledVersion"]];
        } else {
            // 覆盖安装,首次启动
            _isFirstLaunchForInstall = NO;
            _isFirstLaunchForVersion = YES;
            [[NSUserDefaults standardUserDefaults] setObject:nextVersionCount forKey:[NSString stringWithFormat:@"%@_%@", kPrefixHeaderForLifecycleManager, @"didinstalledVersion"]];
        }
    } else {
        // 首次安装,首次启动
        _isFirstLaunchForInstall = YES;
        _isFirstLaunchForVersion = YES;
        [[NSUserDefaults standardUserDefaults] setObject:nextVersionCount forKey:[NSString stringWithFormat:@"%@_%@", kPrefixHeaderForLifecycleManager, @"didinstalledVersion"]];
    }
}

//private
- (BOOL)checkIfLifecycleChangedForLifecycleType:(SMRLifecycleType)lifecycleType lifecycleInfo:(NSDictionary *)lifecycleInfo {
    NSString *launchUUIDStr = lifecycleInfo[@"launchUUID"];
    NSString *versionStr = lifecycleInfo[@"version"];
    NSString *customVersionStr = lifecycleInfo[@"customVersion"];
    NSString *installUUIDStr = lifecycleInfo[@"installUUID"];
    BOOL lifecycleChanged = NO;
    switch (lifecycleType) {
        case SMRLifecycleTypeLaunch: {
            if (![self.launchUUID isEqualToString:launchUUIDStr]) {
                lifecycleChanged = YES;
            }
            break;
        }
        case SMRLifecycleTypeVersion: {
            if (![self.version isEqualToString:versionStr]) {
                lifecycleChanged = YES;
            }
            break;
        }
        case SMRLifecycleTypeCustomVersion: {
            if (![self.customVersion isEqualToString:customVersionStr]) {
                lifecycleChanged = YES;
            }
            break;
        }
        case SMRLifecycleTypeInstall: {
            if (![self.installUUID isEqualToString:installUUIDStr]) {
                lifecycleChanged = YES;
            }
            break;
        }
        default:
            break;
    }
    return lifecycleChanged;
}

- (BOOL)checkIfWithinLifecycleType:(SMRLifecycleType)lifecycleType checkcount:(NSInteger)checkcount withIdentifier:(NSString *)identifier {
    NSString *udKey = [NSString stringWithFormat:@"%@_%@", kPrefixHeaderForLifecycleManager, identifier];
    NSDictionary *lifecycleInfo = [[NSUserDefaults standardUserDefaults] objectForKey:udKey];
    // 更新当前的lifecyleType
    NSMutableDictionary *changedInfo = [lifecycleInfo mutableCopy];
    [changedInfo setObject:@(lifecycleType) forKey:@"lastCheckLifecycle"];
    [[NSUserDefaults standardUserDefaults] setObject:changedInfo forKey:udKey];
    // 判断生命周期是否变化
    NSNumber *curcountNum = lifecycleInfo[@"curcount"];
    BOOL lifecycleChanged = [self checkIfLifecycleChangedForLifecycleType:lifecycleType lifecycleInfo:lifecycleInfo];
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
                                   objectForKey:[NSString stringWithFormat:@"%@_%@", kPrefixHeaderForLifecycleManager, identifier]];
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
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:[NSString stringWithFormat:@"%@_%@", kPrefixHeaderForLifecycleManager, identifier]];
}

- (void)markSuccessCheckWithIdentifier:(NSString *)identifier {
    NSDictionary *lifecycleInfo = [[NSUserDefaults standardUserDefaults]
                                   objectForKey:[NSString stringWithFormat:@"%@_%@", kPrefixHeaderForLifecycleManager, identifier]];
    NSNumber *lastCheckLifecyleType = lifecycleInfo[@"lastCheckLifecycle"];
    NSNumber *curcountNum = lifecycleInfo[@"curcount"];
    NSMutableDictionary *mutInfo = [NSMutableDictionary dictionaryWithDictionary:lifecycleInfo];
    [mutInfo setObject:self.launchUUID?self.launchUUID:@"" forKey:@"launchUUID"];
    [mutInfo setObject:self.version?self.version:@"" forKey:@"version"];
    [mutInfo setObject:self.customVersion?self.customVersion:@"" forKey:@"customVersion"];
    [mutInfo setObject:self.installUUID?self.installUUID:@"" forKey:@"installUUID"];
    // 如果是lifecycle型的,生命周期发生变化后,将curcount重置
    [mutInfo setObject:@(curcountNum.integerValue + 1) forKey:@"curcount"];
    if (lastCheckLifecyleType) {
        BOOL lifecycleChanged = [self checkIfLifecycleChangedForLifecycleType:lastCheckLifecyleType.integerValue lifecycleInfo:lifecycleInfo];
        if (lifecycleChanged) {
            [mutInfo setObject:@(1) forKey:@"curcount"];
        }
    }
    [mutInfo setObject:@([[NSDate date] timeIntervalSince1970]) forKey:@"lastsuccesstime"];
    [[NSUserDefaults standardUserDefaults] setObject:[NSDictionary dictionaryWithDictionary:mutInfo]
                                              forKey:[NSString stringWithFormat:@"%@_%@", kPrefixHeaderForLifecycleManager, identifier]];
}

#pragma mark - Utils

+ (void)setAppLaunch {
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [self setAppLaunchWithVersion:version customVersion:nil];
}

+ (void)setAppLaunchWithVersion:(NSString *)version {
    [self setAppLaunchWithVersion:version customVersion:nil];
}
+ (void)setAppLaunchWithVersion:(NSString *)version customVersion:(NSString *)customVersion {
    SMRLifecycle *lifecycle = [SMRLifecycle shareInstance];
    if (lifecycle.didSetAppLaunch == NO) {
        lifecycle.didSetAppLaunch = YES;
        lifecycle.version = version?version:@"";
        lifecycle.customVersion = customVersion;
        // log
        [lifecycle log:[NSString stringWithFormat:@"launchUUID:%@", lifecycle.launchUUID]];
        [lifecycle log:[NSString stringWithFormat:@"version:%@", lifecycle.version]];
        [lifecycle log:[NSString stringWithFormat:@"customVersion:%@", lifecycle.customVersion]];
        [lifecycle log:[NSString stringWithFormat:@"installUUID:%@", lifecycle.installUUID]];
        // 标记App的启动
        [lifecycle markAppLaunch];
    }
}

+ (BOOL)checkIfWithinLifecycleType:(SMRLifecycleType)lifecycleType checkcount:(NSInteger)checkcount withIdentifier:(NSString *)identifier {
    SMRLifecycle *lifecycle = [SMRLifecycle shareInstance];
    return [lifecycle checkIfWithinLifecycleType:lifecycleType checkcount:checkcount withIdentifier:identifier];
}

+ (BOOL)checkIfWithinTimerinterval:(NSTimeInterval)timerinterval checkcount:(NSInteger)checkcount withIdentifier:(NSString *)identifier {
    SMRLifecycle *lifecycle = [SMRLifecycle shareInstance];
    return [lifecycle checkIfWithinTimerinterval:timerinterval checkcount:checkcount withIdentifier:identifier];
}

+ (void)markSuccessCheckWithIdentifier:(NSString *)identifier {
    SMRLifecycle *lifecycle = [SMRLifecycle shareInstance];
    [lifecycle markSuccessCheckWithIdentifier:identifier];
}

+ (void)clearLifecycleWithIdentifier:(NSString *)identifier {
    SMRLifecycle *lifecycle = [SMRLifecycle shareInstance];
    [lifecycle clearLifecycleWithIdentifier:identifier];
}

@end
