//
//  SMRNetAPIQueue.h
//  SMRBaseCoreDemo
//
//  Created by 丁治文 on 2019/1/21.
//  Copyright © 2019 sumrise. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class SMRNetAPI;
@interface SMRNetAPIQueue : NSObject

- (void)enqueue:(SMRNetAPI *)api;
- (SMRNetAPI *)dequeue;

@end

NS_ASSUME_NONNULL_END
