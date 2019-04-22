//
//  SMRNetConfig.h
//  SMRNetworkDemo
//
//  Created by 丁治文 on 2018/10/6.
//  Copyright © 2018年 sumrise.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class SMRNetAPI;
@protocol SMRRequestDelegate <NSObject>

/**
 默认`GET`, `HEAD`, and `DELETE`使用URL参数类型,其余使用DataParam参数类型
 */
- (NSSet *)HTTPMethodsEncodingParametersInURI;

/**
 可以在这里设置请求头
 */
- (void)configRequestBeforeDataTask:(NSMutableURLRequest *)request api:(SMRNetAPI *)api;

/**
 防止抖动频率设置(s),默认1.0s
 */
- (NSTimeInterval)timerIntervalForDedounce;

/**
 防止抖动容量设置,默认1个
 */
- (NSInteger)maxCountForDedounce;

/**
 暴力刷子禁止时间,默认60s
 */
- (NSTimeInterval)invalidateDuration;

@end

@protocol SMRResponseDelegate <NSObject>

/**
 设置响应的Content-Type
 */
- (NSSet *)setForAcceptableContentTypes;

/**
 设置响应的正常网络状态码,默认为:[100, 400)
 覆盖此方法后,将使用AFN的默认区间:[200, 300)
 状态码参考:
 https://www.w3.org/Protocols/rfc2616/rfc2616-sec10.html
 https://zh.wikipedia.org/wiki/HTTP%E7%8A%B6%E6%80%81%E7%A0%81
 https://baike.baidu.com/item/HTTP%E7%8A%B6%E6%80%81%E7%A0%81/5053660?fr=aladdin
 */
- (NSIndexSet *)setForAcceptableStatusCodes;

/**
 鉴别'response','responseObject','error'是否为服务器错误,并返回这个错误,没有错误返回nil
 */
- (NSError *)validateServerErrorWithAPI:(SMRNetAPI *)api response:(NSURLResponse *)response responseObject:(nullable id)responseObject error:(nullable NSError *)error;

/**
 从error中取出responseObject
 AFN的ResponseSerializer设置的非'正常网络状态码区间'(由setForAcceptableStatusCodes所设置)的错误码放在error.info中,并且下层不好获取
 */
- (nullable id)responseObjectWithError:(nullable NSError *)error;

@end

@protocol SMRAPIRetryDelegate <NSObject>

/**
 根据error决定是否可以重试
 */
- (BOOL)canRetryWhenRecivedError:(NSError *)error api:(SMRNetAPI *)api;

@end

@protocol SMRAPIInitDelegate <NSObject>

/** 设置一个初始化API */
- (SMRNetAPI *)apiForInitialization;

/** 如果需要自动重试初始化API,请重写这个方法,并返回YES */
- (BOOL)canQueryInitAPIWhenRecivedError:(NSError *)error currentAPI:(SMRNetAPI *)currentAPI;

/** 初始化API成功的回调:返回NO,表示业务层判定为失败,默认返回YES */
- (BOOL)apiInitSuccessed:(SMRNetAPI *)api response:(id)response;

/** 初始化API失败的回调 */
- (void)apiInitFaild:(NSError *)error;

@end

@protocol SMRNetIndicatorDelegate <NSObject>

/**
 网络状态的'菊花'是否展示,默认返回YES
 */
- (BOOL)enableForStatuBarIndicator;

@end

typedef NS_ENUM(NSInteger, SMRNetworkReachabilityStatus) {
    SMRNetworkReachabilityStatusUnknown          = -1,
    SMRNetworkReachabilityStatusNotReachable     = 0,
    SMRNetworkReachabilityStatusReachableViaWWAN = 1,
    SMRNetworkReachabilityStatusReachableViaWiFi = 2,
};

@protocol SMRNetworkReachabilityDelegate <NSObject>

/** 监听网络变化的开头,默认开:YES */
- (BOOL)enableNetworkReachability;

/** 网络状态变化时的回调 */
- (void)didChangedNetworkWithWithStatus:(SMRNetworkReachabilityStatus)status;

@end

@class SMRNetAPI;
@interface SMRNetConfig : NSObject<
SMRRequestDelegate,
SMRResponseDelegate,
SMRAPIRetryDelegate,
SMRAPIInitDelegate,
SMRNetIndicatorDelegate,
SMRNetworkReachabilityDelegate>

@property (assign, nonatomic) BOOL debugLog;                ///< 设置日志开关,默认NO
@property (copy  , nonatomic) NSString *infoGroupID;        ///< 设置NetInfo存放的UD的groupID,默认为nil,使用默认UD

/**
 config的入口
 */
- (void)configPrepare;

@end

NS_ASSUME_NONNULL_END
