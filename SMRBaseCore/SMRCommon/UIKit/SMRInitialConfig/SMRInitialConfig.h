//
//  SMRInitialConfig.h
//  SMRBaseCoreDemo
//
//  Created by Tinswin on 2020/6/15.
//  Copyright © 2020 sumrise. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol SMRInitialConfig <NSObject>

+ (instancetype)initialConfig;
- (instancetype)initialConfig;

@end

@interface SMRInitialConfig : NSObject

- (instancetype)init NS_UNAVAILABLE;

@end

@interface SMRInitialManager : NSObject

+ (id)configWithClass:(Class)cls;

@end

@interface NSObject (SMRInitialConfig)<SMRInitialConfig>

@end

NS_ASSUME_NONNULL_END
