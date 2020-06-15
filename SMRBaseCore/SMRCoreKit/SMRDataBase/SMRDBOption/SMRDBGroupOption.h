//
//  SMRDBGroupOption.h
//  SMRDBDemo
//
//  Created by 丁治文 on 2018/9/23.
//  Copyright © 2018年 sumrise.com. All rights reserved.
//

#import "SMRDBOption.h"

@interface SMRDBGroupOption : SMRDBOption

@property (nonatomic, copy) NSArray<id<SMRDBOption>> *options;

- (void)addOption:(id<SMRDBOption>)option;
- (void)addOptions:(NSArray<id<SMRDBOption>> *)options;

@end
