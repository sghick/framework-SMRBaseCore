//
//  SMRNavigator.h
//  SMRRouterDemo
//
//  Created by 丁治文 on 2018/10/2.
//  Copyright © 2018年 sumrise.com. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef UIViewController *(^SMRMainwindowRootController)(UIViewController *root);
typedef UIViewController *(^SMRKeywindowRootController)(void);
typedef UITabBarController *(^SMRRootTabbarController)(void);
typedef UINavigationController *(^SMRRootTabNavigationController)(NSInteger tab);
typedef UINavigationController *(^SMRChangeRootTabNavigationController)(NSInteger tab);

@interface SMRNavigator : NSObject

/// 设置获取root的方法,center默认使用此控制器跳转
@property (nonatomic, copy  ) SMRMainwindowRootController mainwindowRootControllerBlock;

/// 1.设置获取root的方法,默认获取keywindow的root
@property (nonatomic, copy  ) SMRKeywindowRootController keywindowRootControllerBlock;
/// 2.设置获取rootTabBarController的方法,无此root则返回nil
@property (nonatomic, copy  ) SMRRootTabbarController rootTabbarControllerBlock;
/// 3.设置获取rootTabBarController的NavigationController的方法,无此root则返回nil
@property (nonatomic, copy  ) SMRRootTabNavigationController rootTabNavigationControllerBlock;
/// 3.设置选中tabBar的方法,无此root则无响应
@property (nonatomic, copy  ) SMRChangeRootTabNavigationController changeRootTabNavigationControllerBlock;

+ (instancetype)sharedNavigator;

/// 重置堆栈
+ (void)resetToRootViewControllerWithCompletion:(void (^)(void))completion;
/// 获取最顶层的VC,center默认使用此控制器跳转
+ (UIViewController *)getMainwindowTopController;

/// 1.调用block获取root
+ (UIViewController *)getKeywindowRootController;
/// 2.调用block获取root
+ (UITabBarController *)getRootTabbarController;
/// 3.调用block获取root,未获取到则返回nil.
+ (UINavigationController *)getRootTabNavigationControllerWithTab:(NSInteger)tab;
/// 3.切换相应的tab,并返回切换后的root.
+ (UINavigationController *)changeRootTabNavigationControllerWithTab:(NSInteger)tab;

/// 跳转一个控制器,如果对应Tab存在,则切换到目标Tab
+ (BOOL)pushOrPresentToMainTabViewController:(UIViewController *)controller animated:(BOOL)animated tab:(NSInteger)tab;

+ (BOOL)pushOrPresentToViewController:(UIViewController *)viewController animated:(BOOL)animated;
+ (BOOL)pushOrPresentToViewController:(UIViewController *)viewController baseController:(UIViewController *)baseController animated:(BOOL)animated;

+ (BOOL)pushToViewController:(UIViewController *)viewController baseController:(UINavigationController *)baseController animated:(BOOL)animated;
+ (BOOL)presentToViewController:(UIViewController *)viewController baseController:(UIViewController *)baseController animated:(BOOL)animated;

+ (void)popOrDismissViewController:(UIViewController *)viewController animated:(BOOL)animated;

@end
