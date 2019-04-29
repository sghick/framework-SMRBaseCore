//
//  SMRNavigationDefine.h
//  SMRBaseCoreDemo
//
//  Created by 丁治文 on 2019/1/21.
//  Copyright © 2019 sumrise. All rights reserved.
//

#ifndef SMRNavigationDefine_h
#define SMRNavigationDefine_h
#import <UIKit/UIKit.h>

#ifndef IS_IPHONEX_SERIES
#define IS_IPHONEX_SERIES \
({BOOL isPhoneX = NO;\
if (@available(iOS 11.0, *)) {\
isPhoneX = [[UIApplication sharedApplication] delegate].window.safeAreaInsets.bottom > 0.0;\
}\
(isPhoneX);})
#endif

typedef NS_ENUM(NSInteger, cNavigationViewTheme);

@class SMRNavigationView;
@class SMRNavigationItem;
@class SMRNavigationTheme;
@protocol SMRNavigationViewDelegate <NSObject>

@optional
/**
 *  返回按钮点击事件
 *
 *  @param nav    本对象
 *  @param sender 按钮对象
 */
- (void)navigationView:(SMRNavigationView *)nav didBackBtnTouched:(UIButton *)sender;

/**
 *  一次返回按钮点击事件
 *
 *  @param nav    本对象
 *  @param sender 按钮对象
 */
- (void)navigationView:(SMRNavigationView *)nav didCloseBtnTouched:(UIButton *)sender;

/**
 *  标题点击事件
 *
 *  @param nav    本对象
 *  @param sender 标题
 */
- (void)navigationView:(SMRNavigationView *)nav didTitleTouched:(UILabel *)sender;

/**
 *  nav背景点击事件
 *
 *  @param nav    本对象
 *  @param sender 发起的对象(nav)
 */
- (void)navigationView:(SMRNavigationView *)nav didBackgroundTouched:(UIView *)sender;

@end

/**
 *  设置渐变处理的block
 */
typedef void(^NavigationViewGradationBlock)(SMRNavigationView *navigationView, CGFloat gradationOffset, CGFloat oldGradationOffset);

/**
 *  设置主题的block
 */
typedef void(^NavigationViewResetToThemeBlock)(SMRNavigationTheme *theme);

/**
 *  设置全局默认属性的block
 */
typedef void(^NavigationViewAppearanceBlock)(SMRNavigationView *navigationView);

#endif /* SMRNavigationDefine_h */
