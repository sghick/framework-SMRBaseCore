//
//  SMRSession.h
//  SMRBaseCoreDemo
//
//  Created by 丁治文 on 2019/1/21.
//  Copyright © 2019 sumrise. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

NS_ASSUME_NONNULL_BEGIN

@class SMRNetAPI;
@protocol SMRSessionRetryDelegate <NSObject>

/// 是否需要重试
- (BOOL)willRetryWithError:(NSError *)error api:(SMRNetAPI *)api;

@end

@class SMRNetAPI;
@protocol SMRSessionAPIInitDelegate <NSObject>

/// 是否需要重试
- (BOOL)willQueryInitAPIWithError:(NSError *)error api:(SMRNetAPI *)api;

@end

@class SMRNetAPI;
@protocol SMRSessionProtocol <NSObject>

/** api.callback.cacheBlock will called while create datatask */
- (NSURLSessionDataTask *)smr_dataTaskWithAPI:(SMRNetAPI *)api;

@end

@class SMRNetCache;
@class SMRNetConfig;
@class SMRNetDedouncer<SMRNetAPI>;
@interface SMRSession : AFHTTPSessionManager<SMRSessionProtocol>

@property (strong, nonatomic, readonly) SMRNetCache *netCache;
@property (strong, nonatomic, readonly) SMRNetConfig *config;
@property (strong, nonatomic, readonly) SMRNetDedouncer<SMRNetAPI *> *dedouncer;
@property (weak  , nonatomic) id<SMRSessionRetryDelegate> retryDelegate;
@property (weak  , nonatomic) id<SMRSessionAPIInitDelegate> initDelegate;

- (void)configration:(SMRNetConfig *)config;

@end

NS_ASSUME_NONNULL_END
