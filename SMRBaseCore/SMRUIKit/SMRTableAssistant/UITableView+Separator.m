//
//  UITableView+Separator.m
//  SeperatorLine
//
//  Created by 丁治文 on 16/7/11.
//  Copyright © 2016年 丁治文. All rights reserved.
//

#import "UITableView+Separator.h"
#import <objc/runtime.h>

/// On
NSString * const SMRSeperatorsFormatAllNone = @"On";
/// Fn
NSString * const SMRSeperatorsFormatAllLong = @"Fn";
/// Ln
NSString * const SMRSeperatorsFormatAllLeftLess = @"Ln";
/// Rn
NSString * const SMRSeperatorsFormatAllRightLess = @"Rn";
/// Cn
NSString * const SMRSeperatorsFormatAllCenterLess = @"Cn";

@interface UITableView ()

@property (nonatomic, assign) BOOL didMarkedCustom;

@end

@implementation UITableView (Separator)

#pragma mark - Getters/Setters
// didMarkedCustom
static const char SMRDidMarkedCustomKey = '\0';
- (void)setDidMarkedCustom:(BOOL)didMarkedCustom {
    if (didMarkedCustom != self.didMarkedCustom) {
        objc_setAssociatedObject(self, &SMRDidMarkedCustomKey, @(didMarkedCustom), OBJC_ASSOCIATION_RETAIN);
    }
}

- (BOOL)didMarkedCustom {
    NSNumber *number = objc_getAssociatedObject(self, &SMRDidMarkedCustomKey);
    return number.boolValue;
}

// leftMargin
static const char SMRLeftMarginKey = '\0';
- (void)setLeftMargin:(CGFloat)leftMargin {
    if (leftMargin != self.leftMargin) {
        objc_setAssociatedObject(self, &SMRLeftMarginKey, @(leftMargin), OBJC_ASSOCIATION_RETAIN);
    }
}

- (CGFloat)leftMargin {
    NSNumber *number = objc_getAssociatedObject(self, &SMRLeftMarginKey);
    return number?number.doubleValue:10;
}

// rightMargin
static const char SPRightMarginKey = '\0';
- (void)setRightMargin:(CGFloat)rightMargin {
    if (rightMargin != self.rightMargin) {
        objc_setAssociatedObject(self, &SPRightMarginKey, @(rightMargin), OBJC_ASSOCIATION_RETAIN);
    }
}

- (CGFloat)rightMargin {
    NSNumber *number = objc_getAssociatedObject(self, &SPRightMarginKey);
    return number?number.doubleValue:10;
}

#pragma mark - Utils
// 推荐在初始化方法中添加,如Getter方法中
- (void)smr_markCustomTableViewSeparators {
    self.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    if ([self respondsToSelector:@selector(setSeparatorInset:)]) {
        [self setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self respondsToSelector:@selector(setLayoutMargins:)]) {
        [self setLayoutMargins:UIEdgeInsetsZero];
    }
    self.separatorColor = [UIColor colorWithRed:229/255.0 green:229/255.0 blue:229/255.0 alpha:1];
    // 设置隐藏系统额外的线
    [self smr_setExtraCellLineHidden];
    self.didMarkedCustom = YES;
}

- (void)smr_setSeparatorsWithFormat:(NSString *)format cell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath {
    if (self.didMarkedCustom == NO) {
        self.didMarkedCustom = YES;
        [self smr_markCustomTableViewSeparators];
        NSAssert(NO, @"%s:未标记使用自定义样式线, 请使用 '-:smr_markCustomTableViewSeparators'", __func__);
    }
    
    NSArray<NSString *> *fms = [format componentsSeparatedByString:@"|"];
    NSInteger allCount = [self numberOfRowsInSection:indexPath.section];
    NSInteger curIndex = indexPath.row;
    NSInteger reseat = allCount - curIndex;
    BOOL didBreak = NO;
    NSString *defStyle = @"Fn";
    NSString *style = nil;
    NSRange range = NSMakeRange(0, 0);
    for (NSString *fm in fms) {
        range = [self rangeFromFormat:fm style:&style];
        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:range];
        if ([style containsString:@"n"]) {
            defStyle = style;
        }
        if (![style containsString:@"-"]) {
            // 解析正常情况
            if ([indexSet containsIndex:curIndex]) {
//                NSLog(@"seat:%@,%@=>%@%@", @(curIndex), fm, style, NSStringFromRange(range));
                didBreak = YES;
                break;
            }
        } else {
            // 解析倒数的情况
            if ([indexSet containsIndex:reseat]) {
//                NSLog(@"reseat:%@,%@=>%@%@", @(reseat), fm, style, NSStringFromRange(range));
                didBreak = YES;
                break;
            }
        }
    }
    if (!didBreak) {
        char cstyle = [defStyle characterAtIndex:0];
        [self setCell:cell separatorMargins:[self insetWithChar:cstyle]];
//        NSLog(@"=====index:%@,通用样式:%@", @(curIndex), defStyle);
    } else {
        char cstyle = [style characterAtIndex:0];
        [self setCell:cell separatorMargins:[self insetWithChar:cstyle]];
//        NSLog(@"=====index:%@,使用样式:%@", @(curIndex), style);
    }
}

- (UIEdgeInsets)insetWithChar:(char)cstyle {
    UIEdgeInsets rtn = UIEdgeInsetsZero;
    switch (cstyle) {
        case 'F':{rtn = [self insetForLone];} break;
        case 'O':{rtn = [self insetForNone];} break;
        case 'L':{rtn = [self insetForLeftShort];} break;
        case 'R':{rtn = [self insetForRightShort];} break;
        case 'C':{rtn = [self insetForAllShort];} break;
            
        default:{rtn = [self insetForLone];} break;
    }
    return rtn;
}

