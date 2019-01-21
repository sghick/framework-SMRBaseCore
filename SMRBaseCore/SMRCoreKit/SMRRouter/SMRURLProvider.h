//
//  SMRURLProvider.h
//  SMRRouterDemo
//
//  Created by 丁治文 on 2018/12/14.
//  Copyright © 2018 sumrise.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SMRURLParserItem : NSObject

@property (nonatomic, strong, readonly) NSURL *url;
@property (nonatomic, copy  , readonly) NSString *target;
@property (nonatomic, copy  , readonly) NSString *action;
@property (nonatomic, copy  , readonly) NSDictionary *params;

+ (instancetype)itemWithUrl:(NSURL *)url Target:(NSString *)target action:(NSString *)action params:(NSDictionary *)params;

@end

typedef NSDictionary<NSString *,NSString *> *(^SMRURLRouterParserTargetBondingBlock)(void);
typedef NSString *(^SMRURLRouterParserTargetBlock)(NSString *target);
@interface SMRRouterURLParser : NSObject

@property (nonatomic, copy  , readonly) NSString *targetPrefix;
@property (nonatomic, copy  , readonly) NSString *actionPrefix;

/// 将Target/Action组合起别名,作为url中的host,如:@{<别名>:<Target名>/<Action名>}
@property (nonatomic, copy  ) SMRURLRouterParserTargetBlock targetParserBlock;

/// 推荐使用本方法创建一个Parser
- (instancetype)initWithTargetPrefix:(NSString *)targetPrefix actionPrefix:(NSString *)actionPrefix;

/// 获取URL参数
- (SMRURLParserItem *)parserWithUrl:(NSURL *)url additionParams:(nullable NSDictionary *)additionParams;

@end

/// 校验url合法性的block,scheme的白名单也可以在这里设置
typedef BOOL(^SMRURLValideBlock)(NSURL *url);
@class SMRRouterURLParser;
@interface SMRURLProvider : NSObject

/// 解析器,推荐在settingInit方法设置
@property (nonatomic, strong) SMRRouterURLParser *parser;
/// url验证block,验证通过返回YES,否则返回NO.
@property (nonatomic, copy  ) SMRURLValideBlock urlValideBlock;

@end

NS_ASSUME_NONNULL_END
