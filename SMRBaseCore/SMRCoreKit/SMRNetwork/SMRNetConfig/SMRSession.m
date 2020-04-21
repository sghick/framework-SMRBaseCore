//
//  SMRSession.m
//  SMRBaseCoreDemo
//
//  Created by 丁治文 on 2019/1/21.
//  Copyright © 2019 sumrise. All rights reserved.
//

#import "SMRSession.h"
#import "SMRNetManager.h"
#import "SMRNetConfig.h"
#import "SMRNetAPI.h"
#import "NSURL+BaseCore.h"
#import "NSError+SMRNetwork.h"
#import "SMRLog.h"

@interface SMRSession ()

@property (strong, nonatomic) NSURLSession *session;

@end

@implementation SMRSession
@synthesize config = _config;

- (id)parserToResponseWithError:(NSError *)error {
    return error.userInfo[NSLocalizedDescriptionKey];
}

#pragma mark - SMRSessionConfigProtocol

- (void)configration:(SMRNetConfig *)config {
    _config = config;
    [_config configPrepare];
    // 加载网络变化监听器
    [self configNetworkReachability:config];
    // 加载网络请求时,状态栏的indicator
    [self configNetworkActivityIndicator:config];
}

- (void)configNetworkReachability:(SMRNetConfig *)config {
    
}

- (void)configNetworkActivityIndicator:(SMRNetConfig *)config {
    
}

#pragma mark - SMRSessionUtilsProtocol

- (BOOL)reachable {
    NSAssert(nil, @"未实现此方法");
    return YES;
}

- (BOOL)reachableViaWWAN {
    NSAssert(nil, @"未实现此方法");
    return YES;
}

- (BOOL)reachableViaWiFi {
    NSAssert(nil, @"未实现此方法");
    return YES;
}

#pragma mark - SMRSessionDelegate

- (NSMutableURLRequest *)requestWithAPI:(SMRNetAPI *)api
                                  error:(NSError * _Nullable __autoreleasing * _Nullable)error {
    NSSet<NSString *> *URIs = self.config.HTTPMethodsEncodingParametersInURI;
    BOOL urlParams = [URIs containsObject:api.method.uppercaseString];
    NSMutableURLRequest *mutableRequest = [self p_requestWithAPI:api error:error urlParams:urlParams];
    return mutableRequest;
}

- (NSURLSessionDataTask *)dataTaskWithRequest:(NSURLRequest *)request
                               uploadProgress:(nullable void (^)(NSProgress *uploadProgress))uploadProgress
                             downloadProgress:(nullable void (^)(NSProgress *downloadProgress))downloadProgress
                            completionHandler:(nullable void (^)(NSURLResponse *response, id _Nullable responseObject,  NSError * _Nullable error))completionHandler {
    NSURLSessionDataTask *dataTask = [self.session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (completionHandler) {
            id responseObject = [self p_responseObjectForResponse:response data:data error:&error];
            completionHandler(response, responseObject, error);
        }
    }];
    return dataTask;
}

#pragma mark - SMRSessionUploadProtocol

- (NSMutableURLRequest *)multipartFormRequestWithAPI:(SMRNetAPI *)api
                           constructingBodyWithBlock:(void (^)(id<AFMultipartFormData> _Nonnull))block
                                               error:(NSError * _Nullable __autoreleasing *)error {
    return nil;
}


- (NSURLSessionUploadTask *)uploadTaskWithStreamedRequest:(NSURLRequest *)request
                                                 progress:(void (^)(NSProgress *uploadProgress))uploadProgress
                                        completionHandler:(void (^)(NSURLResponse *response, id responseObject, NSError *error))completionHandler {
    return nil;
}

#pragma mark - RequestSerialization

