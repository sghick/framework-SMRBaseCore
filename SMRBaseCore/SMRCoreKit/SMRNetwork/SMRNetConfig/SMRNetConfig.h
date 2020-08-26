//
//  SMRNetConfig.h
//  SMRNetworkDemo
//
//  Created by 丁治文 on 2018/12/18.
//  Copyright © 2018 sumrise. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class SMRNetAPI;
@protocol SMRRequestDelegate <NSObject>

@optional
/**
 默认`GET`, `HEAD`, and `DELETE`使用URL参数类型,其余使用DataParam参数类型
 */
- (NSSet *)HTTPMethodsEncodingParametersInURI;

/**
 可以在这里设置共通请求头, 每个API创建DataTask并发起请求前都会调用此方法
 */
- (void)configRequestBeforeDataTask:(NSMutableURLRequest *)request api:(SMRNetAPI *)api;

/**
 防止抖动容量设置,默认无限制:-1
 */
- (NSInteger)maxCountForDedounce;

@end

@protocol SMRResponseDelegate <NSObject>

@optional
/**
 设置响应的Content-Type
 默认有 `text/javascript`, `application/json`, `text/json`, `text/plain`, `text/html` 五种
 */
- (NSSet *)setForAcceptableContentTypes;

/**
 设置响应的正常网络状态码,默认为:[100, 400)
 状态码参考:
 https://www.w3.org/Protocols/rfc2616/rfc2616-sec10.html
 https://zh.wikipedia.org/wiki/HTTP%E7%8A%B6%E6%80%81%E7%A0%81
 https://baike.baidu.com/item/HTTP%E7%8A%B6%E6%80%81%E7%A0%81/5053660?fr=aladdin
 */
- (NSIndexSet *)setForAcceptableStatusCodes;

/**
 鉴别'response','responseObject','error'是否为服务器错误
 可以在子类中实现此方法,将收到的服务自定义错误信息组装成error并返回, 如果返回error不为nil, 则会回调faild
 */
- (nullable NSError *)validateServerErrorWithAPI:(SMRNetAPI *)api response:(NSURLResponse *)response responseObject:(nullable id)responseObject error:(nullable NSError *)error;

@end

@protocol SMRAPIRetryDelegate <NSObject>

/**
 根据error决定是否可以重试,默认返回YES
 */
- (BOOL)canRetryWhenRecivedError:(NSError *)error api:(SMRNetAPI *)api;

/**
 根据error决定是否发起新的API,成功后再重试,默认返回nil
 可以在这里处理初始化API
 */
- (SMRNetAPI *)canQueryNewAPIAndRetryWhenRecivedError:(NSError *)error api:(SMRNetAPI *)api;

@end

@protocol SMRNetIndicatorDelegate <NSObject>

@optional
/**
 状态栏的网络提示器是否展示,默认返回YES
 需要在 SMRSession或其子类 中实现 -configNetworkActivityIndicator 方法
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

@optional
/**
 监听网络变化的开头,默认返回YES
 需要在 SMRSession或其子类 中实现 -configNetworkReachability 方法
 */
- (BOOL)enableNetworkReachability;

/**
 网络状态变化时的回调
 需要在 SMRSession或其子类 中实现 -configNetworkReachability 方法, 并由实现者回调此方法
 */
- (void)didChangedNetworkWithWithStatus:(SMRNetworkReachabilityStatus)status;

@end

@class SMRNetAPI;
@interface SMRNetConfig : NSObject<
SMRRequestDelegate,
SMRResponseDelegate,
SMRAPIRetryDelegate,
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
