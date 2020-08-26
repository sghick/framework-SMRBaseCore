//
//  SMRLifecycleLogDelegate.h
//  SMRBaseCoreDemo
//
//  Created by 丁治文 on 2018/12/17.
//  Copyright © 2018 BaoDashi. All rights reserved.
//

#ifndef SMRLifecycleLogDelegate_h
#define SMRLifecycleLogDelegate_h

/// 接收log的代理
@class SMRLifecycle;
@protocol SMRLifecycleLogDelegate <NSObject>

@required
- (void)didRecivedLifecycle:(SMRLifecycle *)lifecycle log:(NSString *)log;

@end

#endif /* SMRLifecycleLogDelegate_h */
