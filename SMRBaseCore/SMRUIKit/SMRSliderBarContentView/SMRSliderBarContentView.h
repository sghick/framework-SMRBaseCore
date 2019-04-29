//
//  SMRSliderBarContentView.h
//  SMRBaseCoreDemo
//
//  Created by 丁治文 on 2019/3/18.
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

@property (weak  , nonatomic) id<SMRSliderBarContentViewDelegate> delegate;
@property (assign, nonatomic, readonly) NSInteger index;

- (void)reloadView;
- (void)scrollViewToIndex:(NSInteger)index animated:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END
