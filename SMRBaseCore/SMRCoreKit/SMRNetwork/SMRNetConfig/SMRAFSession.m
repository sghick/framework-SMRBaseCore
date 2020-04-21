//
//  SMRAFSession.m
//  SMRBaseCoreDemo
//
//  Created by Tinswin on 2020/4/20.
//  Copyright © 2020 sumrise. All rights reserved.
//

#import "SMRAFSession.h"
#import "SMRNetManager.h"
#import "SMRNetConfig.h"
#import "SMRNetAPI.h"
#import "SMRLog.h"

#import "AFNetworkReachabilityManager.h"
#import "AFNetworkActivityIndicatorManager.h"

@interface SMRAFSession ()

@end

@implementation SMRAFSession

- (id)parserToResponseWithError:(NSError *)error {
    id data = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
    if (data && [data isKindOfClass:[NSData class]]) {
        id responseObject = nil;
        if ([NSJSONSerialization isValidJSONObject:data]) {
            responseObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        } else {
            responseObject = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        }
        return responseObject;
    } else {
        return [super parserToResponseWithError:error];
    }
}

#pragma mark - SMRSessionConfigProtocol

- (void)configration:(SMRNetConfig *)config {
    [super configration:config];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    _manager = manager;
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.requestSerializer.HTTPMethodsEncodingParametersInURI = [self.config HTTPMethodsEncodingParametersInURI];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [config setForAcceptableContentTypes];
    manager.responseSerializer.acceptableStatusCodes = [config setForAcceptableStatusCodes];
    // 允许非正式颁发机构证书
    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
}

- (void)configNetworkReachability:(SMRNetConfig *)config {
    if ([config enableNetworkReachability]) {
        [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            SMRNetworkReachabilityStatus st = (SMRNetworkReachabilityStatus)status;
            [config didChangedNetworkWithWithStatus:st];
        }];
        [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    }
}

- (void)configNetworkActivityIndicator:(SMRNetConfig *)config {
    [AFNetworkActivityIndicatorManager sharedManager].enabled = [config enableForStatuBarIndicator];
}

#pragma mark - BDSSessionUtilsProtocol

- (BOOL)reachable {
    return [AFNetworkReachabilityManager sharedManager].isReachable;
}

- (BOOL)reachableViaWWAN {
    return [AFNetworkReachabilityManager sharedManager].isReachableViaWWAN;
}

- (BOOL)reachableViaWiFi {
    return [AFNetworkReachabilityManager sharedManager].isReachableViaWiFi;
}

#pragma mark - SMRSessionDelegate

- (NSMutableURLRequest *)requestWithAPI:(SMRNetAPI *)api
                                  error:(NSError * _Nullable __autoreleasing * _Nullable)error {
    AFHTTPSessionManager *manager = self.manager;
    // 创建request对象
    NSString *apiURLStr = [NSString stringWithFormat:@"%@%@", api.host?:@"", api.url?:@""];
    NSMutableURLRequest *request =
    [manager.requestSerializer requestWithMethod:api.method
                                       URLString:[[NSURL URLWithString:apiURLStr relativeToURL:manager.baseURL] absoluteString]
                                      parameters:api.params
                                           error:error];
    return request;
}

- (NSURLSessionDataTask *)dataTaskWithRequest:(NSURLRequest *)request
                               uploadProgress:(nullable void (^)(NSProgress *uploadProgress))uploadProgress
                             downloadProgress:(nullable void (^)(NSProgress *downloadProgress))downloadProgress
                            completionHandler:(nullable void (^)(NSURLResponse *response, id _Nullable responseObject,  NSError * _Nullable error))completionHandler {
    AFHTTPSessionManager *manager = self.manager;
    NSURLSessionDataTask *dataTask =
    [manager dataTaskWithRequest:request
                  uploadProgress:uploadProgress
                downloadProgress:downloadProgress
               completionHandler:completionHandler];
    return dataTask;
}

#pragma mark - SMRSessionUploadProtocol

- (NSMutableURLRequest *)multipartFormRequestWithAPI:(SMRNetAPI *)api
                           constructingBodyWithBlock:(void (^)(id<AFMultipartFormData> _Nonnull))block
                                               error:(NSError * _Nullable __autoreleasing *)error {
    AFHTTPSessionManager *manager = self.manager;
    // 创建request对象
    NSString *apiURLStr = [NSString stringWithFormat:@"%@%@", api.host?:@"", api.url?:@""];
    NSMutableURLRequest *request =
    [manager.requestSerializer multipartFormRequestWithMethod:api.method
                                                    URLString:[[NSURL URLWithString:apiURLStr relativeToURL:manager.baseURL] absoluteString]
                                                   parameters:api.params
                                    constructingBodyWithBlock:block
                                                        error:error];
    return request;
}

- (NSURLSessionUploadTask *)uploadTaskWithStreamedRequest:(NSURLRequest *)request
                                                 progress:(void (^)(NSProgress * _Nonnull))uploadProgress
                                        completionHandler:(void (^)(NSURLResponse * _Nonnull, id _Nonnull, NSError * _Nonnull))completionHandler {
    AFHTTPSessionManager *manager = self.manager;
    NSURLSessionUploadTask *dataTask =
    [manager uploadTaskWithStreamedRequest:request progress:uploadProgress completionHandler:completionHandler];
    return dataTask;
}

@end
