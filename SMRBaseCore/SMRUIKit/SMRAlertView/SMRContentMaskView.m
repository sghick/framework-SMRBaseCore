//
//  SMRContentMaskView.m
//  SMRBaseCoreDemo
//
//  Created by 丁治文 on 2019/2/13.
//  Copyright © 2019 sumrise. All rights reserved.
//

#import "SMRContentMaskView.h"
#import "PureLayout.h"

@interface SMRContentMaskView ()

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
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews {
    
    [self setNeedsUpdateConstraints];
}

- (void)updateConstraints {
    if (!self.didLoadLayout) {
        _didLoadLayout = YES;
        
    }
    [super updateConstraints];
}

#pragma mark - SMRContentMaskViewProtocol

- (UIView *)contentViewOfMaskView {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor whiteColor];
    return view;
}

- (CGFloat)marginOfContentView {
    return 30;
}

#pragma mark - Utils

- (void)show {
    [self showAnimated:YES];
}
- (void)showAnimated:(BOOL)animated {
    
}

- (void)hide {
    [self hideAnimated:YES];
}
- (void)hideAnimated:(BOOL)animated {
    
}

#pragma mark - Getters

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [self contentViewOfMaskView];
    }
    return _contentView;
}

@end