- (NSRange)rangeFromFormat:(NSString *)format {
    if (!format.length) {
        return NSMakeRange(0, 0);
    }
    
    NSString *style = nil;
    NSRange range = [self rangeFromFormat:format style:&style];
    NSLog(@"%@%@", style, NSStringFromRange(range));
    return range;
}


/**
 返回格式: L{2, 1},  Ln{0, 0},  F-{4, 1}
 style:   L,        Ln,        F-
 range:   {2, 1},   {0, 0},    {4, 1}
 */
- (NSRange)rangeFromFormat:(NSString *)format style:(NSString **)style {
    if (!format.length) {
        return NSMakeRange(0, 0);
    }
    // 样式
    *style = [format substringToIndex:1];
    if ([format containsString:@"-"]) {
        *style = [*style stringByAppendingString:@"-"];
    }
    NSString *rg = [format substringFromIndex:1];
    // 判断其余样式
    if ([rg.lowercaseString isEqualToString:@"n"]) {
        *style = [format substringToIndex:2];
        return NSMakeRange(0, 0);
    }
    if ([rg containsString:@"{"] && [rg containsString:@"}"]) {
        return NSRangeFromString(rg);
    }
    if (!rg.integerValue) {
        return NSMakeRange(0, 0);
    }
    return NSMakeRange(ABS(rg.integerValue), 1);
}


// 隐藏多余的view
- (void)smr_setExtraCellLineHidden {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    [self setTableFooterView:view];
}

// private
- (void)setCell:(UITableViewCell *)cell separatorMargins:(UIEdgeInsets)inset {
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:inset];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

// private
- (UIEdgeInsets)insetForLeftShort {
    return UIEdgeInsetsMake(0, self.leftMargin, 0, 0);
}

// private
- (UIEdgeInsets)insetForRightShort {
    return UIEdgeInsetsMake(0, 0, 0, self.leftMargin);
}

// private
- (UIEdgeInsets)insetForAllShort {
    return UIEdgeInsetsMake(0, self.leftMargin, 0, self.rightMargin);
}

// private
- (UIEdgeInsets)insetForLone {
    return UIEdgeInsetsZero;
}

// private
- (UIEdgeInsets)insetForNone {
    NSAssert(self.style == UITableViewStylePlain, @"暂时不支持非StylePlain形式的使用方式");
    return UIEdgeInsetsMake(0, [UIScreen mainScreen].bounds.size.width, 0, 0);
}

#pragma mark - Unit Test Case

- (void)testRangeFromFormat {
    NSAssert(NSEqualRanges([self rangeFromFormat:nil], NSMakeRange(0, 0)), @"error");
    NSAssert(NSEqualRanges([self rangeFromFormat:@""], NSMakeRange(0, 0)), @"error");
    
    NSAssert(NSEqualRanges([self rangeFromFormat:@"y"], NSMakeRange(0, 0)), @"error");
    NSAssert(NSEqualRanges([self rangeFromFormat:@"#"], NSMakeRange(0, 0)), @"error");
    NSAssert(NSEqualRanges([self rangeFromFormat:@"cden"], NSMakeRange(0, 0)), @"error");
    NSAssert(NSEqualRanges([self rangeFromFormat:@":"], NSMakeRange(0, 0)), @"error");
    NSAssert(NSEqualRanges([self rangeFromFormat:@"n:"], NSMakeRange(0, 0)), @"error");
    NSAssert(NSEqualRanges([self rangeFromFormat:@"C"], NSMakeRange(0, 0)), @"error");
    NSAssert(NSEqualRanges([self rangeFromFormat:@"O"], NSMakeRange(0, 0)), @"error");
    NSAssert(NSEqualRanges([self rangeFromFormat:@"F:"], NSMakeRange(0, 0)), @"error");
    NSAssert(NSEqualRanges([self rangeFromFormat:@"On"], NSMakeRange(0, 0)), @"error");
    
    NSAssert(NSEqualRanges([self rangeFromFormat:@"On:"], NSMakeRange(0, 0)), @"error");
    NSAssert(NSEqualRanges([self rangeFromFormat:@"Fn:"], NSMakeRange(0, 0)), @"error");
    NSAssert(NSEqualRanges([self rangeFromFormat:@"Ln:"], NSMakeRange(0, 0)), @"error");
    NSAssert(NSEqualRanges([self rangeFromFormat:@"Rn:"], NSMakeRange(0, 0)), @"error");
    NSAssert(NSEqualRanges([self rangeFromFormat:@"Cn:"], NSMakeRange(0, 0)), @"error");
    NSAssert(NSEqualRanges([self rangeFromFormat:@"On{3}"], NSMakeRange(3, 0)), @"error");
    
    NSAssert(NSEqualRanges([self rangeFromFormat:@"C2"], NSMakeRange(2, 1)), @"error");
    NSAssert(NSEqualRanges([self rangeFromFormat:@"C-3"], NSMakeRange(3, 1)), @"error");
    NSAssert(NSEqualRanges([self rangeFromFormat:@"F{1,1}"], NSMakeRange(1, 1)), @"error");
    NSAssert(NSEqualRanges([self rangeFromFormat:@"L{2,2}"], NSMakeRange(2, 2)), @"error");
    NSAssert(NSEqualRanges([self rangeFromFormat:@"O-{4,4}"], NSMakeRange(4, 4)), @"error");
    NSAssert(NSEqualRanges([self rangeFromFormat:@"E{5,-5}"], NSMakeRange(5, 5)), @"error");
    NSAssert(NSEqualRanges([self rangeFromFormat:@"E{-6,6}"], NSMakeRange(6, 6)), @"error");
    
    NSLog(@"test finished");
}

@end
