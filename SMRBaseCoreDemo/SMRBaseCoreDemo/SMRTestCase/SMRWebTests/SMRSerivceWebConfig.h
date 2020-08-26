//
//  SMRSerivceWebConfig.h
//  SMRBaseCoreDemo
//
//  Created by 丁治文 on 2019/5/22.
//  Copyright © 2019 sumrise. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SMRWeb.h"

NS_ASSUME_NONNULL_BEGIN

@interface SMRWebParameter : SMRWebControllerParameter

// 分享信息
@property (assign, nonatomic) BOOL canShare;
@property (copy  , nonatomic) NSString *shareTitle;
@property (copy  , nonatomic) NSString *shareSummary;
@property (copy  , nonatomic) NSString *shareImageUrl; ///< 缩略图URL
@property (copy  , nonatomic) NSString *shareUrl;

+ (instancetype)webNavigationViewTitle:(NSString *)navTitle;

+ (instancetype)shareWithCanShare:(BOOL)canShare
                       shareTitle:(NSString *)shareTitle
                     shareSummary:(NSString *)shareSummary
                    shareImageUrl:(NSString *)shareImageUrl
                         shareUrl:(NSString *)shareUrl;

@end

@interface SMRSerivceWebConfig : NSObject<SMRWebReplaceConfig, SMRWebJSRegisterConfig, SMRWebNavigationViewConfig>

+ (instancetype)defaultConfig;

@end

NS_ASSUME_NONNULL_END
