//
//  SMRNetAPI.h
//  SMRNetworkDemo
//
//  Created by 丁治文 on 2018/10/6.
//  Copyright © 2018年 sumrise.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SMRNetAPI;
@protocol AFMultipartFormData;
typedef void(^SMRConstructingUploadBlock)(SMRNetAPI *api, id <AFMultipartFormData> formData);
typedef void(^SMRNetAPICacheBlock)(SMRNetAPI *api, id response);
typedef void(^SMRNetAPISuccessBlock)(SMRNetAPI *api, id response);
typedef void(^SMRNetAPIFaildBlock)(SMRNetAPI *api, id response, NSError *error);
typedef void(^SMRNetAPIUploadProgressBlock)(SMRNetAPI *api, NSProgress *uploadProgress);
typedef void(^SMRNetAPIDownloadProgressBlock)(SMRNetAPI *api, NSProgress *downloadProgress);

@interface SMRAPICallback : NSObject

@property (assign, nonatomic) NSTimeInterval groupTagForDedounce;   ///< 防止抖动的tag
@property (assign, nonatomic) NSInteger retryCount;                 ///< API重试次数记录

@property (copy  , nonatomic) SMRConstructingUploadBlock constructingBlock;
@property (copy  , nonatomic) SMRNetAPICacheBlock cacheBlock;
@property (copy  , nonatomic) SMRNetAPISuccessBlock successBlock;
@property (copy  , nonatomic) SMRNetAPIFaildBlock faildBlock;
@property (copy  , nonatomic) SMRNetAPIUploadProgressBlock uploadProgress;
@property (copy  , nonatomic) SMRNetAPIDownloadProgressBlock downloadProgress;

/** 常用请求的回调方式1 */
+ (instancetype)callbackWithSuccessBlock:(SMRNetAPISuccessBlock)successBlock
                             faildBlock:(SMRNetAPIFaildBlock)faildBlock;

/** 常用请求的回调方式2 */
+ (instancetype)callbackWithCacheBlock:(SMRNetAPICacheBlock)cacheBlock
                         successBlock:(SMRNetAPISuccessBlock)successBlock
                           faildBlock:(SMRNetAPIFaildBlock)faildBlock;

/** GET请求的回调方式 */
+ (instancetype)callbackForGETWithCacheBlock:(SMRNetAPICacheBlock)cacheBlock
                                successBlock:(SMRNetAPISuccessBlock)successBlock
                                  faildBlock:(SMRNetAPIFaildBlock)faildBlock
                            downloadProgress:(SMRNetAPIDownloadProgressBlock)downloadProgress;

/** HEAD请求的回调方式 */
+ (instancetype)callbackForHEADWithCacheBlock:(SMRNetAPICacheBlock)cacheBlock
                                 successBlock:(SMRNetAPISuccessBlock)successBlock
                                   faildBlock:(SMRNetAPIFaildBlock)faildBlock;

/** POST请求的回调方式 */
+ (instancetype)callbackForPOSTWithCacheBlock:(SMRNetAPICacheBlock)cacheBlock
                                 successBlock:(SMRNetAPISuccessBlock)successBlock
                                   faildBlock:(SMRNetAPIFaildBlock)faildBlock
                               uploadProgress:(SMRNetAPIDownloadProgressBlock)uploadProgress;

/** POST请求的回调方式,MuiltPart形式 */
+ (instancetype)callbackForPOSTWithConstructingBlock:(SMRConstructingUploadBlock)constructingBlock
                                          cacheBlock:(SMRNetAPICacheBlock)cacheBlock
                                        successBlock:(SMRNetAPISuccessBlock)successBlock
                                          faildBlock:(SMRNetAPIFaildBlock)faildBlock
                                      uploadProgress:(SMRNetAPIUploadProgressBlock)uploadProgress;

/** PUT请求的回调方式 */
+ (instancetype)callbackForPUTWithCacheBlock:(SMRNetAPICacheBlock)cacheBlock
                                successBlock:(SMRNetAPISuccessBlock)successBlock
                                  faildBlock:(SMRNetAPIFaildBlock)faildBlock;

/** PATCH请求的回调方式 */
+ (instancetype)callbackForPATCHWithCacheBlock:(SMRNetAPICacheBlock)cacheBlock
                                  successBlock:(SMRNetAPISuccessBlock)successBlock
                                    faildBlock:(SMRNetAPIFaildBlock)faildBlock;

