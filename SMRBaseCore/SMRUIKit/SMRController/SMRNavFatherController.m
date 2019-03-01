//
//  SMRNavFatherController.m
//  SMRBaseCoreDemo
//
//  Created by 丁治文 on 2019/1/21.
//  Copyright © 2019 sumrise. All rights reserved.
//

#import "SMRNavFatherController.h"

@interface SMRNavFatherController ()

@property (nonatomic, assign) BOOL onceViewDidLoad;///< 只允许viewDidLoad之前直接设置和替换navigationView

@end

@implementation SMRNavFatherController
@synthesize navigationView = _navigationView;

- (void)viewDidLoad {
    [super viewDidLoad];
    _onceViewDidLoad = YES;
    // 给一个默认值
    if (self.navigationController) {
        self.navigationView.backBtnHidden = !(self.navigationController.viewControllers.count > 1);
    } 
    // Do any additional setup after loading the view.
    [self checkNeedsAddSubview];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

#pragma mark - Private Method

- (void)checkNeedsAddSubview {
    if (self.onceViewDidLoad) {
        [self.view addSubview:self.navigationView];
    }
}

#pragma mark - SMRNavFatherControllerProtocol

- (SMRNavigationView *)navigationViewInitialization {
    return [SMRNavigationView navigationView];
}

#pragma mark - SMRNavigationViewDelegate

- (void)navigationView:(SMRNavigationView *)nav didBackBtnTouched:(UIButton *)sender {
    [self popOrDismissViewController];
}

#pragma mark - Utils

- (void)bringNavigationViewToFront {
    [self.view bringSubviewToFront:self.navigationView];
}

- (void)popOrDismissViewController {
    [self popOrDismissViewControllerAnimated:YES];
}

- (void)popOrDismissViewControllerAnimated:(BOOL)animated {
    if (self.navigationController.viewControllers.count > 1) {
        [self.navigationController popViewControllerAnimated:animated];
    } else {
        [self dismissViewControllerAnimated:animated completion:nil];
    }
}

#pragma mark - Setters/Getters

// 重写
- (nullable NSString *)title {
    return _navigationView.title;
}
- (void)setTitle:(nullable NSString *)title {
    self.navigationView.title = title;
}

- (void)setNavigationView:(SMRNavigationView *)navigationView {
    if (_navigationView != navigationView) {
        [_navigationView removeFromSuperview];
        _navigationView = nil;
        _navigationView = navigationView;
        _navigationView.delegate = self;
        [self checkNeedsAddSubview];
    }
}

- (__kindof SMRNavigationView *)navigationView {
    if (_navigationView == nil) {
        if ([self respondsToSelector:@selector(navigationViewInitialization)]) {
            _navigationView = [self navigationViewInitialization];
            _navigationView.delegate = self;
        } else {
            SMRNavigationView *navigationView = [[SMRNavigationView alloc] init];
            _navigationView = navigationView;
            _navigationView.delegate = self;
        }
    }
    return _navigationView;
}

@end
