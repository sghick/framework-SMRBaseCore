//
//  SMRNavigationBar.h
//  SMRBaseCoreDemo
//
//  Created by 丁治文 on 2019/1/21.
//  Copyright © 2019 sumrise. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMRNavigationItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface SMRNavigationBar : UIView

/**
 *  图片背景,默认无图片
 */
@property (nonatomic, strong, readonly) UIImageView *backgroundImageView;

/**
 *  容器,所有自定义的控件都应该加在contentView上
 */
@property (nonatomic, strong, readonly) UIView *contentView;

/**
 *  下边线
 */
@property (nonatomic, strong, readonly) UIView *splitLine;

/**
 *  判断是否为已经加载过一次约束
 */
@property (nonatomic, assign, readonly) BOOL didLoadLayouts;

/**
 *  底部位置
 */
@property (nonatomic, assign, readonly) CGFloat bottom;

/**
 *  控制管理nav的对象
 */
+ (SMRNavigationItem *)navigationItem;

/**
 *  初始化方法(推荐方法)
 */
- (instancetype)init;
- (instancetype)initWithFrame:(CGRect)frame __deprecated_msg("Method deprecated. Use `init:`");

/**
 *  (推荐)使用添加视图的方法
 */
- (void)addSubviews:(NSArray *)subviews tag:(NSString *)tag;

/**
 *  (推荐)在这个block中添加约束的方法
 */
- (void)addLayoutConstraints:(void(^)(void))constraints tag:(NSString *)tag;

/**
 *  将移除在子类使用-[addSubviews:tag:]方法的subviews
 *          和使用-[addLayoutConstraints:tag:]方法的constraints
 *
 */
- (void)removeSubviewsWithTag:(NSString *)tag;

@end

NS_ASSUME_NONNULL_END
