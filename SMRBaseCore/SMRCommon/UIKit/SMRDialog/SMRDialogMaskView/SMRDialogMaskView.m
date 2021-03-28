//
//  SMRDialogMaskView.m
//  Hermes
//
//  Created by Tinswin on 2021/3/26.
//  Copyright © 2021 ibaodashi. All rights reserved.
//

#import "SMRDialogMaskView.h"
#import "PureLayout.h"

@interface SMRDialogMaskView ()<
UIGestureRecognizerDelegate>

@property (strong, nonatomic) UIControl *backControl;
@property (strong, nonatomic) UIControl *contentControl;

@property (weak  , nonatomic) SMRDialogMaskView *superMaskView;
@property (strong, nonatomic) UIColor *superMaskViewBackColor;
@property (assign, nonatomic) BOOL superMaskViewContentHidden;
@property (strong, nonatomic) UIColor *thisMaskViewContentBackColor;

@end

@implementation SMRDialogMaskView

@synthesize backgroundImageView = _backgroundImageView;
@synthesize maskContentView = _maskContentView;

+ (instancetype)dialogView {
    SMRDialogMaskView *view = [[super alloc] init];
    return view;
}

- (instancetype)initWithFrame:(CGRect)frame {
    frame = [UIScreen mainScreen].bounds;
    self = [super initWithFrame:frame];
    if (self) {
        _animationDuration = 0.35;
        _autoAdjustIfShowInMaskView = YES;
        [self p_createContentMaskSubviews];
        [self dialogViewCreated];
    }
    return self;
}

- (void)p_createContentMaskSubviews {
    self.alpha = 1;
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
    [self addSubview:self.backControl];
    [self addSubview:self.backgroundImageView];
    [self addSubview:self.maskContentView];
    
    UIEdgeInsets insets = [self contentInsetsOfBackgroundImageView];
    [self.backgroundImageView autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.maskContentView withOffset:-insets.top];
    [self.backgroundImageView autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.maskContentView withOffset:-insets.left];
    [self.backgroundImageView autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.maskContentView withOffset:insets.bottom];
    [self.backgroundImageView autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.maskContentView withOffset:insets.right];
}

#pragma mark - Override

- (void)dialogViewCreated {
    [self setContentViewSize:self.bounds.size animated:NO];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.backControl.frame = self.bounds;
}

#pragma mark - SMRDialogMaskViewProtocol

- (UIView *)contentViewOfMaskView {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor whiteColor];
    return view;
}

- (UIEdgeInsets)contentInsetsOfBackgroundImageView {
    return UIEdgeInsetsZero;
}

#pragma mark - SMRDialogMaskViewAnimation

- (void)animationOfShow {
    [UIView animateWithDuration:self.animationDuration animations:^{
        self.alpha = 1;
    }];
}

- (void)animationOfHide {
    [UIView animateWithDuration:self.animationDuration animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark - Actions

- (void)backgroundViewTapAction:(id)sender {
    [self endEditing:YES];
    if (self.backgroundTouchedBlock) {
        self.backgroundTouchedBlock(self);
    }
}

- (void)contentViewTapAction:(id)sender {
    [self endEditing:YES];
    if (self.contentViewTouchedBlock) {
        self.contentViewTouchedBlock(self);
    }
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if ([gestureRecognizer.view isEqual:self]) {
        return YES;
    }
    if ([gestureRecognizer.view isEqual:self.maskContentView]) {
        return YES;
    }
    return NO;
}

#pragma mark - Utils

- (void)setContentViewSize:(CGSize)size animated:(BOOL)animated {
    if (animated) {
        [UIView animateWithDuration:self.animationDuration animations:^{
            CGRect frame = {self.maskContentView.frame.origin, size};
            self.maskContentView.frame = frame;
            [self layoutIfNeeded];
        }];
    } else {
        CGRect frame = {self.maskContentView.frame.origin, size};
        self.maskContentView.frame = frame;
        [self setNeedsLayout];
    }
}

- (void)show {
    [self showAnimated:YES];
}
- (void)showAnimated:(BOOL)animated {
    [self showInView:nil animated:animated];
}
- (void)showInView:(nullable UIView *)inView animated:(BOOL)animated {
    UIView *view = inView ?: [UIApplication sharedApplication].delegate.window;
    if (!view) {
        return;
    }
    // 恢复因之前关闭时改变的颜色
    if (self.thisMaskViewContentBackColor) {
        self.backgroundColor = self.thisMaskViewContentBackColor;
    }
    if (self.autoAdjustIfShowInMaskView && [view isKindOfClass:SMRDialogMaskView.class]) {
        // show的时候,需要隐藏back和content,hide的时候需要展示其父类的back和content
        self.superMaskView = (SMRDialogMaskView *)view;
        // 保存原来的color
        self.superMaskViewBackColor = self.superMaskView.backgroundColor;
        self.superMaskViewContentHidden = self.superMaskView.maskContentView.hidden;
        self.superMaskView.backgroundColor = [UIColor clearColor];
        self.superMaskView.maskContentView.hidden = YES;
        self.alpha = 1;
    } else {
        self.alpha = 0;
    }
    [view addSubview:self];
    if (animated) {
        [self animationOfShow];
    } else {
        self.alpha = 1;
    }
}

- (void)hide {
    [self hideAnimated:YES];
}
- (void)hideAnimated:(BOOL)animated {
    // 恢复父类的样式属性
    [self recoverSuperViewIfNeeded];
    if (animated) {
        [self animationOfHide];
    } else {
        [self removeFromSuperview];
    }
}

- (void)hideAllMaskViewWithAnimated:(BOOL)animated {
    // 遍历至最根部的maskView
    SMRDialogMaskView *sp = self;
    while ([sp.superview isKindOfClass:SMRDialogMaskView.class]) {
        sp = (SMRDialogMaskView *)sp.superview;
    }
    [sp hideAnimated:animated];
}

- (void)recoverSuperViewIfNeeded {
    if (self.superMaskView && [self.superMaskView isKindOfClass:SMRDialogMaskView.class]) {
        self.superMaskView.backgroundColor = self.superMaskViewBackColor;
        self.superMaskView.maskContentView.hidden = self.superMaskViewContentHidden;
        self.superMaskView = nil;
        
        // 保存关闭时的颜色
        self.thisMaskViewContentBackColor = self.backgroundColor;
        self.backgroundColor = [UIColor clearColor];
    }
}

#pragma mark - Getters

- (UIImageView *)backgroundImageView {
    if (!_backgroundImageView) {
        _backgroundImageView = [[UIImageView alloc] init];
    }
    return _backgroundImageView;
}

- (UIView *)contentView {
    return self.maskContentView;
}

- (UIView *)maskContentView {
    if (!_maskContentView) {
        _maskContentView = [self contentViewOfMaskView];
        [_maskContentView addSubview:self.contentControl];
        [self.contentControl autoPinEdgesToSuperviewMargins];
    }
    return _maskContentView;
}

- (UIControl *)backControl {
    if (!_backControl) {
        _backControl = [[UIControl alloc] init];
        [_backControl addTarget:self action:@selector(backgroundViewTapAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backControl;
}

- (UIControl *)contentControl {
    if (!_contentControl) {
        _contentControl = [[UIControl alloc] init];
        [_contentControl addTarget:self action:@selector(contentViewTapAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _contentControl;
}

@end
