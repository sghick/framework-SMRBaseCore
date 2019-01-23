//
//  SMRRouterCenter+SMROpen.h
//  SMRRouterDemo
//
//  Created by 丁治文 on 2018/10/12.
//  Copyright © 2018 sumrise.com. All rights reserved.
//

#import "SMRRouterCenter.h"

NS_ASSUME_NONNULL_BEGIN

@interface SMRRouterCenter (SMROpen)

#pragma mark - Native Deals

+ (id)fetchObjectWithTarget:(NSString *)target action:(NSString *)action params:(nullable NSDictionary *)params;
+ (id)openWithTarget:(NSString *)target action:(NSString *)action params:(nullable NSDictionary *)params;
+ (id)openPathWithTarget:(NSString *)target action:(NSString *)action params:(nullable NSDictionary *)params;

#pragma mark - URL Deals

+ (id)fetchObjectWithUrl:(NSURL *)url params:(nullable NSDictionary *)params;
+ (id)openWithUrl:(NSURL *)url params:(nullable NSDictionary *)params;
+ (id)openPathWithUrl:(NSURL *)url params:(nullable NSDictionary *)params;

@end

NS_ASSUME_NONNULL_END

