//
//  SMRRouterConfig.h
//  SMRRouterDemo
//
//  Created by 丁治文 on 2018/12/14.
//  Copyright © 2018 sumrise. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SMRURLProvider.h"

NS_ASSUME_NONNULL_BEGIN

@interface SMRRouterConfig : NSObject

@property (nonatomic, strong) SMRURLProvider *urlProvider;

- (void)settingInit NS_REQUIRES_SUPER;

@end

NS_ASSUME_NONNULL_END
