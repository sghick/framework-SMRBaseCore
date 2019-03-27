//
//  SMRViewController.h
//  SMRBaseCoreDemo
//
//  Created by 丁治文 on 2019/1/21.
//  Copyright © 2019 sumrise. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class SMRNetAPI;
@class SMRAPICallback;
@interface SMRViewController : UIViewController

/**
 设置为首页展示的属性,默认NO
 */
@property (assign, nonatomic) BOOL isMainPage;

/**
 设置状态栏颜色
 */
@property (assign, nonatomic) UIStatusBarStyle statusBarStyle;

/**
 当页面加载完成后,自动移除栈中的页面,为下标索引,默认为nil
 */
@property (strong, nonatomic) NSIndexSet *indexSetForRemoveWhenViewDidLoad;

/**
 发起网络请求
 */
- (void)query:(SMRNetAPI *)api callback:(nullable SMRAPICallback *)callback;

/**
 @override
 是否允许右滑返回,默认YES
 */
- (BOOL)allowBackByGesture;

/**
 页面统计中的页面名称,默认为类名
 更换值,请子类重写此方法
 */
- (NSString *)UMPageName;

/**
 是否开启智能键盘,默认开启:YES
 */
- (BOOL)IQKeyBoardEnable;

/**
 键盘与textField的距离,默认:10
 */
- (CGFloat)keyboardDistanceFromTextField;

@end

NS_ASSUME_NONNULL_END