/** DELETE请求的回调方式 */
+ (instancetype)callbackForDELETEWithCacheBlock:(SMRNetAPICacheBlock)cacheBlock
                                   successBlock:(SMRNetAPISuccessBlock)successBlock
                                     faildBlock:(SMRNetAPIFaildBlock)faildBlock;


/** 获取所有的回调方式 */
+ (instancetype)callbackWithConstructingBlock:(SMRConstructingUploadBlock)constructingBlock
                                   cacheBlock:(SMRNetAPICacheBlock)cacheBlock
                                 successBlock:(SMRNetAPISuccessBlock)successBlock
                                   faildBlock:(SMRNetAPIFaildBlock)faildBlock
                               uploadProgress:(SMRNetAPIUploadProgressBlock)uploadProgress
                             downloadProgress:(SMRNetAPIDownloadProgressBlock)downloadProgress;
@end

typedef NSString * SMRReqeustMethod NS_STRING_ENUM;
extern SMRReqeustMethod const SMRReqeustMethodGET;
extern SMRReqeustMethod const SMRReqeustMethodHEAD;
extern SMRReqeustMethod const SMRReqeustMethodPOST;
extern SMRReqeustMethod const SMRReqeustMethodPUT;
extern SMRReqeustMethod const SMRReqeustMethodPATCH;
extern SMRReqeustMethod const SMRReqeustMethodDELETE;

typedef NS_ENUM(NSInteger, SMRReqeustSerializerType) {
    SMRReqeustSerializerTypeJSON = 0,
    SMRReqeustSerializerTypeHTTP,
    SMRReqeustSerializerTypePropertyList,
};

typedef NS_ENUM(NSInteger, SMRResponseSerializerType) {
    SMRResponseSerializerTypeJSON = 0,
    SMRResponseSerializerTypeHTTP,
    SMRResponseSerializerTypeXMLParser,
#ifdef __MAC_OS_X_VERSION_MIN_REQUIRED
    SMRResponseSerializerTypeXMLDocument,
#endif
    SMRResponseSerializerTypePropertyList,
    SMRResponseSerializerTypeImage,
    SMRResponseSerializerTypeCompound,
};

/**
 普通API
 */
@class SMRNetCachePolicy;
@interface SMRNetAPI : NSObject

@property (copy  , nonatomic) NSString *identifier;
@property (copy  , nonatomic) SMRReqeustMethod method;          ///< 请求方式,默认为requestMethodGet
@property (copy  , nonatomic) NSString *host;                   ///< 域名
@property (copy  , nonatomic) NSString *url;                    ///< 不带域名部分
@property (strong, nonatomic) NSDictionary *params;
@property (strong, nonatomic) SMRNetCachePolicy *cachePolicy;   ///< 缓存策略,默认nil
@property (assign, nonatomic) NSTimeInterval timeoutInterval;   ///< 超时时间(s),默认0
@property (assign, nonatomic) NSInteger maxRetryTime;           ///< API最大重试次数

@property (strong, nonatomic) SMRAPICallback *callback;         ///< 各种回调的集合对象
@property (assign, nonatomic) SMRReqeustSerializerType reqeustType;     ///< 请求格式,默认JSON
@property (assign, nonatomic) SMRResponseSerializerType responseType;   ///< 返回格式,默认JSON

@property (strong, nonatomic, readonly) NSURLSessionTask *dataTask;     ///< API创建的任务,API发起后才能获取到值
@property (strong, nonatomic, readonly) id response;                    ///< API请求成功后的返回结果
@property (strong, nonatomic, readonly) NSError *error;                 ///< API请求失败后的错误

- (void)fillDataTask:(NSURLSessionTask *)dataTask;
- (void)fillResponse:(id)response error:(NSError *)error;

/**
 创建普通API
 */
+ (instancetype)apiWithIdentifier:(NSString *)identifier
                           method:(SMRReqeustMethod)method
                             host:(NSString *)host
                              url:(NSString *)url
                           params:(NSDictionary *)params
                         useCache:(BOOL)useCache;

@end

/**
 创建 Multi-Part 形式的API
 */
@protocol AFMultipartFormData;
@interface SMRMultipartNetAPI : SMRNetAPI

@property (strong, nonatomic) id<AFMultipartFormData> data;  ///< 上传用的对象

/**
 创建上传文件用的API
 */
+ (instancetype)apiWithIdentifier:(NSString *)identifier
                             data:(id<AFMultipartFormData>)data
                             host:(NSString *)host
                              url:(NSString *)url
                           params:(NSDictionary *)params
                         useCache:(BOOL)useCache;

@end
