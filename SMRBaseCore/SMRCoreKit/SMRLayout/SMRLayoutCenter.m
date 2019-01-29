//
//  SMRLayoutCenter.m
//  SMRBaseCoreDemo
//
//  Created by 丁治文 on 2019/1/29.
//  Copyright © 2019 sumrise. All rights reserved.
//

#import "SMRLayoutCenter.h"
#import "PureLayout.h"

static NSString * const kSMRLayoutNameSeparator = @"<";
static NSString * const kSMRLayoutMethodSeparator = @":";
static NSString * const kSMRLayoutMethodValueSeparator = @",";

static NSString * const kSMRLayoutViewTop = @"top";
static NSString * const kSMRLayoutViewLeft = @"left";
static NSString * const kSMRLayoutViewBottom = @"bottom";
static NSString * const kSMRLayoutViewRight = @"right";
static NSString * const kSMRLayoutViewWidth = @"width";
static NSString * const kSMRLayoutViewHeight = @"height";

@implementation SMRLayoutCenter

+ (void)addSubviews:(NSDictionary *)dict atView:(UIView *)atView {
    for (NSString *key in dict.allKeys) {
        if ([key containsString:kSMRLayoutNameSeparator]) {
            NSArray *names = [key componentsSeparatedByString:kSMRLayoutNameSeparator];
            [self addSubview:dict[key] name:names.firstObject clsName:names.lastObject atView:atView];
        }
    }
}

+ (void)addSubview:(NSDictionary *)dict name:(NSString *)name clsName:(NSString *)clsName atView:(UIView *)atView {
    Class cls = NSClassFromString(clsName);
    if (!cls) {
        NSLog(@"<%@:%@> 未找到该类!", name, clsName);
        return;
    }
    UIView *view = [[cls alloc] init];
    if (![view isKindOfClass:[UIView class]]) {
        NSLog(@"<%@:%@> 非view对象!", name, clsName);
        return;
    }
    if (!atView) {
        NSLog(@"<%@:%@> atView为空!", name, clsName);
        return;
    }
    [atView addSubview:view];
    NSMutableDictionary *sdict = [dict mutableCopy];
    // 增加约束,并临时移除字典中的约束相关的属性
    [self addLayoutConstraint:sdict view:view atView:atView];
    // 调用方法
    [self callSelectors:[sdict copy] view:view atView:atView];
}

#pragma mark - View

+ (void)addLayoutConstraint:(NSMutableDictionary *)sdict view:(UIView *)view atView:(UIView *)atView {
    NSString *top = sdict[kSMRLayoutViewTop];
    if (top) {
        [view autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:top.floatValue];
        [sdict removeObjectForKey:kSMRLayoutViewTop];
    }
    NSString *left = sdict[kSMRLayoutViewLeft];
    if (left) {
        [view autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:left.floatValue];
        [sdict removeObjectForKey:kSMRLayoutViewLeft];
    }
    NSString *bottom = sdict[kSMRLayoutViewBottom];
    if (bottom) {
        [view autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:bottom.floatValue];
        [sdict removeObjectForKey:kSMRLayoutViewBottom];
    }
    NSString *right = sdict[kSMRLayoutViewRight];
    if (right) {
        [view autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:right.floatValue];
        [sdict removeObjectForKey:kSMRLayoutViewRight];
    }
    NSString *width = sdict[kSMRLayoutViewWidth];
    if (width) {
        [view autoSetDimension:ALDimensionWidth toSize:width.floatValue];
        [sdict removeObjectForKey:kSMRLayoutViewWidth];
    }
    NSString *height = sdict[kSMRLayoutViewHeight];
    if (height) {
        [view autoSetDimension:ALDimensionHeight toSize:height.floatValue];
        [sdict removeObjectForKey:kSMRLayoutViewHeight];
    }
}

+ (void)callSelectors:(NSDictionary *)sdict view:(UIView *)view atView:(UIView *)atView {
    for (NSString *selStr in sdict.allKeys) {
        SEL selector = NSSelectorFromString(selStr);
        if ([view respondsToSelector:selector]) {
            NSArray *sp = [selStr componentsSeparatedByString:kSMRLayoutMethodSeparator];
            NSArray *spv = [sdict[selStr] componentsSeparatedByString:kSMRLayoutMethodValueSeparator];
            if (!sdict[selStr]) {
                [view performSelector:selector];
                continue;
            }
            if (spv.count == 1) {
                [view performSelector:selector withObject:[self parserParam:spv[0]]];
                continue;
            }
            if (sp.count == 2) {
                [view performSelector:selector withObject:[self parserParam:spv[0]] withObject:[self parserParam:spv[1]]];
                continue;
            }
        }
    }
}

+ (id)parserParam:(NSString *)param {
    if ([param hasPrefix:@"#"] && (param.length == 7)) {
        return [self p_layoutColorFromHexRGB:param];
    }
    return param;
}

+ (nullable UIColor *)p_layoutColorFromHexRGB:(NSString *)colorString {
    // 去除空格
    NSString *cString = [[colorString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    //把开头截取
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"]) cString = [cString substringFromIndex:1];
    if (cString.length != 6) return nil;
    UIColor *result = nil;
    unsigned int colorCode = 0;
    unsigned char redByte, greenByte, blueByte;
    if (nil != cString) {
        NSScanner *scanner = [NSScanner scannerWithString:cString];
        (void) [scanner scanHexInt:&colorCode]; // ignore error
    }
    redByte = (unsigned char) (colorCode >> 16);
    greenByte = (unsigned char) (colorCode >> 8);
    blueByte = (unsigned char) (colorCode); // masks off high bits
    result = [UIColor
              colorWithRed: (float)redByte / 0xff
              green: (float)greenByte/ 0xff
              blue: (float)blueByte / 0xff
              alpha:1.0];
    return result;
}

@end
