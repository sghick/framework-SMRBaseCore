//
//  SMRDBAdapter.m
//  SMRDataBaseDemo
//
//  Created by 丁治文 on 2018/12/18.
//  Copyright © 2018 sumrise. All rights reserved.
//

#import "SMRDBAdapter.h"
#import "SMRLog.h"

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
