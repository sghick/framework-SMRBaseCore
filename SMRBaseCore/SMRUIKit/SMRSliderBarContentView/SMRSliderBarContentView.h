//
//  SMRSliderBarContentView.h
//  SMRBaseCoreDemo
//
//  Created by 丁治文 on 2019/3/7.
//  Copyright © 2019 sumrise. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class SMRSliderBarContentView;
@protocol SMRSliderBarContentViewDelegate <NSObject>

@required
- (NSInteger)numbersOfCountForSliderBarContentView:(SMRSliderBarContentView *)contentView;
- (UIView *)sliderBarContentView:(SMRSliderBarContentView *)contentView subviewForIndex:(NSInteger)index;

@optional
- (void)sliderBarContentView:(SMRSliderBarContentView *)contentView didScrollToIndex:(NSInteger)index;

@end

@interface SMRSliderBarContentView : UIView

@property (strong, nonatomic, readonly) UIScrollView *scrollView;
@property (assign, nonatomic, readonly) NSInteger index;

@property (assign, nonatomic) BOOL sorption; ///< 中间卡片吸附效果,默认NO

@property (weak  , nonatomic) id<SMRSliderBarContentViewDelegate> delegate;

- (void)reloadView;
- (void)scrollViewToIndex:(NSInteger)index animated:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END
