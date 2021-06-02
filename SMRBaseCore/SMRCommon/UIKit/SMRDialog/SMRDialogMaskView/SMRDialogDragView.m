//
//  SMRDialogDragView.m
//  Hermes
//
//  Created by Tinswin on 2021/3/26.
//  Copyright © 2021 isumrise. All rights reserved.
//

#import "SMRDialogDragView.h"

/**
 ******************************************
 * SMRDialogScrollView
 ******************************************
 */

@interface SMRDialogScrollView : UIScrollView<UIGestureRecognizerDelegate>

@end

@class SMRDialogDragContentView;
@protocol SMRDialogDragContentViewDelegate <NSObject>

@optional
/** 如果有其它scrollView需要响应,请在此方法返回其offset */
- (CGPoint)subScrollViewContentOffset;
/** 触发DragDown */
- (void)dialogDragDownResponse:(SMRDialogDragContentView *)view;

@end

@interface SMRDialogDragContentView : SMRDialogScrollView

@property (weak  , nonatomic) id<SMRDialogDragContentViewDelegate> dragDelegate;

/// 下拉触发距离,默认70
@property (assign, nonatomic) CGFloat dragDownOffset;

#pragma mark - 请在代理中实现这2个方法

- (void)c_scrollViewDidScroll:(UIScrollView *)scrollView;
- (void)c_scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate;

@end

@implementation SMRDialogScrollView

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

@end

@implementation SMRDialogDragContentView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _dragDownOffset = 70;
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.contentSize = CGSizeMake(CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds) + 0.5);
}

#pragma mark - UIScrollViewDelegate

- (void)c_scrollViewDidScroll:(UIScrollView *)scrollView {
    CGPoint offset = scrollView.contentOffset;
    if (offset.y > 0) {
        offset.y = 0;
    } else {
        CGPoint cf = CGPointZero;
        if ([self.dragDelegate respondsToSelector:@selector(subScrollViewContentOffset)]) {
            cf = [self.dragDelegate subScrollViewContentOffset];
        }
        if (cf.y > 0) {
            offset.y = 0;
        }
    }
    scrollView.contentOffset = offset;
}

- (void)c_scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (scrollView.contentOffset.y < -self.dragDownOffset) {
        if ([self.dragDelegate respondsToSelector:@selector(dialogDragDownResponse:)]) {
            [self.dragDelegate dialogDragDownResponse:self];
        }
    }
}

@end


/**
 ******************************************
 * SMRDialogDragView
 ******************************************
 */

@interface SMRDialogDragView ()<
UIScrollViewDelegate,
SMRDialogDragContentViewDelegate>

@property (strong, nonatomic) UIView *dragContentView;

@end

@implementation SMRDialogDragView

#pragma mark - Override

- (void)setContentViewSize:(CGSize)size animated:(BOOL)animated {
    [super setContentViewSize:size animated:animated];
    self.dragContentView.frame = CGRectMake(0, 0, size.width, size.height);
}

#pragma mark - SMRDialogMaskViewProtocol

- (UIView *)contentViewOfMaskView {
    SMRDialogDragContentView *cview = [[SMRDialogDragContentView alloc] init];
    cview.delegate = self;
    cview.dragDelegate = self;
    [cview addSubview:self.dragContentView];
    return cview;
}

#pragma mark - SMRDialogDragContentViewDelegate

- (void)dialogDragDownResponse:(SMRDialogDragContentView *)view {
    [self hide];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    SMRDialogDragContentView *view = (SMRDialogDragContentView *)scrollView;
    [view c_scrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    SMRDialogDragContentView *view = (SMRDialogDragContentView *)scrollView;
    [view c_scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
}

#pragma mark - Getters

- (UIView *)contentView {
    return self.dragContentView;
}

- (UIView *)dragContentView {
    if (!_dragContentView) {
        _dragContentView = [[UIView alloc] init];
        _dragContentView.backgroundColor = [UIColor whiteColor];
    }
    return _dragContentView;
}

@end
