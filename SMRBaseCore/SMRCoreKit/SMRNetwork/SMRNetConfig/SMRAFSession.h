//
//  SMRAFSession.h
//  SMRBaseCoreDemo
//
//  Created by Tinswin on 2020/4/20.
//  Copyright © 2020 sumrise. All rights reserved.
//

#import "SMRSession.h"
#import <AFNetworking/AFNetworking.h>

NS_ASSUME_NONNULL_BEGIN

@interface SMRAFSession : SMRSession

@property (strong, nonatomic, readonly) AFHTTPSessionManager *manager;

@end

NS_ASSUME_NONNULL_END
