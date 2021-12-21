//
//  SMRLineLayout.h
//  SMRBaseCoreDemo
//
//  Created by Tinswin on 2020/3/19.
//  Copyright © 2020 sumrise. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SMRLineLayoutItem : NSObject

@property (assign, nonatomic) NSInteger index;  ///< 线性位置
@property (assign, nonatomic) CGPoint position; ///< 坐标位置, x表示row的index, y表示column的index
@property (assign, nonatomic) CGRect frame;

@end

@class SMRLineLayout;
typedef CGSize(^SMRLineLayoutItemSizeBlock)(SMRLineLayout *layout, NSInteger index);

@interface SMRLineLayout : NSObject

@property (assign, nonatomic) UIEdgeInsets contentInset;
@property (assign, nonatomic) CGSize maxSize;   ///< 默认maxfloat
@property (copy  , nonatomic) SMRLineLayoutItemSizeBlock itemBlock;
@property (assign, nonatomic) CGSize sep;
@property (assign, nonatomic) NSInteger numberOfLine;///< 默认0,无限制

- (void)clearCache;
- (void)clearCacheFromIndex:(NSInteger)fromIndex;

/// 超出行限制时,返回最后一个有效item
- (SMRLineLayoutItem *)itemWithLayoutIndex:(NSInteger)index;
/// 超出行限制时,返回nil
- (SMRLineLayoutItem *)effectiveItemWithLayoutIndex:(NSInteger)index;

- (void)layoutWithCount:(NSInteger)count process:(nullable void (^)(NSInteger index, SMRLineLayoutItem *item))process;
- (void)layoutToIndex:(NSInteger)index process:(nullable void (^)(NSInteger index, SMRLineLayoutItem *item))process;
- (void)layoutWithinRange:(NSRange)range process:(nullable void (^)(NSInteger, SMRLineLayoutItem *item))process;

@end

NS_ASSUME_NONNULL_END
