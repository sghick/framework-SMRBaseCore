//
//  SMRSession.h
//  SMRBaseCoreDemo
//
//  Created by 丁治文 on 2019/1/21.
//  Copyright © 2019 sumrise. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class SMRNetConfig;
@protocol SMRSessionConfigProtocol <NSObject>

@property (strong, nonatomic, readonly) SMRNetConfig *config;

@required
/** 初始化 */
- (void)configration:(SMRNetConfig *)config;

@optional
/** 加载网络状态变化监听器 */
- (void)configNetworkReachability:(SMRNetConfig *)config;
/** 加载网络请求时状态栏的indicator */
- (void)configNetworkActivityIndicator:(SMRNetConfig *)config;

@end

@protocol SMRSessionUtilsProtocol <NSObject>

@property (assign, nonatomic, readonly) BOOL reachable;         ///< 网络是否可用
@property (assign, nonatomic, readonly) BOOL reachableViaWWAN;  ///< WWAN网络(无线广域网)是否可用
@property (assign, nonatomic, readonly) BOOL reachableViaWiFi;  ///< WiFi网络是否可用

@end

@class SMRNetAPI;
@protocol SMRSessionProtocol <NSObject>

- (NSMutableURLRequest *)requestWithAPI:(SMRNetAPI *)api
                                  error:(NSError * _Nullable __autoreleasing *)error;

- (NSURLSessionDataTask *)dataTaskWithRequest:(NSURLRequest *)request
                               uploadProgress:(nullable void (^)(NSProgress *uploadProgress))uploadProgress
                             downloadProgress:(nullable void (^)(NSProgress *downloadProgress))downloadProgress
                            completionHandler:(nullable void (^)(NSURLResponse *response, id _Nullable responseObject, NSError * _Nullable error))completionHandler;

@end

@protocol AFMultipartFormData;
@protocol SMRSessionUploadProtocol <NSObject>

- (NSMutableURLRequest *)multipartFormRequestWithAPI:(SMRNetAPI *)api
                           constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block
                                               error:(NSError * _Nullable __autoreleasing *)error;

- (NSURLSessionUploadTask *)uploadTaskWithStreamedRequest:(NSURLRequest *)request
                                                 progress:(void (^)(NSProgress *uploadProgress))uploadProgress
                                        completionHandler:(void (^)(NSURLResponse *response, id responseObject, NSError *error))completionHandler;

@end

@class SMRNetDedouncer<SMRNetAPI>;
@interface SMRSession : NSObject<
SMRSessionConfigProtocol,
SMRSessionUtilsProtocol,
SMRSessionProtocol,
SMRSessionUploadProtocol>

/** 将session中定义的error转换成response */
- (id)parserToResponseWithError:(NSError *)error;

@end

NS_ASSUME_NONNULL_END
