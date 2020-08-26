//
//  SMRDBGroupOption.h
//  SMRDataBaseDemo
//
//  Created by 丁治文 on 2018/12/18.
//  Copyright © 2018 sumrise. All rights reserved.
//

#import "SMRDBOption.h"

@interface SMRDBGroupOption : SMRDBOption

@property (nonatomic, copy) NSArray<id<SMRDBOption>> *options;

- (void)addOption:(id<SMRDBOption>)option;
- (void)addOptions:(NSArray<id<SMRDBOption>> *)options;

@end

