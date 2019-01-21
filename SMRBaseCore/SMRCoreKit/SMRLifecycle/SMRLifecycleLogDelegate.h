//
//  SMRLifecycleLogDelegate.h
//  SMRLifecycleDemo
//
//  Created by 丁治文 on 2018/7/18.
//  Copyright © 2018年 sumrise.com. All rights reserved.
//

#import <Foundation/Foundation.h>

/// 接收log的代理
@class SMRLifecycle;
@protocol SMRLifecycleLogDelegate <NSObject>

@required
- (void)didRecivedLifecycle:(SMRLifecycle *)lifecycle log:(NSString *)log;

@end
