//
//  SMRContentMaskView.m
//  SMRBaseCoreDemo
//
//  Created by 丁治文 on 2019/2/13.
//  Copyright © 2019 sumrise. All rights reserved.
//

#import "SMRContentMaskView.h"
#import "SMRUIAdapter.h"
#import "PureLayout.h"

@interface SMRContentMaskView ()

@property (strong, nonatomic) NSLayoutConstraint *heightOfContentViewLayout;

@end

@implementation SMRContentMaskView

@synthesize didLoadLayout = _didLoadLayout;
@synthesize contentView = _contentView;

- (void)dealloc {
    NSLog(@"成功释放对象:<%@: %p>", [self class], &self);
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
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
    [self addSubview:self.contentView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundViewTapAction:)];
    [self addGestureRecognizer:tap];
    [self setNeedsUpdateConstraints];
}

- (void)updateConstraints {
    if (!self.didLoadLayout) {
        _didLoadLayout = YES;
        SMRContentMaskViewContentAlignment alignment = [self contentAlignmentOfMaskView];
        if (alignment == SMRContentMaskViewContentAlignmentCenter) {
            // 默认居中
            [self.contentView autoCenterInSuperview];
            [self.contentView autoSetDimension:ALDimensionWidth toSize:[self widthOfContentView]];
            [NSLayoutConstraint autoSetPriority:UILayoutPriorityDefaultLow forConstraints:^{
                self.heightOfContentViewLayout = [self.contentView autoSetDimension:ALDimensionHeight toSize:10 relation:NSLayoutRelationGreaterThanOrEqual];
            }];
        } else {
            // 在底部
            [self.contentView autoAlignAxisToSuperviewAxis:ALAxisVertical];
            [self.contentView autoPinEdgeToSuperviewEdge:ALEdgeBottom];
            [self.contentView autoSetDimension:ALDimensionWidth toSize:[self widthOfContentView]];
            [NSLayoutConstraint autoSetPriority:UILayoutPriorityDefaultLow forConstraints:^{
                self.heightOfContentViewLayout = [self.contentView autoSetDimension:ALDimensionHeight toSize:10 relation:NSLayoutRelationGreaterThanOrEqual];
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
    return CGRectGetWidth([UIScreen mainScreen].bounds) - 2*[SMRUIAdapter smr_adapterWithValue:43.0];
}

- (SMRContentMaskViewContentAlignment)contentAlignmentOfMaskView {
    return SMRContentMaskViewContentAlignmentCenter;
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

#pragma mark - Utils

- (void)updateHeightOfContentView:(CGFloat)heightOfContentView {
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
    [view addSubview:self];
    self.alpha = 0;
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 1;
    }];
}

- (void)hide {
    [self hideAnimated:YES];
}
- (void)hideAnimated:(BOOL)animated {
    if (animated) {
        [UIView animateWithDuration:0.25 animations:^{
            self.alpha = 0;
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    } else {
        [self removeFromSuperview];
    }
}

#pragma mark - Getters

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [self contentViewOfMaskView];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(contentViewTapAction:)];
        [_contentView addGestureRecognizer:tap];
    }
    return _contentView;
}

@end
