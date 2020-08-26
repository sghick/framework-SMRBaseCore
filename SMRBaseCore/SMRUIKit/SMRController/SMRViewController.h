//
//  SMRViewController.h
//  SMRBaseCoreDemo
//
//  Created by 丁治文 on 2018/12/19.
//  Copyright © 2018 BaoDashi. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol SMRViewControllerAdapterDelegate <NSObject>

@optional
/**
 自动布局方式(viewWillAppear后)
 */
- (UIScrollViewContentInsetAdjustmentBehavior)adjustmentBehavior API_AVAILABLE(ios(11.0));
- (BOOL)adjustmentBehaviorForIOS11Before;

/**
自动布局方式(viewDidAppear后)
*/
- (UIScrollViewContentInsetAdjustmentBehavior)after_adjustmentBehavior API_AVAILABLE(ios(11.0));
- (BOOL)after_adjustmentBehaviorForIOS11Before;

@end

@class SMRNetAPI;
@class SMRAPICallback;
@interface SMRViewController : UIViewController<SMRViewControllerAdapterDelegate>

/** 前置图片,可用来做缺省样式 */
@property (strong, nonatomic, readonly) UIImageView *frontImageView;

/** 页面名称 */
@property (strong, nonatomic) NSString *pageName;

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

/** 记录一次性移除个数,与indexSetForRemoveWhenViewDidLoad配合使用,默认为1,需要手动累加 */
@property (assign, nonatomic) NSInteger recentyCount;


/** 前置图 */
- (void)showFrontImageView;
- (void)hideFrontImageView;

/** 栈中recentyCount个控制器 */
- (NSIndexSet *)recentyIndexSet;

/**
 发起网络请求
 */
- (void)query:(SMRNetAPI *)api callback:(nullable SMRAPICallback *)callback __deprecated_msg("已废弃,使用-[SMRNetAPI queryWithCallback:]");

/**
 @override
 是否允许右滑返回,默认YES
 */
- (BOOL)allowBackByGesture;

/**
 页面统计中的页面名称,默认为类名
 更换值,请子类重写此方法
 */
- (NSString *)pageName;

@end

NS_ASSUME_NONNULL_END
