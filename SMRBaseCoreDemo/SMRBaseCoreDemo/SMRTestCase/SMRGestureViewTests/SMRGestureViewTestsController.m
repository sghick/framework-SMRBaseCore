//
//  SMRGestureViewTestsController.m
//  SMRBaseCoreDemo
//
//  Created by 丁治文 on 2019/5/14.
//  Copyright © 2019 sumrise. All rights reserved.
//

#import "SMRGestureViewTestsController.h"
#import "SMRAdapter.h"
#import "UIColor+SMRTransform.h"
#import "UIView+SMRGesture.h"

@interface SMRGestureViewTestsController ()

@property (strong, nonatomic) UIButton *rectBtn;
@property (strong, nonatomic) UIButton *roundBtn;

@property (strong, nonatomic) UIImageView *preImageView;
@property (strong, nonatomic) UIImageView *selImageView;

@end

@implementation SMRGestureViewTestsController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationView.theme = [self theme];
    self.navigationView.title = @"裁剪";
    self.navigationView.rightView = [self finishedBtn];
    self.view.backgroundColor = [UIColor smr_blackColor];
    [self.view addSubview:self.preImageView];
    [self.view addSubview:self.selImageView];
//    [self.view addSubview:self.rectBtn];
//    [self.view addSubview:self.roundBtn];
}

- (SMRNavigationTheme *)theme {
    SMRNavigationTheme *theme = [SMRNavigationTheme themeForAlpha];
    theme.backgroudColor = [[UIColor smr_blackColor] colorWithAlphaComponent:0.8];
    return theme;
}

- (UIButton *)finishedBtn {
    UIButton *btn = [SMRNavigationView buttonOfOnlyTextWithText:@"完成" target:self action:@selector(finishedBtnAction:)];
    [btn setTitleColor:[UIColor smr_whiteColor] forState:UIControlStateNormal];
    return btn;
}

#pragma mark - Actions

- (void)finishedBtnAction:(UIButton *)sender {
    [self popOrDismissViewController];
}

#pragma mark - Setters

- (void)setPreImage:(UIImage *)preImage {
    _preImage = preImage;
    self.preImageView.image = preImage;
    
    self.preImageView.frame = CGRectMake(0,
                                         0,
                                         [SMRUIAdapter value:150],
                                         [SMRUIAdapter value:150]);
    self.preImageView.center = self.selImageView.center;
//    [self.preImageView addPanGestureWithinFrame:self.selImageView.frame
//                                           viewSize:self.preImageView.frame.size
//                                             bounce:50
//                                     allowDirection:CGVectorMake(1, 1)];
    [self.preImageView addPanGestureWithinFrame:self.selImageView.frame
                                         bounce:50
                                 allowDirection:CGVectorMake(1, 1)];
    [self.preImageView addTapGesture];
    
    
    __block UIView *outborder = [[UIView alloc] initWithFrame:self.selImageView.frame];
    outborder.layer.borderColor = [UIColor redColor].CGColor;
    outborder.layer.borderWidth = 1;
    outborder.userInteractionEnabled = NO;
    [self.view addSubview:outborder];
    
    [self.preImageView addPinchGestureWithinMinScale:0.8 maxScale:1.5 scaleChangedBlock:^(CGAffineTransform transform, UIView * _Nonnull view) {
        outborder.frame = view.safeGestureItem.panFrame;
    }];
    
    [self bringNavigationViewToFront];
}

#pragma mark - Getters

- (UIImageView *)preImageView {
    if (!_preImageView) {
        _preImageView = [[UIImageView alloc] init];
    }
    return _preImageView;
}

- (UIImageView *)selImageView {
    if (!_selImageView) {
        _selImageView = [[UIImageView alloc] init];
        _selImageView.frame = CGRectMake((SCREEN_WIDTH - [SMRUIAdapter value:150])/2.0,
                                         [SMRUIAdapter value:200],
                                         [SMRUIAdapter value:150],
                                         [SMRUIAdapter value:150]);
        _selImageView.layer.borderColor = [UIColor smr_deepOrangeColor].CGColor;
        _selImageView.layer.borderWidth = 1;
    }
    return _selImageView;
}

- (UIButton *)roundBtn {
    if (!_roundBtn) {
        _roundBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _roundBtn.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH);
        _roundBtn.center = self.selImageView.center;
        [_roundBtn setTitle:@"移动" forState:UIControlStateNormal];
        [_roundBtn setTitleColor:[UIColor smr_blackColor] forState:UIControlStateNormal];
        _roundBtn.backgroundColor = [UIColor yellowColor];
        _roundBtn.layer.cornerRadius = 50;
        [_roundBtn addPanGestureWithinFrame:self.selImageView.frame bounce:150 allowDirection:CGVectorMake(1, 1)];
        [_roundBtn addPinchGestureWithinMinScale:0.8 maxScale:1.5];
    }
    return _roundBtn;
}

- (UIButton *)rectBtn {
    if (!_rectBtn) {
        _rectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _rectBtn.frame = CGRectMake(0, 0, 150, 150);
        _rectBtn.center = self.selImageView.center;
        [_rectBtn setTitle:@"移动" forState:UIControlStateNormal];
        [_rectBtn setTitleColor:[UIColor smr_blackColor] forState:UIControlStateNormal];
        _rectBtn.backgroundColor = [UIColor smr_generalRedColor];
        [_rectBtn addPanGestureWithinFrame:self.selImageView.frame bounce:50 allowDirection:CGVectorMake(1, 1)];
    }
    return _rectBtn;
}

@end
