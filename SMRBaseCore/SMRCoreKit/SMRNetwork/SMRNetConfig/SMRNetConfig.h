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
 可以在这里设置请求头
 */
- (void)configRequestBeforeDataTask:(NSMutableURLRequest *)request api:(SMRNetAPI *)api;

@end

@protocol SMRResponseDelegate <NSObject>

/**
 设置响应的Content-Type
 */
- (NSSet *)setForAcceptableContentTypes;

/**
 设置响应的正常网络状态码,默认为:[100, 400)
 覆盖此方法后,将使用AFN的默认区间:[200, 300)
 */
- (NSIndexSet *)setForAcceptableStatusCodes;

/**
 鉴别'response','responseObject','error'是否为服务器错误,并返回这个错误,没有错误返回nil
 */
- (NSError *)validateServerErrorWithAPI:(SMRNetAPI *)api response:(NSURLResponse *)response responseObject:(nullable id)responseObject error:(nullable NSError *)error;

/**
 从error中取出responseObject
 AFN的ResponseSerializer会默认将非(200-299)的错误码放在error.info中,并且下层不好获取
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

/**
 在这里定义一个初始化的API,这应该是一个带自动重试功能的
 */
- (SMRNetAPI *)shouldQueryInitAPIWithCurrentAPI:(SMRNetAPI *)currentAPI error:(NSError *)error;

/**
 初始化API成功的回调
 返回NO,表示业务层判定为失败,默认返回YES
 */
- (BOOL)apiInitSuccessed:(SMRNetAPI *)api response:(id)response;

/**
 初始化API失败的回调
 */
- (void)apiInitFaild:(NSError *)error;

@end

@protocol SMRNetIndicatorDelegate <NSObject>

/**
 网络状态的'菊花'是否展示,默认返回YES
 */
- (BOOL)enableForStatuBarIndicator;

@end

@class SMRNetAPI;
@interface SMRNetConfig : NSObject<
SMRRequestDelegate,
SMRResponseDelegate,
SMRAPIRetryDelegate,
SMRAPIInitDelegate,
SMRNetIndicatorDelegate>

@property (assign, nonatomic) BOOL debugLog;                ///< 设置日志开关,默认NO
@property (copy  , nonatomic) NSString *infoGroupID;        ///< 设置NetInfo存放的UD的groupID,默认为nil,使用默认UD

/**
 config的入口
 */
- (void)configPrepare;

@end

NS_ASSUME_NONNULL_END
