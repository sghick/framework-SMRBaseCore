//
//  SMRRouterConfig.h
//  SMRRouterDemo
//
//  Created by 丁治文 on 2018/10/4.
//  Copyright © 2018年 sumrise.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SMRURLProvider.h"

@interface SMRRouterConfig : NSObject

/// 初始化入口
- (void)settingInit NS_REQUIRES_SUPER;

@property (nonatomic, strong) SMRURLProvider *urlProvider;

@end
