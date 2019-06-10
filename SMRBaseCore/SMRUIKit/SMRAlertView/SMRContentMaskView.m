//
//  SMRContentMaskView.m
//  SMRBaseCoreDemo
//
//  Created by 丁治文 on 2019/2/13.
//  Copyright © 2019 sumrise. All rights reserved.
//

#import "SMRContentMaskView.h"
#import "SMRAdapter.h"
#import "PureLayout.h"

@interface SMRContentMaskView ()<
UIGestureRecognizerDelegate>

@property (strong, nonatomic) UIControl *backControl;
@property (strong, nonatomic) UIControl *contentControl;
@property (assign, nonatomic) CGFloat heightOfContentView;
@property (strong, nonatomic) NSLayoutConstraint *heightOfContentViewLayout;

@property (weak  , nonatomic) SMRContentMaskView *superMaskView;
@property (strong, nonatomic) UIColor *superMaskViewBackColor;
@property (assign, nonatomic) BOOL superMaskViewContentHidden;

@end

@implementation SMRContentMaskView

@synthesize didLoadLayout = _didLoadLayout;
@synthesize backgroundImageView = _backgroundImageView;
@synthesize contentView = _contentView;

- (void)dealloc {
//    NSLog(@"成功释放对象:<%@: %p>", [self class], &self);
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (CGRectEqualToRect(frame, CGRectZero)) {
        frame = [UIScreen mainScreen].bounds;
    }
    self = [super initWithFrame:frame];
    if (self) {
        [self createContentMaskSubviews];
    }
    return self;
}

- (void)createContentMaskSubviews {
    _heightOfContentView = 40;
    _autoAdjustIfShowInMaskView = YES;
    self.alpha = 1;
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
    [self addSubview:self.backControl];
    [self addSubview:self.backgroundImageView];
    [self addSubview:self.contentView];
    [self setNeedsUpdateConstraints];
}

- (void)updateConstraints {
    if (!self.didLoadLayout) {
        _didLoadLayout = YES;
        [self.backControl autoPinEdgesToSuperviewMargins];
        [self.contentControl autoPinEdgesToSuperviewMargins];
        
        UIEdgeInsets insets1 = [self contentInsetsOfBackgroundImageView];
        [self.backgroundImageView autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.contentView withOffset:-insets1.top];
        [self.backgroundImageView autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.contentView withOffset:-insets1.left];
        [self.backgroundImageView autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.contentView withOffset:insets1.bottom];
        [self.backgroundImageView autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.contentView withOffset:insets1.right];
        
        SMRContentMaskViewContentAlignment alignment = [self contentAlignmentOfMaskView];
        if (alignment == SMRContentMaskViewContentAlignmentCenter) {
            // 默认居中
            [self.contentView autoCenterInSuperview];
            [self.contentView autoSetDimension:ALDimensionWidth toSize:[self widthOfContentView]];
            [NSLayoutConstraint autoSetPriority:UILayoutPriorityDefaultLow forConstraints:^{
                self.heightOfContentViewLayout = [self.contentView autoSetDimension:ALDimensionHeight toSize:self.heightOfContentView relation:NSLayoutRelationGreaterThanOrEqual];
            }];
        } else {
            // 在底部
            [self.contentView autoAlignAxisToSuperviewAxis:ALAxisVertical];
            [self.contentView autoPinEdgeToSuperviewEdge:ALEdgeBottom];
            [self.contentView autoSetDimension:ALDimensionWidth toSize:[self widthOfContentView]];
            [NSLayoutConstraint autoSetPriority:UILayoutPriorityDefaultLow forConstraints:^{
                self.heightOfContentViewLayout = [self.contentView autoSetDimension:ALDimensionHeight toSize:self.heightOfContentView relation:NSLayoutRelationGreaterThanOrEqual];
            }];
        }
    }
    [super updateConstraints];
}

#pragma mark - SMRContentMaskViewProtocol

- (UIView *)contentViewOfMaskView {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor whiteColor];
    return view;
}

- (CGFloat)widthOfContentView {
    return CGRectGetWidth([UIScreen mainScreen].bounds) - 2*[SMRUIAdapter value:43.0];
}

- (SMRContentMaskViewContentAlignment)contentAlignmentOfMaskView {
    return SMRContentMaskViewContentAlignmentCenter;
}

- (UIEdgeInsets)contentInsetsOfBackgroundImageView {
    return UIEdgeInsetsZero;
}

