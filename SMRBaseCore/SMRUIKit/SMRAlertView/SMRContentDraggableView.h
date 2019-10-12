//
//  SMRContentDraggableView.h
//  SMRBaseCoreDemo
//
//  Created by Tinswin on 2019/10/12.
//  Copyright © 2019 ibaodashi. All rights reserved.
//

#import "SMRContentMaskView.h"

NS_ASSUME_NONNULL_BEGIN

@interface SMRContentMaskScrollView : UIScrollView<UIGestureRecognizerDelegate>

@end

@protocol SMRContentDraggableViewScrollDelegate <NSObject>

/// 为解决子视图上带scrollView时,需要实现的协议
- (CGPoint)subScrollViewContentOffset;

/// 滑动手指抬起时的回调
- (void)contentScrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate;

@end

@interface SMRContentDraggableView : SMRContentMaskView<
UIScrollViewDelegate,
SMRContentDraggableViewScrollDelegate>

/// 请使用此view作为父视图
@property (strong, nonatomic) SMRContentMaskScrollView *contentScrollView;

- (UIView *)contentView NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
