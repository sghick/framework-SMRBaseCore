//
//  SMRWebConfig.m
//  SMRBaseCoreDemo
//
//  Created by 丁治文 on 2019/5/6.
//  Copyright © 2019 sumrise. All rights reserved.
//

#import "SMRWebConfig.h"

@implementation SMRWebConfig

+ (instancetype)sharedInstance {
    static SMRWebConfig *_webConfigInstance = nil;
    static dispatch_once_t _webConfigOnceToken;
    dispatch_once(&_webConfigOnceToken, ^{
        _webConfigInstance = [[SMRWebConfig alloc] init];
    });
    return _webConfigInstance;
}

@end
