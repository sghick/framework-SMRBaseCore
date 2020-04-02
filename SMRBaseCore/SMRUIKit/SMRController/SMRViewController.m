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
#import "SMRLog.h"

@interface SMRViewController ()

@property (copy  , nonatomic) NSString *UMPageName;

@end

@implementation SMRViewController

- (void)dealloc {
    base_core_log(@"成功释放控制器:<%@: %p> %@", [self class], &self, self.title);
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    base_core_log(@"内存警告:<%@: %p> %@", [self class], &self, self.title);
    [[SDImageCache sharedImageCache] clearMemory];
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
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
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
    [super addChildViewController:childController];
    if ([childController isKindOfClass:[SMRViewController class]]) {
        childController.isMainPage = self.isMainPage;
    }
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

- (UIScrollViewContentInsetAdjustmentBehavior)adjustmentBehavior {
    return UIScrollViewContentInsetAdjustmentAutomatic;
}

- (BOOL)adjustmentBehaviorForIOS11Before {
    return YES;
}

@end
