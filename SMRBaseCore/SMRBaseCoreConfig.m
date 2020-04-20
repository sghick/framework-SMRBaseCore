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
    // 初始化UserAgent
    [SMRPhoneInfo webUserAgentForWK:^(NSString * _Nonnull ua) {
        [SMRAppInfo setWebPureUserAgent:ua];
    }];
    // 初始化数据库
    if (self.dbName) {
        [[SMRFMDBManager sharedInstance] connectDatabaseWithName:self.dbName withVersion:self.dbVersion];
    }
    [[SMRNetManager sharedManager] startWithSession:self.session config:self.netConfig];
}

#pragma mark - Setters BaseCore

- (void)setRouterConfig:(SMRRouterConfig *)routerConfig {
    _routerConfig = routerConfig;
    [[SMRRouterCenter sharedCenter] startWithConfig:routerConfig];
}

- (void)setWebReplaceConfig:(id<SMRWebReplaceConfig>)webReplaceConfig {
    _webReplaceConfig = webReplaceConfig;
    [SMRWebConfig shareConfig].webReplaceConfig = webReplaceConfig;
}

- (void)setWebNavigationViewConfig:(id<SMRWebNavigationViewConfig>)webNavigationViewConfig {
    _webNavigationViewConfig = webNavigationViewConfig;
    [SMRWebConfig shareConfig].webNavigationViewConfig = webNavigationViewConfig;
}

- (void)setWebJSRegisterConfig:(id<SMRWebJSRegisterConfig>)webJSRegisterConfig {
    _webJSRegisterConfig = webJSRegisterConfig;
    [SMRWebConfig shareConfig].webJSRegisterConfig = webJSRegisterConfig;
}

#pragma mark - Setters BaseUI

- (void)setAppearanceBlock:(NavigationViewAppearanceBlock)appearanceBlock {
    _appearanceBlock = appearanceBlock;
    [SMRNavigationView appearance].appearanceBlock = appearanceBlock;
}

#pragma mark - Setters BaseUtils

- (void)setUpdateStatusManagerConfig:(id<SMRUpdateStatusManagerConfig>)updateStatusManagerConfig {
    _updateStatusManagerConfig = updateStatusManagerConfig;
    [[SMRUpdateStatusManager sharedManager] startWithConfig:updateStatusManagerConfig];
}

@end
