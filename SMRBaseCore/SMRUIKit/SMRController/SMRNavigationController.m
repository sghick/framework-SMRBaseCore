//
//  SMRNavigationController.m
//  SMRBaseCoreDemo
//
//  Created by 丁治文 on 2019/1/21.
//  Copyright © 2019 sumrise. All rights reserved.
//

#import "SMRNavigationController.h"

@interface SMRNavigationController ()<
UINavigationControllerDelegate,
UIGestureRecognizerDelegate>

@property (weak  , nonatomic) id<UINavigationControllerDelegate> savedNavigationDelegate;
@property (weak  , nonatomic) id<UIGestureRecognizerDelegate> savedGestureDelegate;

@end

@implementation SMRNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addSupportBackGesture];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)] && animated == YES ) {
        self.interactivePopGestureRecognizer.enabled = NO;
    }
    [super pushViewController:viewController animated:animated];
}

- (NSArray *)popToRootViewControllerAnimated:(BOOL)animated {
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)] && animated == YES ) {
        self.interactivePopGestureRecognizer.enabled = NO;
    }
    return [super popToRootViewControllerAnimated:animated];
}

- (NSArray *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if ( [self respondsToSelector:@selector(interactivePopGestureRecognizer)] ) {
        self.interactivePopGestureRecognizer.enabled = NO;
    }
    return [super popToViewController:viewController animated:animated];
}

- (void)navigationController:(UINavigationController *)navigationController
       didShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animate {
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        if (navigationController.childViewControllers.count == 1) {
            self.interactivePopGestureRecognizer.enabled = NO;
        } else {
            self.interactivePopGestureRecognizer.enabled = YES;
        }
    }
}

#pragma mark - Utils

- (void)addSupportBackGesture {
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        if (self.interactivePopGestureRecognizer.delegate != self) {
            self.savedGestureDelegate = self.interactivePopGestureRecognizer.delegate;
        }
        if (self.delegate != self) {
            self.savedNavigationDelegate = self.delegate;
        }
        self.interactivePopGestureRecognizer.delegate = self;
        self.delegate = self;
        _backGesture = YES;
    }
}

- (void)removeSupportBackGesture {
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.enabled = YES;
        self.interactivePopGestureRecognizer.delegate = self.savedGestureDelegate;
        self.delegate = self.savedNavigationDelegate;
        _backGesture = NO;
    }
}

@end
