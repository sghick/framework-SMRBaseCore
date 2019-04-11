//
//  SMRSliderBarContentView.m
//  SMRBaseCoreDemo
//
//  Created by 丁治文 on 2019/3/18.
//  Copyright © 2019 sumrise. All rights reserved.
//

#import "SMRSliderBarContentView.h"
#import "SMRMatrixCalculator.h"
#import "SMRAdapter.h"
#import "PureLayout.h"

@interface SMRSliderBarContentView ()<
UIScrollViewDelegate>

@property (assign, nonatomic) BOOL didLoadLayout;
@property (assign, nonatomic) BOOL markNeedsAddSubviews;

@property (nonatomic, assign) NSInteger numbersOfCount;

@property (strong, nonatomic) NSMutableArray<UIView *> *contentSubviews;

@end

@implementation SMRSliderBarContentView
@synthesize scrollView = _scrollView;

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews {
    self.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self addSubview:self.scrollView];
    [self setNeedsUpdateConstraints];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (self.markNeedsAddSubviews) {
        self.markNeedsAddSubviews = NO;
        for (UIView *view in self.contentSubviews) {
            [view removeFromSuperview];
        }
        [self addSubviewsForContent];
    }
}

- (void)updateConstraints {
    if (!self.didLoadLayout) {
        self.didLoadLayout = YES;
        [self.scrollView autoPinEdgesToSuperviewEdges];
    }
    [super updateConstraints];
}

- (void)addSubviewsForContent {
    NSInteger count = [self.delegate numbersOfCountForSliderBarContentView:self];
    _numbersOfCount = count;
    self.scrollView.contentSize = CGSizeMake(count*CGRectGetWidth(self.scrollView.bounds),
                                             CGRectGetHeight(self.scrollView.bounds));
    CGRect bounds = CGRectMake(0, 0, self.scrollView.contentSize.width, self.scrollView.contentSize.height);
    SMRMatrixCalculator *calculator = [SMRMatrixCalculator calculatorForVerticalWithBounds:bounds
                                                                              columnsCount:count
                                                                                spaceOfRow:0
                                                                                  cellSize:self.scrollView.frame.size];
    
    for (int i = 0; i < count; i++) {
        UIView *view = [self.delegate sliderBarContentView:self subviewForIndex:i];
        if (!view) {
            continue;
        }
        view.frame = [calculator cellFrameWithIndex:i];
        [self.scrollView addSubview:view];
        [self.contentSubviews addObject:view];
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self prepareMoveTrackerFollowScrollView:scrollView];
}

- (void)prepareMoveTrackerFollowScrollView:(UIScrollView *)scrollView {
    // 当滑到边界时，继续通过scrollView的bouces效果滑动时，直接return
    if (scrollView.contentOffset.x < 0 ||
        (scrollView.contentOffset.x > scrollView.contentSize.width - scrollView.bounds.size.width)) {
        return;
    }
    // 当前偏移量
    CGFloat currentOffSetX = scrollView.contentOffset.x;
    CGFloat progress = currentOffSetX/scrollView.bounds.size.width;
    NSInteger pIndex = (NSInteger)progress;
    if (progress == pIndex) {
        if (_index != pIndex) {
            _index = pIndex;
            if ([self.delegate respondsToSelector:@selector(sliderBarContentView:didScrollToIndex:)]) {
                [self.delegate sliderBarContentView:self didScrollToIndex:self.index];
            }
        }
    }
}

#pragma mark - Utils

- (void)reloadView {
    self.markNeedsAddSubviews = YES;
    [self setNeedsLayout];
    [self setNeedsUpdateConstraints];
}

#pragma mark - Setters

- (void)scrollViewToIndex:(NSInteger)index animated:(BOOL)animated {
    [self layoutIfNeeded];
    [self.scrollView setContentOffset:CGPointMake(index*CGRectGetWidth(self.scrollView.frame), 0) animated:animated];
}

#pragma mark - Getters

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.delegate = self;
        _scrollView.pagingEnabled = YES;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
    }
    return _scrollView;
}

- (NSMutableArray<UIView *> *)contentSubviews {
    if (!_contentSubviews) {
        _contentSubviews = [NSMutableArray array];
    }
    return _contentSubviews;
}

@end
