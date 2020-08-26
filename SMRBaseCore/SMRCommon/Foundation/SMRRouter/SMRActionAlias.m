//
//  SMRActionAlias.m
//  SMRBaseCoreDemo
//
//  Created by 丁治文 on 2019/7/8.
//  Copyright © 2019 sumrise. All rights reserved.
//

#import "SMRActionAlias.h"

@implementation SMRActionAlias
@synthesize alias = _alias;

+ (instancetype)sharedAlias {
    static SMRActionAlias *_sharedAlias = nil;
    static dispatch_once_t _sharedAliasOnceToken;
    dispatch_once(&_sharedAliasOnceToken, ^{
        _sharedAlias = [[SMRActionAlias alloc] init];
    });
    return _sharedAlias;
}

- (NSMutableDictionary *)alias {
    if (!_alias) {
        _alias = [NSMutableDictionary dictionary];
    }
    return _alias;
}

@end
