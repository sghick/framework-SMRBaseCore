//
//  SMRWebConfig.h
//  SMRBaseCoreDemo
//
//  Created by 丁治文 on 2019/5/6.
//  Copyright © 2019 sumrise. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol SMRWebReplaceConfig <NSObject>

/** YES为url有参数需要替换 */
- (BOOL)replaceUrl:(NSString *)url completionBlock:(void (^)(NSString *url))completionBlock;

@end

@interface SMRWebConfig : NSObject

@property (strong, nonatomic) id<SMRWebReplaceConfig> webReplaceConfig;

+ (instancetype)sharedInstance;

@end

NS_ASSUME_NONNULL_END
