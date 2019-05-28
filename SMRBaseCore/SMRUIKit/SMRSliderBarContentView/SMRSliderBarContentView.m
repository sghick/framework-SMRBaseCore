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
@property (strong, nonatomic) SMRMatrixCalculator *calculator;

@property (assign, nonatomic) NSInteger numbersOfCount;

@property (strong, nonatomic) NSMutableArray<UIView *> *contentSubviews;

@property (weak  , nonatomic) UIView *bottomView;
@property (assign, nonatomic) CGFloat lastProgress;
@property (assign, nonatomic) NSInteger lastDirect;         ///< 手指抬起前最初的滑动方向
@property (assign, nonatomic) NSInteger lastRealTimeDirect; ///< 实时的滑动方向

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
    self.calculator = [SMRMatrixCalculator calculatorForVerticalWithBounds:bounds
                                                              columnsCount:count
                                                                spaceOfRow:0
                                                                  cellSize:self.scrollView.frame.size];
    
    for (int i = 0; i < count; i++) {
        UIView *view = [self.delegate sliderBarContentView:self subviewForIndex:i];
        if (!view) {
            continue;
        }
        view.frame = [self.calculator cellFrameWithIndex:i];
        [self.scrollView addSubview:view];
        [self.contentSubviews addObject:view];
    }
    
    _index = -1;
    _lastProgress = -1;
    [self prepareMoveTrackerFollowScrollView:self.scrollView];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self prepareMoveTrackerFollowScrollView:scrollView];
}

#pragma mark - Utils

- (void)reloadView {
    self.markNeedsAddSubviews = YES;
    [self setNeedsLayout];
    [self setNeedsUpdateConstraints];
}

- (void)prepareMoveTrackerFollowScrollView:(UIScrollView *)scrollView {
    // 当滑到边界时，继续通过scrollView的bouces效果滑动时，直接return
    //    if (scrollView.contentOffset.x < 0 ||
    //        (scrollView.contentOffset.x > scrollView.contentSize.width - scrollView.bounds.size.width)) {
    //        return;
    //    }
    // 当前偏移量
    CGFloat currentOffSetX = scrollView.contentOffset.x;
    CGFloat progress = currentOffSetX/scrollView.bounds.size.width;
    NSInteger pLastIndex = (NSInteger)self.lastProgress;
    NSInteger pIndex = (NSInteger)progress;
    // 实时的滑动方向
    self.lastRealTimeDirect = (self.lastProgress > progress) ? 1 : -1;
    // 计算是否完全加载出一个index
    BOOL didScrollToAnIndex = (progress == pIndex);
    if (self.lastRealTimeDirect > 0) {
        // 右滑
        //        didScrollToAnIndex = didScrollToAnIndex || (pLastIndex != pIndex);
    } else {
        // 左滑
        didScrollToAnIndex = didScrollToAnIndex || (pLastIndex != pIndex);
    }
    
    if (didScrollToAnIndex) {
        // 初始化当次滑动开始时方向记录
        self.lastDirect = 0;
        if (_index != pIndex) {
            if (self.sorption) {
                // 恢复上一图
                self.bottomView.frame = [self.calculator cellFrameWithIndex:self.index];
                [self.scrollView addSubview:self.bottomView];
                // 吸底
                self.bottomView = self.contentSubviews[pIndex];
                self.bottomView.frame = CGRectMake(0, 0, CGRectGetWidth(self.bottomView.frame), CGRectGetHeight(self.bottomView.frame));
                [self insertSubview:self.bottomView atIndex:0];
            }
            _index = pIndex;
            if ([self.delegate respondsToSelector:@selector(sliderBarContentView:didScrollToIndex:)]) {
                [self.delegate sliderBarContentView:self didScrollToIndex:self.index];
            }
        }
    } else {
        // 当次滑动的方向记录
        if (self.lastDirect == 0) {
            self.lastDirect = (self.lastProgress > progress) ? 1 : -1;
        }
        // 抖动
        if (self.sorption) {
            CGFloat relativeProgress = progress - (NSInteger)progress;
            CGFloat relativeMuti = 0.5;
            CGFloat relativeTransX = 0;
            if (self.lastDirect > 0) {
                // 初始往右
                relativeTransX = -1*(relativeProgress - 1)*CGRectGetWidth(self.bottomView.frame)*relativeMuti;
            } else if (self.lastDirect < 0) {
                // 初始往左
                relativeTransX = -1*relativeProgress*CGRectGetWidth(self.bottomView.frame)*relativeMuti;
            } else {
                // None
            }
            self.bottomView.left = relativeTransX;
        }
    }
    self.lastProgress = progress;
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
