//
//  SMRViewController.m
//  SMRBaseCoreDemo
//
//  Created by 丁治文 on 2019/1/21.
//  Copyright © 2019 sumrise. All rights reserved.
//

#import "SMRViewController.h"
#import "SMRNavigationController.h"
#import "SDImageCache.h"
#import "SMRNetwork.h"
#import "IQKeyboardManager.h"

@interface SMRViewController ()

@property (copy  , nonatomic) NSString *UMPageName;

@end

@implementation SMRViewController

- (void)dealloc {
    NSLog(@"成功释放控制器:<%@: %p> %@", [self class], &self, self.title);
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    NSLog(@"内存警告:<%@: %p> %@", [self class], &self, self.title);
    [[SDImageCache sharedImageCache] clearMemory];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
        _isMainPage = NO;
        _statusBarStyle = UIStatusBarStyleDefault;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden = YES;
    if (@available(iOS 11.0, *)) {
        [UIScrollView appearance].contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
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
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    // 友盟统计
    Class umcls = NSClassFromString(@"MobClick");
    if ([umcls respondsToSelector:NSSelectorFromString(@"beginLogPageView:")]) {
        [umcls performSelector:NSSelectorFromString(@"beginLogPageView:") withObject:self.UMPageName];
    }
#pragma clang diagnostic pop
    
    // BackGesture,每次页面切换时需要切换
    [self setNeedsBackGestureUpdated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    // 友盟统计
    Class umcls = NSClassFromString(@"MobClick");
    if ([umcls respondsToSelector:NSSelectorFromString(@"endLogPageView:")]) {
        [umcls performSelector:NSSelectorFromString(@"endLogPageView:") withObject:self.UMPageName];
    }
#pragma clang diagnostic pop
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

#pragma mark - RightSwiptBack

- (BOOL)allowBackByGesture {
    return YES;
}

- (void)setNeedsBackGestureUpdated {
    SMRNavigationController *nav = (SMRNavigationController *)self.navigationController;
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

- (NSString *)UMPageName {
    if (!_UMPageName) {
        _UMPageName = NSStringFromClass([self class]);
    }
    return _UMPageName;
}

#pragma mark - IQKeyBoard

- (BOOL)IQKeyBoardEnable {
    return YES;
}

- (CGFloat)keyboardDistanceFromTextField {
    return 10;
}

@end
