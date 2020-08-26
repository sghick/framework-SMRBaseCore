//
//  SMRPageControl.h
//  SMRBaseCoreDemo
//
//  Created by Tinswin on 2019/11/18.
//  Copyright © 2019 sumrise. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SMRPageControl : UIControl

@property (assign, nonatomic) NSInteger numberOfPages;   // default is 0
@property (assign, nonatomic) NSInteger currentPage;     // default is 0. value pinned to 0..numberOfPages-1
@property (assign, nonatomic) BOOL hidesForSinglePage;   // hide the the indicator if there is only one page. default is NO
@property (assign, nonatomic) BOOL defersCurrentPageDisplay;

- (void)updateCurrentPageDisplay;
- (CGSize)sizeForNumberOfPages:(NSInteger)pageCount;

/// indicatorTint color
@property (strong, nonatomic, nullable) UIColor *pageIndicatorTintColor;
@property (strong, nonatomic, nullable) UIColor *currentPageIndicatorTintColor;

/// indicator image
@property (strong, nonatomic, nullable) UIImage *pageIndicatorImage;
@property (strong, nonatomic, nullable) UIImage *currentPageIndicatorImage;

@property (nonatomic, assign) CGFloat pageIndicatorSpaing;
@property (nonatomic, assign) CGSize pageIndicatorSize;         // indicator size
@property (nonatomic, assign) CGSize currentPageIndicatorSize;  // default pageIndicatorSize
@property (nonatomic, assign) CGFloat animateDuring;            // default 0.35

@property (nonatomic, assign) UIViewContentMode indicatorImageContentMode;  // default is UIViewContentModeCenter
@property (nonatomic, assign) UIEdgeInsets contentInset;    // center will ignore this

- (void)setCurrentPage:(NSInteger)currentPage animated:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END
