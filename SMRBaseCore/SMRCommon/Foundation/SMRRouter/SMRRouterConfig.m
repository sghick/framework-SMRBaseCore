//
//  SMRRouterConfig.m
//  SMRRouterDemo
//
//  Created by 丁治文 on 2018/12/14.
//  Copyright © 2018 sumrise. All rights reserved.
//

#import "SMRRouterConfig.h"

@implementation SMRRouterConfig

- (SMRURLProvider *)urlProvider {
    if (!_urlProvider) {
        _urlProvider = [[SMRURLProvider alloc] init];
        _urlProvider.parser = [[SMRRouterURLParser alloc] initWithTargetPrefix:@"SMRTarget" actionPrefix:@"action"];
    }
    return _urlProvider;
}

- (void)settingInit {
    
}

@end
