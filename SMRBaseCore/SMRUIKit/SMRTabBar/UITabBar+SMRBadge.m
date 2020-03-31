//
//  UITabBar+SMRBadge.m
//  SMRBaseCoreDemo
//
//  Created by 丁治文 on 2019/5/31.
//  Copyright © 2019 sumrise. All rights reserved.
//

#import "UITabBar+SMRBadge.h"
#import "UITabBar+SMRTabBarInfo.h"
#import "SMRUIKitBundle.h"

static CGFloat const SMRTabBarTextFontSize = 6.0;

@implementation UITabBar (SMRBadge)

#pragma mark - Public Method

#pragma mark Show

/// 显示普通小红点
- (void)showBadgeAtItemIndex:(NSUInteger)index {
    
    // 移除之前的小红点
    [self removeBadgeViewOnItemIndex:index viewStartTag:SMRTabBarBadgeStartTag];
    
    if (index >= self.items.count) {
        return;
    }
    
    // 新建小红点
    CGSize badgeSize = CGSizeMake(8, 8);
    UIView *badgeView = [self badgeViewWithBadgeSize:badgeSize tag:SMRTabBarBadgeStartTag + index];
    // 添加
    [self addBadgeViewAtIndex:index badgeView:badgeView size:badgeSize];
}

/// 显示带数值的小红点
- (void)showBadgeNumber:(NSInteger)number atItemIndex:(NSUInteger)index {
    NSString *badgeText = [NSString stringWithFormat:@"%@", @(number)];
    [self showBadgeText:badgeText atItemIndex:index viewStartTag:SMRTabBarBadgeNumberStartTag];
}

/// 显示带文本的小红点
- (void)showBadgeText:(NSString *)badgeText atItemIndex:(NSUInteger)index {
    [self showBadgeText:badgeText atItemIndex:index viewStartTag:SMRTabBarBadgeTextStartTag];
}

#pragma mark Hide

/// 隐藏普通小红点
- (void)hideBadgeAtItemIndex:(NSUInteger)index {
    // 移除小红点
    [self removeBadgeViewOnItemIndex:index viewStartTag:SMRTabBarBadgeStartTag];
}

/// 隐藏带数值的小红点
- (void)hideBadgeNumberAtItemIndex:(NSUInteger)index {
    // 移除badegText
    [self removeBadgeViewOnItemIndex:index viewStartTag:SMRTabBarBadgeNumberStartTag];
}

/// 隐藏带文本的小红点
- (void)hideBadgeTextAtItemIndex:(NSUInteger)index {
    // 移除badegText
    [self removeBadgeViewOnItemIndex:index viewStartTag:SMRTabBarBadgeTextStartTag];
}

/// 隐藏当前索引位置下的所有情况的红点
- (void)hideAllBadgeAtItemIndex:(NSUInteger)index {
    [self removeBadgeViewOnItemIndex:index viewStartTag:SMRTabBarBadgeStartTag];
    [self removeBadgeViewOnItemIndex:index viewStartTag:SMRTabBarBadgeTextStartTag];
    [self removeBadgeViewOnItemIndex:index viewStartTag:SMRTabBarBadgeNumberStartTag];
}

/// 隐藏所有情况的红点
- (void)hideAllBadge {
    for (NSInteger index = 0; index < 5; index++) {
        // 目前只有5个tab
        [self hideAllBadgeAtItemIndex:index];
    }
}

#pragma mark - Private Method

- (void)showBadgeText:(NSString *)badgeText atItemIndex:(NSUInteger)index viewStartTag:(NSInteger)viewStartTag {
    
    // 移除之前的badgeText
    [self removeBadgeViewOnItemIndex:index viewStartTag:viewStartTag];
    
    if (index >= self.items.count) {
        return;
    }
    
    // 新建badgeText
    NSString *showText = [badgeText substringWithRange:NSMakeRange(0, badgeText.length > 5 ? 5 : badgeText.length)];
    UILabel *badgeView = [self badgeLabelWithText:showText tag:viewStartTag + index];
    [badgeView sizeToFit];
    
    __block CGSize actualSize = badgeView.bounds.size;
    // 这个Block这样写的原因是因为下面的if语句里面需要先判断实际的高度，因为else语句里面也需要这个处理，所以在这里统一处理
    void (^handleHeight)(void) = ^{
        if (actualSize.height < SMRTabBarTextFontSize*2) {
            actualSize.height = SMRTabBarTextFontSize*2;
        }
    };
    if (actualSize.width < actualSize.height) {
        handleHeight();
        actualSize.width = actualSize.height;
    } else {
        handleHeight();
        actualSize.width += SMRTabBarTextFontSize;
    }
    badgeView.layer.cornerRadius = actualSize.height/2.0;
    CGSize textSize = actualSize;
    // 添加
    [self addBadgeViewAtIndex:index badgeView:badgeView size:textSize];
}

- (void)addBadgeViewAtIndex:(NSUInteger)index badgeView:(UIView *)badgeView size:(CGSize)size {
    [self addSubview:badgeView];
    
    [self layoutIfNeeded];
    
    UIImageView *button = [self tabBarSwappableImageViewAtIndex:index];
    CGRect buttonFrame = [button convertRect:button.bounds toView:self];
    badgeView.frame = CGRectMake(buttonFrame.origin.x + buttonFrame.size.width,
                                 buttonFrame.origin.y,
                                 size.width,
                                 size.height);
}

- (void)removeBadgeViewOnItemIndex:(NSUInteger)index viewStartTag:(NSInteger)viewStartTag {
    
    // 按照tag值进行移除
    for (UIView *subView in self.subviews) {
        if (subView.tag == viewStartTag + index) {
            [subView removeFromSuperview];
            // 删除break，因为调用方法是异步的，程序中小红点增删频繁且异步，可能会加多个，如果加入break只能删除第一个匹配的。
        }
    }
}

/// 创建小红点view
- (UIView *)badgeViewWithBadgeSize:(CGSize)badgeSize tag:(NSInteger)tag {
    UIView *badgeView = [[UIView alloc] init];
    badgeView.tag = tag;
    badgeView.frame = CGRectMake(0, 0, badgeSize.width, badgeSize.height);
    badgeView.layer.contents = (id)[SMRUIKitBundle imageNamed:@"tab_redPoint@3x"].CGImage;
    return badgeView;
}

/// 创建提示label
- (UILabel *)badgeLabelWithText:(NSString *)text tag:(NSInteger)tag {
    UILabel *label = [[UILabel alloc] init];
    label.tag = tag;
    label.text = text;
    label.clipsToBounds = YES;
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor redColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:SMRTabBarTextFontSize];
    label.layer.borderWidth = 0.1;
    label.layer.borderColor = [UIColor redColor].CGColor;
    return label;
}

@end
