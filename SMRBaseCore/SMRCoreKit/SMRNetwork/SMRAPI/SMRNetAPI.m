//
//  SMRNetAPI.m
//  SMRNetworkDemo
//
//  Created by 丁治文 on 2018/10/6.
//  Copyright © 2018年 sumrise.com. All rights reserved.
//

#import "SMRNetAPI.h"
#import "SMRNetCache.h"

@implementation SMRAPICallback

- (void)dealloc {
    _constructingBlock = nil;
    _cacheBlock = nil;
    _successBlock = nil;
    _faildBlock = nil;
    _uploadProgress = nil;
    _downloadProgress = nil;
    NSLog(@"释放对象:<%@: %p>", self.class, self);
}

/** 常用请求的回调方式1 */
+ (instancetype)callbackWithSuccessBlock:(SMRNetAPISuccessBlock)successBlock
                             faildBlock:(SMRNetAPIFaildBlock)faildBlock {
    return [self callbackWithConstructingBlock:nil cacheBlock:nil successBlock:successBlock faildBlock:faildBlock uploadProgress:nil downloadProgress:nil];
}

/** 常用请求的回调方式2 */
+ (instancetype)callbackWithCacheBlock:(SMRNetAPICacheBlock)cacheBlock
                         successBlock:(SMRNetAPISuccessBlock)successBlock
                           faildBlock:(SMRNetAPIFaildBlock)faildBlock {
    return [self callbackWithConstructingBlock:nil cacheBlock:cacheBlock successBlock:successBlock faildBlock:faildBlock uploadProgress:nil downloadProgress:nil];
}

/** GET请求的回调方式 */
+ (instancetype)callbackForGETWithCacheBlock:(SMRNetAPICacheBlock)cacheBlock
                                successBlock:(SMRNetAPISuccessBlock)successBlock
                                  faildBlock:(SMRNetAPIFaildBlock)faildBlock
                            downloadProgress:(SMRNetAPIDownloadProgressBlock)downloadProgress {
    return [self callbackWithConstructingBlock:nil cacheBlock:cacheBlock successBlock:successBlock faildBlock:faildBlock uploadProgress:nil downloadProgress:downloadProgress];
}

/** HEAD请求的回调方式 */
+ (instancetype)callbackForHEADWithCacheBlock:(SMRNetAPICacheBlock)cacheBlock
                                 successBlock:(SMRNetAPISuccessBlock)successBlock
                                   faildBlock:(SMRNetAPIFaildBlock)faildBlock {
    return [self callbackWithConstructingBlock:nil cacheBlock:cacheBlock successBlock:successBlock faildBlock:faildBlock uploadProgress:nil downloadProgress:nil];
}

/** POST请求的回调方式 */
+ (instancetype)callbackForPOSTWithCacheBlock:(SMRNetAPICacheBlock)cacheBlock
                                 successBlock:(SMRNetAPISuccessBlock)successBlock
                                   faildBlock:(SMRNetAPIFaildBlock)faildBlock
                               uploadProgress:(SMRNetAPIDownloadProgressBlock)uploadProgress {
    return [self callbackWithConstructingBlock:nil cacheBlock:cacheBlock successBlock:successBlock faildBlock:faildBlock uploadProgress:uploadProgress downloadProgress:nil];
}

/** POST请求的回调方式,MuiltPart形式 */
+ (instancetype)callbackForPOSTWithConstructingBlock:(SMRConstructingUploadBlock)constructingBlock
                                          cacheBlock:(SMRNetAPICacheBlock)cacheBlock
                                        successBlock:(SMRNetAPISuccessBlock)successBlock
                                          faildBlock:(SMRNetAPIFaildBlock)faildBlock
                                      uploadProgress:(SMRNetAPIUploadProgressBlock)uploadProgress {
    return [self callbackWithConstructingBlock:constructingBlock cacheBlock:cacheBlock successBlock:successBlock faildBlock:faildBlock uploadProgress:uploadProgress downloadProgress:nil];
}

/** PUT请求的回调方式 */
+ (instancetype)callbackForPUTWithCacheBlock:(SMRNetAPICacheBlock)cacheBlock
                                successBlock:(SMRNetAPISuccessBlock)successBlock
                                  faildBlock:(SMRNetAPIFaildBlock)faildBlock {
    return [self callbackWithConstructingBlock:nil cacheBlock:cacheBlock successBlock:successBlock faildBlock:faildBlock uploadProgress:nil downloadProgress:nil];
}

