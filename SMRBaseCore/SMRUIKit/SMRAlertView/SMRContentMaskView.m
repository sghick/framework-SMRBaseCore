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
@property (strong, nonatomic) UIColor *thisMaskViewContentBackColor;

@property (assign, nonatomic) CGFloat animationDuration; ///< default:0.35

@end

@implementation SMRContentMaskView

@synthesize didLoadLayout = _didLoadLayout;
@synthesize backgroundImageView = _backgroundImageView;
@synthesize contentView = _contentView;

- (void)dealloc {
    //    NSLog(@"成功释放对象:<%@: %p>", [self class], &self);
}

- (instancetype)init {
    return [super init];
}

- (instancetype)initWithFrame:(CGRect)frame {
    return [self initWithFrame:frame contentAlignment:SMRContentMaskViewContentAlignmentCenter];
}

- (instancetype)initWithContentAlignment:(SMRContentMaskViewContentAlignment)contentAlignment {
    return [self initWithFrame:CGRectZero contentAlignment:contentAlignment];
}

- (instancetype)initWithFrame:(CGRect)frame contentAlignment:(SMRContentMaskViewContentAlignment)contentAlignment {
    if (CGRectEqualToRect(frame, CGRectZero)) {
        frame = [UIScreen mainScreen].bounds;
    }
    self = [super initWithFrame:frame];
    if (self) {
        _animationDuration = 0.35;
        _contentAlignment = contentAlignment;
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
            [self.heightOfContentViewLayout autoRemove];
            [NSLayoutConstraint autoSetPriority:UILayoutPriorityDefaultLow forConstraints:^{
                self.heightOfContentViewLayout = [self.contentView autoSetDimension:ALDimensionHeight toSize:self.heightOfContentView relation:NSLayoutRelationGreaterThanOrEqual];
            }];
        } else {
            // 在底部
            [self.contentView autoAlignAxisToSuperviewAxis:ALAxisVertical];
            [self.contentView autoPinEdgeToSuperviewEdge:ALEdgeBottom];
            [self.contentView autoSetDimension:ALDimensionWidth toSize:[self widthOfContentView]];
            [self.heightOfContentViewLayout autoRemove];
            [NSLayoutConstraint autoSetPriority:UILayoutPriorityDefaultLow forConstraints:^{
                self.heightOfContentViewLayout = [self.contentView autoSetDimension:ALDimensionHeight toSize:self.heightOfContentView relation:NSLayoutRelationGreaterThanOrEqual];
            }];
        }
    }
    
    self.heightOfContentViewLayout.constant = self.heightOfContentView;
    
    [super updateConstraints];
}

#pragma mark - SMRContentMaskViewProtocol

- (UIView *)contentViewOfMaskView {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor whiteColor];
    return view;
}

- (CGFloat)widthOfContentView {
    if (self.contentAlignment == SMRContentMaskViewContentAlignmentCenter) {
        return CGRectGetWidth([UIScreen mainScreen].bounds) - 2*[SMRUIAdapter value:30.0];
    }
    return CGRectGetWidth([UIScreen mainScreen].bounds);
}

- (SMRContentMaskViewContentAlignment)contentAlignmentOfMaskView {
    return self.contentAlignment;
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
    [self updateHeightOfContentView:heightOfContentView aniamted:NO];
}

- (void)updateHeightOfContentView:(CGFloat)heightOfContentView aniamted:(BOOL)animated {
    _heightOfContentView = heightOfContentView;
    
    // 仅当约束被执行过之后动画效果才有效
    if (animated && self.didLoadLayout) {
        [self setNeedsUpdateConstraints];
        [self updateConstraintsIfNeeded];
        [UIView animateWithDuration:0.35 animations:^{
            [self layoutIfNeeded];
        } completion:nil];
    } else {
        [self.heightOfContentViewLayout autoRemove];
        [NSLayoutConstraint autoSetPriority:UILayoutPriorityDefaultLow forConstraints:^{
            self.heightOfContentViewLayout = [self.contentView autoSetDimension:ALDimensionHeight toSize:self.heightOfContentView relation:NSLayoutRelationGreaterThanOrEqual];
        }];
        [self setNeedsUpdateConstraints];
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
    if (self.autoAdjustIfShowInMaskView && [view isKindOfClass:[SMRContentMaskView class]]) {
        // show的时候,需要隐藏back和content,hide的时候需要展示其父类的back和content
        self.superMaskView = (SMRContentMaskView *)view;
        // 保存原来的color
        self.superMaskViewBackColor = self.superMaskView.backgroundColor;
        self.superMaskViewContentHidden = self.superMaskView.contentView.hidden;
        self.superMaskView.backgroundColor = [UIColor clearColor];
        self.superMaskView.contentView.hidden = YES;
        self.alpha = 1;
    } else {
        self.alpha = 0;
    }
    [view addSubview:self];
    if (animated) {
        // show back
        [UIView animateWithDuration:self.animationDuration animations:^{
            self.alpha = 1;
        }];
        
        // show content
        SMRContentMaskViewContentAlignment alignment = [self contentAlignmentOfMaskView];
        if (alignment == SMRContentMaskViewContentAlignmentCenter) {
            
        } else {
            CGFloat offsetY = self.heightOfContentViewLayout.constant;
            self.contentView.transform = CGAffineTransformMakeTranslation(0, offsetY);
            [UIView animateWithDuration:self.animationDuration animations:^{
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
            [UIView animateWithDuration:self.animationDuration animations:^{
                self.alpha = 0;
            } completion:^(BOOL finished) {
                [self removeFromSuperview];
            }];
        } else {
            // hide content
            CGFloat offsetY = self.heightOfContentViewLayout.constant;
            [UIView animateWithDuration:self.animationDuration animations:^{
                self.contentView.transform = CGAffineTransformMakeTranslation(0, offsetY);
            }];
            
            // hide back
            [UIView animateWithDuration:self.animationDuration animations:^{
                self.alpha = 0;
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
