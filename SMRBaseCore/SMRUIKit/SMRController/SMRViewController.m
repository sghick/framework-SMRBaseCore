//
//  SMRViewController.m
//  SMRBaseCoreDemo
//
//  Created by 丁治文 on 2018/12/19.
//  Copyright © 2018 BaoDashi. All rights reserved.
//

#import "SMRViewController.h"
#import "SMRNavigationController.h"
#import "SMRGlobalCache.h"
#import "SMRNetwork.h"
#import "SMRLog.h"

@interface SMRViewController ()

@property (copy  , nonatomic) NSString *UMPageName;

@end

@implementation SMRViewController

@synthesize frontImageView = _frontImageView;

- (void)dealloc {
    base_core_log(@"成功释放控制器:<%@: %p> %@", [self class], &self, self.title);
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    base_core_warning_log(@"内存警告:<%@: %p> %@", [self class], &self, self.title);
    [SMRGlobalCache clearUnnecessaryCaches];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
        _recentyCount = 1;
        _isMainPage = NO;
        _statusBarStyle = UIStatusBarStyleDefault;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden = YES;
    
    // backgroundColor
    self.view.backgroundColor = [UIColor whiteColor];
    self.view.multipleTouchEnabled = NO;
    
    if (self.indexSetForRemoveWhenViewDidLoad) {
        NSMutableArray *stack = [self.navigationController.viewControllers mutableCopy];
        // 从栈中移除选择分类的页面
        [stack removeObjectsAtIndexes:self.indexSetForRemoveWhenViewDidLoad];
        self.navigationController.viewControllers = [stack copy];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (@available(iOS 11.0, *)) {
        if ([self respondsToSelector:@selector(adjustmentBehavior)]) {
            [UIScrollView appearance].contentInsetAdjustmentBehavior = [self adjustmentBehavior];
        }
    } else {
        if ([self respondsToSelector:@selector(adjustmentBehaviorForIOS11Before)]) {
            self.automaticallyAdjustsScrollViewInsets = [self adjustmentBehaviorForIOS11Before];
        }
    }
    
    // BackGesture,每次页面切换时需要切换
    [self setNeedsBackGestureUpdated];
}

- (void)viewDidAppear:(BOOL)animated {
    if (@available(iOS 11.0, *)) {
        if ([self respondsToSelector:@selector(after_adjustmentBehavior)]) {
            [UIScrollView appearance].contentInsetAdjustmentBehavior = [self after_adjustmentBehavior];
        }
    } else {
        if ([self respondsToSelector:@selector(after_adjustmentBehaviorForIOS11Before)]) {
            self.automaticallyAdjustsScrollViewInsets = [self after_adjustmentBehaviorForIOS11Before];
        }
    }
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

#pragma mark - FrontImageView

- (void)showFrontImageView {
    if (!self.frontImageView.superview) {
        [self.view addSubview:self.frontImageView];
        self.frontImageView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    }
    self.frontImageView.alpha = 1;
    self.frontImageView.hidden = NO;
    [self.view bringSubviewToFront:self.frontImageView];
}

- (void)hideFrontImageView {
    if (self.frontImageView.hidden) {
        return;
    }
    [UIView animateWithDuration:0.3 animations:^{
        self.frontImageView.alpha = 0;
    } completion:^(BOOL finished) {
        self.frontImageView.hidden = YES;
    }];
}

- (UIImageView *)frontImageView {
    if (!_frontImageView) {
        _frontImageView = [[UIImageView alloc] init];
    }
    return _frontImageView;
}

#pragma mark - RemoveWhenViewDidLoad

- (NSIndexSet *)recentyIndexSet {
    return [self recentyIndexSetWithCount:self.recentyCount];
}

- (NSIndexSet *)recentyIndexSetWithCount:(NSInteger)count {
    if (self.navigationController.viewControllers.count > count) {
        return [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(self.navigationController.viewControllers.count - count, count)];
    }
    return nil;
}

#pragma mark - RightSwiptBack

- (BOOL)allowBackByGesture {
    return YES;
}

- (void)setNeedsBackGestureUpdated {
    SMRNavigationController *nav = (SMRNavigationController *)self.navigationController;
    if (![nav isKindOfClass:[SMRNavigationController class]]) {
        return;
    }
    if ([self allowBackByGesture]) {
        (!nav.backGesture) ? [nav addSupportBackGesture] : NULL;
    } else {
        nav.backGesture ? [nav removeSupportBackGesture] : NULL;
    }
}

#pragma mark - StatusBarStyle

- (UIStatusBarStyle)preferredStatusBarStyle {
    return self.statusBarStyle;
}

- (void)setStatusBarStyle:(UIStatusBarStyle)statusBarStyle {
    _statusBarStyle = statusBarStyle;
    [self setNeedsStatusBarAppearanceUpdate];
}

#pragma mark - MainPage

- (void)addChildViewController:(SMRViewController *)childController {
    if (!childController) {
        return;
    }
    [super addChildViewController:childController];
    if ([childController isKindOfClass:[SMRViewController class]]) {
        childController.isMainPage = self.isMainPage;
    }
}

- (void)query:(SMRNetAPI *)api callback:(nullable SMRAPICallback *)callback {
    [[SMRNetManager sharedManager] query:api callback:callback];
}

#pragma mark - Getters/Setters

- (void)setIsMainPage:(BOOL)isMainPage {
    _isMainPage = isMainPage;
    // 非首页属性,默认隐藏BottomBar
    self.hidesBottomBarWhenPushed = !isMainPage;
}

- (NSString *)pageName {
    if (!_pageName) {
        _pageName = NSStringFromClass([self class]);
    }
    return _pageName;
}

- (UIScrollViewContentInsetAdjustmentBehavior)adjustmentBehavior  API_AVAILABLE(ios(11.0)) {
    return UIScrollViewContentInsetAdjustmentAutomatic;
}

- (BOOL)adjustmentBehaviorForIOS11Before {
    return YES;
}

@end
