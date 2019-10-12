//
//  SMRContentDraggableView.m
//  SMRBaseCoreDemo
//
//  Created by Tinswin on 2019/10/12.
//  Copyright © 2019 ibaodashi. All rights reserved.
//

#import "SMRContentDraggableView.h"

@implementation SMRContentMaskScrollView

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

@end

@implementation SMRContentDraggableView

- (UIView *)contentViewOfMaskView {
    UIView *cview = [super contentViewOfMaskView];
    cview.backgroundColor = [UIColor clearColor];
    [cview addSubview:self.contentScrollView];
    return cview;
}

- (void)updateHeightOfContentView:(CGFloat)heightOfContentView aniamted:(BOOL)animated {
    self.contentScrollView.frame = CGRectMake(0, 0, [self widthOfContentView], heightOfContentView);
    self.contentScrollView.contentSize = CGSizeMake([self widthOfContentView], heightOfContentView + 0.5);
    [super updateHeightOfContentView:heightOfContentView aniamted:animated];
}

#pragma mark - SMRContentDraggableViewScrollDelegate

- (CGPoint)subScrollViewContentOffset {
    return CGPointZero;
}

- (void)contentScrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (scrollView.contentOffset.y < -70) {
        [self hide];
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.contentScrollView == scrollView) {
        CGPoint offset = scrollView.contentOffset;
        if (offset.y > 0) {
            offset.y = 0;
        } else {
            if ([self subScrollViewContentOffset].y > 0) {
                offset.y = 0;
            }
        }
        scrollView.contentOffset = offset;
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (self.contentScrollView == scrollView) {
        [self contentScrollViewDidEndDragging:scrollView willDecelerate:decelerate];
    }
}

#pragma mark - Getters

- (SMRContentMaskScrollView *)contentScrollView {
    if (!_contentScrollView) {
        _contentScrollView = [[SMRContentMaskScrollView alloc] init];
        _contentScrollView.delegate = self;
    }
    return _contentScrollView;
}

@end
