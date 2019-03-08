//
//  SMRUIAdapter.h
//  SMRBaseCoreDemo
//
//  Created by 丁治文 on 2019/2/13.
//  Copyright © 2019 sumrise. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
// 是否是iPhone4或者iPhone4s
#define IS_IPHONE4 ([UIScreen mainScreen].bounds.size.height == 480.0 ? YES : NO)
// 是否是iPhone5、iPhone5s/5c
#define IS_IPHONE5 ([UIScreen mainScreen].bounds.size.height == 568.0 ? YES : NO)
// 是否是iPhone6/6s/7/8
#define IS_IPHONE6 ([UIScreen mainScreen].bounds.size.height == 667.0 ? YES : NO)
// 是否是iPhone6P/6sP/7P/8P
#define IS_IPHONE6P ([UIScreen mainScreen].bounds.size.height == 736.0 ? YES : NO)
// 是否是iPhoneX/Xs
#define IS_IPHONEX ([UIScreen mainScreen].bounds.size.height == 821.0 ? YES : NO)
// 是否是iPhoneXR/XS Max
#define IS_IPHONEXR ([UIScreen mainScreen].bounds.size.height == 896.0 ? YES : NO)
// 判断是否为iPhone X 系列
#define IS_IPHONEX_SERIES \
({BOOL isPhoneX = NO;\
if (@available(iOS 11.0, *)) {\
isPhoneX = [[UIApplication sharedApplication] delegate].window.safeAreaInsets.bottom > 0.0;\
}\
(isPhoneX);})
// 获得当前版本号
#define SYSTEM_VERSION [UIDevice currentDevice].systemVersion
// 底部安全区域 + tabBar高度
#define BOTTOMWITHTABBAR_HEIGHT (IS_IPHONEX_SERIES ? (49.f+34.f) : 49.f)
// 底部安全区域
#define BOTTOM_HEIGHT (IS_IPHONEX_SERIES ? 34.f : 0.f)
// 分割线高度
#define LINE_HEIGHT (1.0/[UIScreen mainScreen].scale)
// 屏幕宽度
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
// 屏幕高度
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
// 内容宽度
#define SCREEN_CONTENT_WIDTH (SCREEN_WIDTH - 2*[SMRUIAdapter margin])

@interface SMRUIAdapter : NSObject

/// 适配比例 实际宽度 / 设计稿宽度
+ (CGFloat)scale;
+ (CGFloat)value:(CGFloat)value;
+ (CGPoint)point:(CGPoint)point;
+ (CGSize)size:(CGSize)size;
+ (CGRect)rect:(CGRect)rect;
+ (UIEdgeInsets)insets:(UIEdgeInsets)insets;

/// 常用数值,配置请参考BaseCore.h头文件
+ (CGFloat)margin; ///< default:20*scale

/// 系统版本是否大于或等于10.0
+ (BOOL)overtopiOS10;
/// 系统版本是否大于或等于11.0
+ (BOOL)overtopiOS11;
/// 系统版本是否大于或等于12.0
+ (BOOL)overtopiOS12;

@end

NS_ASSUME_NONNULL_END
