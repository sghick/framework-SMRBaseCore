//
//  SMRBaseCoreConfig.m
//  SMRBaseCoreDemo
//
//  Created by 丁治文 on 2019/5/6.
//  Copyright © 2019 sumrise. All rights reserved.
//

#import "SMRBaseCoreConfig.h"

@implementation SMRBaseCoreConfig

+ (instancetype)sharedInstance {
    static SMRBaseCoreConfig *_baseCoreConfigInstance = nil;
    static dispatch_once_t _baseCoreConfigOnceToken;
    dispatch_once(&_baseCoreConfigOnceToken, ^{
        _baseCoreConfigInstance = [[SMRBaseCoreConfig alloc] init];
    });
    return _baseCoreConfigInstance;
}

- (void)configInitialization {
    // 设置生命周期标记
    [SMRLifecycle setAppLaunch];
    // 初始化数据库
    if (self.dbName) {
        [[SMRFMDBManager sharedInstance] connectDatabaseWithName:self.dbName withVersion:self.dbVersion];
    }
    // 设置debug模式
    [SMRDebug startDebugIfNeeded];
}

#pragma mark - Setters BaseCore

- (void)setNetConfig:(SMRNetConfig *)netConfig {
    _netConfig = netConfig;
    [[SMRNetManager sharedManager] startWithConfig:netConfig];
}

- (void)setRouterConfig:(SMRRouterConfig *)routerConfig {
    _routerConfig = routerConfig;
    [[SMRRouterCenter sharedCenter] startWithConfig:routerConfig];
}

- (void)setWebReplaceConfig:(id<SMRWebReplaceConfig>)webReplaceConfig {
    _webReplaceConfig = webReplaceConfig;
    [SMRWebConfig sharedInstance].webReplaceConfig = webReplaceConfig;
}

#pragma mark - Setters BaseUI

- (void)setAppearanceBlock:(NavigationViewAppearanceBlock)appearanceBlock {
    _appearanceBlock = appearanceBlock;
    [SMRNavigationView appearance].appearanceBlock = appearanceBlock;
}

#pragma mark - Setters BaseUtils

@end
