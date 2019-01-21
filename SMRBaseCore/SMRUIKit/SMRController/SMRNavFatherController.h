//
//  SMRNavFatherController.h
//  SMRBaseCoreDemo
//
//  Created by 丁治文 on 2019/1/21.
//  Copyright © 2019 sumrise. All rights reserved.
//

#import "SMRViewController.h"
#import "SMRNavigationDefine.h"
#import "SMRNavigationView.h"

NS_ASSUME_NONNULL_BEGIN

@protocol SMRNavFatherControllerProtocol <NSObject>

// 在控制器中重写本方法来确定要用的navigationView,不用写super
- (SMRNavigationView *)navigationViewInitialization;

@end

@interface SMRNavFatherController : SMRViewController <
SMRNavFatherControllerProtocol,
SMRNavigationViewDelegate>

/**
 本控制器中的导航条
 */
@property (nonatomic, strong) SMRNavigationView *navigationView;

/// 已被重写
- (nullable NSString *)title;
- (void)setTitle:(nullable NSString *)title;

/**
 @override
 在当前面初始化一个navigationView
 */
- (SMRNavigationView *)navigationViewInitialization;

/**
 获取当前页面的navigationView
 */
- (__kindof SMRNavigationView *)navigationView;

/**
 需要手动将navigationView视图层级往上提
 */
- (void)bringNavigationViewToFront;

/**
 页面出栈
 */
- (void)popOrDismissViewController;
- (void)popOrDismissViewControllerAnimated:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END