/** PATCH请求的回调方式 */
+ (instancetype)callbackForPATCHWithCacheBlock:(SMRNetAPICacheBlock)cacheBlock
                                  successBlock:(SMRNetAPISuccessBlock)successBlock
                                    faildBlock:(SMRNetAPIFaildBlock)faildBlock {
    return [self callbackWithConstructingBlock:nil cacheBlock:cacheBlock successBlock:successBlock faildBlock:faildBlock uploadProgress:nil downloadProgress:nil];
}

/** DELETE请求的回调方式 */
+ (instancetype)callbackForDELETEWithCacheBlock:(SMRNetAPICacheBlock)cacheBlock
                                   successBlock:(SMRNetAPISuccessBlock)successBlock
                                     faildBlock:(SMRNetAPIFaildBlock)faildBlock {
    return [self callbackWithConstructingBlock:nil cacheBlock:cacheBlock successBlock:successBlock faildBlock:faildBlock uploadProgress:nil downloadProgress:nil];
}

+ (instancetype)callbackWithConstructingBlock:(SMRConstructingUploadBlock)constructingBlock
                                   cacheBlock:(SMRNetAPICacheBlock)cacheBlock
                                 successBlock:(SMRNetAPISuccessBlock)successBlock
                                   faildBlock:(SMRNetAPIFaildBlock)faildBlock
                               uploadProgress:(SMRNetAPIUploadProgressBlock)uploadProgress
                             downloadProgress:(SMRNetAPIDownloadProgressBlock)downloadProgress {
    SMRAPICallback *callback = [[self alloc] init];
    callback.constructingBlock = constructingBlock;
    callback.cacheBlock = cacheBlock;
    callback.successBlock = successBlock;
    callback.faildBlock = faildBlock;
    callback.uploadProgress = uploadProgress;
    callback.downloadProgress = downloadProgress;
    return callback;
}

@end

SMRReqeustMethod const SMRReqeustMethodGET      = @"GET";
SMRReqeustMethod const SMRReqeustMethodHEAD     = @"HEAD";
SMRReqeustMethod const SMRReqeustMethodPOST     = @"POST";
SMRReqeustMethod const SMRReqeustMethodPUT      = @"PUT";
SMRReqeustMethod const SMRReqeustMethodPATCH    = @"PATCH";
SMRReqeustMethod const SMRReqeustMethodDELETE   = @"DELETE";

@implementation SMRNetAPI
@synthesize dataTask = _dataTask;
@synthesize response = _response;
@synthesize error = _error;

- (void)dealloc {
    NSLog(@"释放对象:<%@: %p>", self.class, self);
}

- (void)fillDataTask:(NSURLSessionTask *)dataTask {
    _dataTask = dataTask;
}
- (void)fillResponse:(id)response error:(NSError *)error {
    _response = response;
    _error = error;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@:\n\tidentifier=%@,\n\tmethod=%@,\n\thost=%@,\n\turl=%@,\n\tparams=%@,\n\tmaxReetryTime=%@\n", [super description], self.identifier, self.method, self.host, self.url, self.params, @(self.maxRetryTime)];
}

+ (instancetype)apiWithIdentifier:(NSString *)identifier method:(SMRReqeustMethod)method host:(NSString *)host url:(NSString *)url params:(NSDictionary *)params useCache:(BOOL)useCache {
    SMRNetAPI *api = [[[self class] alloc] init];
    api.identifier = identifier;
    api.method = method;
    api.host = host;
    api.url = url;
    api.params = params;
    api.cachePolicy = useCache?[SMRNetCachePolicy policyWithIdentifier:identifier cacheKey:url]:nil;
    api.timeoutInterval = 30;
    api.maxRetryTime = 0;
    api.reqeustType = SMRReqeustSerializerTypeJSON;
    api.responseType = SMRResponseSerializerTypeJSON;
    return api;
}

- (SMRAPICallback *)callback {
    if (!_callback) {
        _callback = [[SMRAPICallback alloc] init];
    }
    return _callback;
}

@end

@implementation SMRMultipartNetAPI

+ (instancetype)apiWithIdentifier:(NSString *)identifier
                             data:(id<AFMultipartFormData>)data
                             host:(NSString *)host
                              url:(NSString *)url
                           params:(NSDictionary *)params
                         useCache:(BOOL)useCache {
    SMRMultipartNetAPI *api = [self apiWithIdentifier:identifier method:SMRReqeustMethodPOST host:host url:url params:params useCache:useCache];
    api.data = data;
    return api;
}

@end
