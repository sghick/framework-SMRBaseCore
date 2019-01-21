//
//  SMRDBAdapter.m
//  SMRDBDemo
//
//  Created by 丁治文 on 2018/9/23.
//  Copyright © 2018年 sumrise.com. All rights reserved.
//

#import "SMRDBAdapter.h"

@implementation SMRDBAdapter

static SMRDBAdapter *_shareDBAdapter;

+ (instancetype)shareInstance {
    static dispatch_once_t onceTokenDBAdapter;
    dispatch_once(&onceTokenDBAdapter, ^{
        _shareDBAdapter = [[SMRDBAdapter alloc] init];
    });
    return _shareDBAdapter;
}

@end
