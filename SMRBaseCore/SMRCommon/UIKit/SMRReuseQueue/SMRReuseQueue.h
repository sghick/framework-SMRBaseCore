//
//  SMRReuseQueue.h
//  SMRBaseCoreDemo
//
//  Created by Tinswin on 2020/7/25.
//  Copyright © 2020 Tinswin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef UIView *_Nullable(^SMRReuseQueueCreator)(Class cls, id tag);

@interface SMRReuseQueue : NSObject

- (__kindof UIView *)dequeueWithTag:(id)tag;

- (void)registerClass:(Class)cls forTag:(id)tag;
- (void)registerClass:(Class)cls forTag:(id)tag creator:(nullable SMRReuseQueueCreator)creator;

- (void)clear;
- (void)clearForTag:(id)tag;

@end

NS_ASSUME_NONNULL_END
