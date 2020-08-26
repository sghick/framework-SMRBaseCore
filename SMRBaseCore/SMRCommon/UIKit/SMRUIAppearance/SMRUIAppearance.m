//
//  SMRUIAppearance.m
//  SMRBaseCoreDemo
//
//  Created by Tinswin on 2020/7/23.
//  Copyright © 2020 sumrise. All rights reserved.
//

#import "SMRUIAppearance.h"

@interface _SMRUIAppearanceContainer : NSObject

@property (assign, nonatomic) Class cls;
@property (strong, nonatomic) id instance;

@end

@implementation _SMRUIAppearanceContainer

- (instancetype)initWithClass:(Class)cls {
    self = [super init];
    if (self) {
        _cls = cls;
        _instance = [cls alloc];
        [cls smr_beforeAppearance:_instance];
    }
    return self;
}

+ (instancetype)configWithClass:(Class)cls {
    _SMRUIAppearanceContainer *config = [[_SMRUIAppearanceContainer alloc] initWithClass:cls];
    return config;
}

- (id)forwardingTargetForSelector:(SEL)aSelector {
    return self.instance;
}

@end

@interface _SMRUIAppearanceManager : NSObject

@property (strong, nonatomic) NSMutableDictionary<NSString *, _SMRUIAppearanceContainer *> *containersMap;
+ (id)configWithClass:(Class)cls;

@end

@implementation _SMRUIAppearanceManager

+ (instancetype)shared {
    static _SMRUIAppearanceManager *_initialManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _initialManager = [[_SMRUIAppearanceManager alloc] init];
    });
    return _initialManager;
}

+ (id)configWithClass:(Class)cls {
    if (!cls) {
        return nil;
    }
    NSString *k = [self smr_keyForAppearance];
    _SMRUIAppearanceManager *manager = [_SMRUIAppearanceManager shared];
    _SMRUIAppearanceContainer *container = manager.containersMap[k];
    if (!container) {
        container = [_SMRUIAppearanceContainer configWithClass:cls];
        manager.containersMap[k] = container;
    }
    return container;
}

- (NSMutableDictionary<NSString *,_SMRUIAppearanceContainer *> *)containersMap {
    if (!_containersMap) {
        _containersMap = [NSMutableDictionary dictionary];
    }
    return _containersMap;
}

@end

@implementation NSObject (SMRUIAppearance)

+ (NSString *)smr_keyForAppearance {
    return NSStringFromClass(self.class);
}

+ (instancetype)smr_appearance {
    return [_SMRUIAppearanceManager configWithClass:self.class];
}

- (instancetype)smr_appearance {
    return [self.class smr_appearance];
}

+ (void)smr_beforeAppearance:(id)obj {
    
}

@end
