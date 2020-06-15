//
//  SMRInitialConfig.m
//  SMRBaseCoreDemo
//
//  Created by Tinswin on 2020/6/15.
//  Copyright © 2020 sumrise. All rights reserved.
//

#import "SMRInitialConfig.h"

@interface SMRInitialConfig ()

@property (assign, nonatomic) Class cls;
@property (strong, nonatomic) id instance;

@end

@implementation SMRInitialConfig

- (instancetype)initWithClass:(Class)cls {
    self = [super init];
    if (self) {
        _cls = cls;
        _instance = [cls alloc];
    }
    return self;
}

+ (instancetype)configWithClass:(Class)cls {
    SMRInitialConfig *config = [[SMRInitialConfig alloc] initWithClass:cls];
    return config;
}

- (id)forwardingTargetForSelector:(SEL)aSelector {
    return self.instance;
}

@end

@interface SMRInitialManager ()

@property (strong, nonatomic) NSMutableDictionary<NSString *, SMRInitialConfig *> *configsMap;

@end

@implementation SMRInitialManager

+ (instancetype)shared {
    static SMRInitialManager *_initialManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _initialManager = [[SMRInitialManager alloc] init];
    });
    return _initialManager;
}

+ (id)configWithClass:(Class)cls {
    if (!cls) {
        return nil;
    }
    NSString *k = NSStringFromClass(cls);
    SMRInitialManager *manager = [SMRInitialManager shared];
    SMRInitialConfig *config = manager.configsMap[k];
    if (!config) {
        config = [SMRInitialConfig configWithClass:cls];
        manager.configsMap[k] = config;
    }
    return config;
}

- (NSMutableDictionary<NSString *,SMRInitialConfig *> *)configsMap {
    if (!_configsMap) {
        _configsMap = [NSMutableDictionary dictionary];
    }
    return _configsMap;
}

@end

@implementation NSObject (SMRInitialConfig)

+ (instancetype)initialConfig {
    return [SMRInitialManager configWithClass:self.class];
}

- (instancetype)initialConfig {
    return [self.class performSelector:@selector(initialConfig)];
}

@end