#pragma mark - Actions

- (void)backgroundViewTapAction:(id)sender {
    if (self.backgroundTouchedBlock) {
        self.backgroundTouchedBlock(self);
    }
}

- (void)contentViewTapAction:(id)sender {
    if (self.contentViewTouchedBlock) {
        self.contentViewTouchedBlock(self);
    }
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if ([gestureRecognizer.view isEqual:self]) {
        return YES;
    }
    if ([gestureRecognizer.view isEqual:self.contentView]) {
        return YES;
    }
    return NO;
}

#pragma mark - Utils

- (void)updateHeightOfContentView:(CGFloat)heightOfContentView {
    _heightOfContentView = heightOfContentView;
    [self.heightOfContentViewLayout autoRemove];
    [NSLayoutConstraint autoSetPriority:UILayoutPriorityDefaultLow forConstraints:^{
        self.heightOfContentViewLayout = [self.contentView autoSetDimension:ALDimensionHeight toSize:heightOfContentView relation:NSLayoutRelationGreaterThanOrEqual];
    }];
    [self setNeedsUpdateConstraints];
}

- (void)show {
    [self showAnimated:YES];
}
- (void)showAnimated:(BOOL)animated {
    [self showInView:[UIApplication sharedApplication].delegate.window animated:animated];
}
- (void)showInView:(UIView *)view animated:(BOOL)animated {
    if (!view) {
        return;
    }
    if (self.autoAdjustIfShowInMaskView && [view isKindOfClass:[SMRContentMaskView class]]) {
        // show的时候,需要隐藏back和content,hide的时候需要展示其父类的back和content
        self.superMaskView = (SMRContentMaskView *)view;
        // 保存原来的color
        self.superMaskViewBackColor = self.superMaskView.backgroundColor;
        self.superMaskViewContentHidden = self.superMaskView.contentView.hidden;
        self.superMaskView.backgroundColor = [UIColor clearColor];
        self.superMaskView.contentView.hidden = YES;
    }
    [view addSubview:self];
    if (animated) {
        // show back
        [UIView animateWithDuration:0.25 animations:^{
            self.alpha = 1;
        }];
        
        // show content
        SMRContentMaskViewContentAlignment alignment = [self contentAlignmentOfMaskView];
        if (alignment == SMRContentMaskViewContentAlignmentCenter) {
            
        } else {
            CGFloat offsetY = self.heightOfContentViewLayout.constant;
            self.contentView.transform = CGAffineTransformMakeTranslation(0, offsetY);
            [UIView animateWithDuration:0.25 animations:^{
                self.contentView.alpha = 1;
                self.contentView.transform = CGAffineTransformMakeTranslation(0, 0);
            }];
        }
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
        SMRContentMaskViewContentAlignment alignment = [self contentAlignmentOfMaskView];
        if (alignment == SMRContentMaskViewContentAlignmentCenter) {
            // hide back
            [UIView animateWithDuration:0.25 animations:^{
                self.alpha = 0;
            } completion:^(BOOL finished) {
                [self removeFromSuperview];
            }];
        } else {
            // hide content
            CGFloat offsetY = self.heightOfContentViewLayout.constant;
            [UIView animateWithDuration:0.25 animations:^{
                self.contentView.transform = CGAffineTransformMakeTranslation(0, offsetY);
            }];
            
            // hide back
            [UIView animateWithDuration:0.25 animations:^{
                self.alpha = 0;
                self.contentView.alpha = 0;
            } completion:^(BOOL finished) {
                [self removeFromSuperview];
            }];
        }
    } else {
        [self removeFromSuperview];
    }
}

- (void)hideAllMaskViewWithAnimated:(BOOL)animated {
    // 遍历至最根部的maskView
    SMRContentMaskView *sp = self;
    while ([sp.superview isKindOfClass:[SMRContentMaskView class]]) {
        sp = (SMRContentMaskView *)sp.superview;
    }
    [sp hideAnimated:animated];
}

- (void)recoverSuperViewIfNeeded {
    if (self.superMaskView && [self.superMaskView isKindOfClass:[SMRContentMaskView class]]) {
        self.superMaskView.backgroundColor = self.superMaskViewBackColor;
        self.superMaskView.contentView.hidden = self.superMaskViewContentHidden;
        self.superMaskView = nil;
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
    if (!_contentView) {
        _contentView = [self contentViewOfMaskView];
        [_contentView addSubview:self.contentControl];
    }
    return _contentView;
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