- (NSMutableURLRequest *)p_requestWithAPI:(SMRNetAPI *)api error:(NSError * _Nullable __autoreleasing *)error urlParams:(BOOL)urlParams {
    NSString *apiURLStr = [NSString stringWithFormat:@"%@%@", api.host?:@"", api.url?:@""];
    NSURL *url = [NSURL URLWithString:apiURLStr];
    NSMutableURLRequest *mutableRequest = [[NSMutableURLRequest alloc] initWithURL:url];
    mutableRequest.HTTPMethod = api.method;
    
    NSDictionary *params = api.params;
    if (urlParams) {
        url = [url smr_URLByAppendParams:params];
        mutableRequest.URL = url;
    } else {
        if (![mutableRequest valueForHTTPHeaderField:@"Content-Type"]) {
            [mutableRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        }
        
        if (params) {
            if (![NSJSONSerialization isValidJSONObject:params]) {
                if (error) {
                    *error = [NSError smr_errorWithDomain:SMRNetworkDomain
                                                     code:0
                                                   detail:@""
                                                  message:@""
                                                 userInfo:nil];
                }
                return nil;
            }
            NSJSONWritingOptions options = NSJSONWritingPrettyPrinted;
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:params options:options error:error];
            if (!jsonData) {
                return nil;
            }
            [mutableRequest setHTTPBody:jsonData];
        } else {
            // 支持写在url上的参数
            NSString *query = url.query ?: @"";
            [mutableRequest setHTTPBody:[query dataUsingEncoding:NSUTF8StringEncoding]];
        }
    }
    return mutableRequest;
}

#pragma mark - ResponseSerialization

- (id)p_responseObjectForResponse:(NSURLResponse *)response
                             data:(NSData *)data
                            error:(NSError *__autoreleasing *)error {
    if (![self p_validateResponse:(NSHTTPURLResponse *)response data:data error:error]) {
        if (!error) {
            return nil;
        }
    }

    // Workaround for behavior of Rails to return a single space for `head :ok` (a workaround for a bug in Safari), which is not interpreted as valid input by NSJSONSerialization.
    // See https://github.com/rails/rails/issues/1742
    BOOL isSpace = [data isEqualToData:[NSData dataWithBytes:" " length:1]];
    
    if (data.length == 0 || isSpace) {
        return nil;
    }
    
    NSError *serializationError = nil;
    
    NSJSONReadingOptions readingOptions = NSJSONReadingMutableContainers;
    id responseObject = [NSJSONSerialization JSONObjectWithData:data options:readingOptions error:&serializationError];

    if (!responseObject) {
        if (error) {
            *error = [NSError smr_error:serializationError underlyingError:*error];
        }
        return nil;
    }

    return responseObject;
}

- (BOOL)p_validateResponse:(NSHTTPURLResponse *)response
                      data:(NSData *)data
                     error:(NSError * __autoreleasing *)error {
    BOOL responseIsValid = YES;
    NSError *validationError = nil;

    NSSet *acceptableContentTypes = self.config.setForAcceptableContentTypes;
    if (response && [response isKindOfClass:[NSHTTPURLResponse class]]) {
        if (acceptableContentTypes && ![acceptableContentTypes containsObject:response.MIMEType] &&
            !(!response.MIMEType && !data.length)) {
            if (data.length && response.URL) {
                NSError *err = nil;
                if (data) {
                    id response = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                    if (!response) {
                        response = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                    }
                    err = [NSError smr_errorWithDomain:SMRNetworkDomain
                                                  code:0
                                                detail:@"不支持的解析类型"
                                               message:nil
                                              userInfo:@{NSLocalizedDescriptionKey:response?:data}];
                }
                validationError = [NSError smr_error:err underlyingError:validationError];
            }
            responseIsValid = NO;
        }

        NSIndexSet *acceptableStatusCodes = self.config.setForAcceptableStatusCodes;
        if (acceptableStatusCodes && ![acceptableStatusCodes containsIndex:(NSUInteger)response.statusCode] && response.URL) {
            NSError *err = nil;
            if (data) {
                id response = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                if (!response) {
                    response = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                }
                err = [NSError smr_errorWithDomain:SMRNetworkDomain
                                              code:0
                                            detail:@"服务器错误"
                                           message:nil
                                          userInfo:@{NSLocalizedDescriptionKey:response?:data}];
            }
            validationError = [NSError smr_error:err underlyingError:validationError];
            responseIsValid = NO;
        }
    }

    if (error && !responseIsValid) {
        *error = validationError;
    }
    return responseIsValid;
}

#pragma mark - Getters

- (NSURLSession *)session {
    if (!_session) {
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        _session = [NSURLSession sessionWithConfiguration:configuration];
    }
    return _session;
}


@end
