//
//  SMRBaseCoreInfoHelper.m
//  SMRBaseCoreDemo
//
//  Created by 丁治文 on 2019/9/19.
//  Copyright © 2019 sumrise. All rights reserved.
//

#import "SMRBaseCoreInfoHelper.h"

@implementation SMRBaseCoreInfoHelper

+ (NSString *)configWithKey:(NSString *)key {
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"Base Core Config"][key];
}

+ (CGFloat)marginWithScale:(CGFloat)scale {
    CGFloat margin = 20*scale;
    NSString *value = [self configWithKey:@"Adapter Margin"];
    if (value) {
        // 优先读取info.plist中的配置
        margin = value.doubleValue;
        if ([value containsString:@"*scale"]) {
            margin *= scale;
        }
    }
    return margin;
}

+ (CGFloat)tableViewSeperatorLeftMarginWithScale:(CGFloat)scale {
    CGFloat margin = 20*scale;
    NSString *value = [self configWithKey:@"TableViewSeperator Left Margin"];
    if (value) {
        // 优先读取info.plist中的配置
        margin = value.doubleValue;
        if ([value containsString:@"*scale"]) {
            margin *= scale;
        }
    }
    return margin;
}
+ (CGFloat)tableViewSeperatorRightMarginWithScale:(CGFloat)scale {
    CGFloat margin = 20*scale;
    NSString *value = [self configWithKey:@"TableViewSeperator Right Margin"];
    if (value) {
        // 优先读取info.plist中的配置
        margin = value.doubleValue;
        if ([value containsString:@"*scale"]) {
            margin *= scale;
        }
    }
    return margin;
}

@end
