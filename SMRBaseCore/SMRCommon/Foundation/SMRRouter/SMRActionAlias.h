//
//  SMRActionAlias.h
//  SMRBaseCoreDemo
//
//  Created by 丁治文 on 2019/7/8.
//  Copyright © 2019 sumrise. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SMRActionAlias : NSObject

@property (strong, nonatomic, readonly) NSMutableDictionary *alias;

+ (instancetype)sharedAlias;

@end

NS_ASSUME_NONNULL_END
