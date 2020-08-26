//
//  SMRURLProvider.m
//  SMRRouterDemo
//
//  Created by 丁治文 on 2018/12/14.
//  Copyright © 2018 sumrise. All rights reserved.
//

#import "SMRURLProvider.h"
#import "NSURL+BaseCore.h"
#import "SMRActionAlias.h"

@implementation SMRURLParserItem

- (void)setUrl:(NSURL *)url {
    _url = url;
}

- (void)setTarget:(NSString *)target {
    _target = target;
}

- (void)setAction:(NSString *)action {
    _action = action;
}

- (void)setParams:(NSDictionary *)params {
    _params = params;
}

+ (instancetype)itemWithUrl:(NSURL *)url Target:(NSString *)target action:(NSString *)action params:(NSDictionary *)params {
    SMRURLParserItem *item = [[SMRURLParserItem alloc] init];
    item.url = url;
    item.target = target;
    item.action = action;
    item.params = params;
    return item;
}

@end

@implementation SMRRouterURLParser

- (void)dealloc {
    _targetParserBlock = nil;
}

- (instancetype)init {
    return [self initWithTargetPrefix:@"" actionPrefix:@""];
}

- (instancetype)initWithTargetPrefix:(NSString *)targetPrefix actionPrefix:(NSString *)actionPrefix {
    self = [super init];
    if (self) {
        _targetPrefix = targetPrefix;
        _actionPrefix = actionPrefix;
    }
    return self;
}

- (SMRURLParserItem *)parserWithUrl:(NSURL *)url additionParams:(nullable NSDictionary *)additionParams {
    SMRURLParserItem *item = [self p_parserWithUrl:url additionParams:additionParams];
    item.target = [self appendingTargetName:item.target withPrefix:self.targetPrefix];
    item.action = [self appendingActionName:item.action withPrefix:self.actionPrefix];
    return item;
}

- (SMRURLParserItem *)p_parserWithUrl:(NSURL *)url additionParams:(NSDictionary *)additionParams {
    if (!url) {
        return nil;
    }
    NSString *action = [url.path stringByReplacingOccurrencesOfString:@"/" withString:@""];
    NSString *target = url.host;
    // 替换绑定的target
    NSString *bonding = nil;
    NSDictionary *bondingParams = nil;
    if (self.targetParserBlock) {
        bonding = self.targetParserBlock(target);
    } else {
        bonding = [SMRActionAlias sharedAlias].alias[target];
    }
    if (bonding.length) {
        NSURL *bondingURL = [NSURL URLWithString:[@"bonding://" stringByAppendingString:bonding]];
        action = [bondingURL.path stringByReplacingOccurrencesOfString:@"/" withString:@""];
        target = bondingURL.host;
        bondingParams = [bondingURL smr_parseredParams];
    }
    // 添加url参数和附加参数
    NSDictionary *urlParams = [url smr_parseredParams];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (bondingParams) {
        [params addEntriesFromDictionary:bondingParams];
    }
    if (urlParams) {
        [params addEntriesFromDictionary:urlParams];
    }
    if (additionParams) {
        [params addEntriesFromDictionary:additionParams];
    }
    SMRURLParserItem *item = [SMRURLParserItem itemWithUrl:url Target:target action:action params:[NSDictionary dictionaryWithDictionary:params]];
    return item;
}

#pragma mark - Utils

- (NSString *)appendingTargetName:(NSString *)targetName withPrefix:(NSString *)prefix {
    return [NSString stringWithFormat:@"%@%@", prefix ?: @"", targetName ?: @""];
}
- (NSString *)appendingActionName:(NSString *)actionName withPrefix:(NSString *)prefix {
    NSString *action = [NSString stringWithFormat:@"%@%@", prefix ?: @"", actionName ?: @""];
    return action;
}

@end


@implementation SMRURLProvider

@end
