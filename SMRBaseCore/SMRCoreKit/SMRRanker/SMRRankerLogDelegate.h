//
//  SMRRankerLogDelegate.h
//  SMRRankerDemo
//
//  Created by 丁治文 on 2018/8/12.
//  Copyright © 2018年 sumrise.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SMRRankerManager;
@class SMRRankerAction;
@protocol SMRRankerLogDelegate <NSObject>

- (void)didRankerManager:(SMRRankerManager *)manager recivedLog:(NSString *)recivedLog action:(SMRRankerAction *)action;

@end
