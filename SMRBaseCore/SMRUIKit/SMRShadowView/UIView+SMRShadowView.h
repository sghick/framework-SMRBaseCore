//
//  UIView+SMRShadowView.h
//  SMRBaseCoreDemo
//
//  Created by Tinswin on 2020/6/10.
//  Copyright © 2020 sumrise. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SMRShadowItem : NSObject

@property (strong, nonatomic) UIColor *shadowColor;     ///< 颜色
@property (assign, nonatomic) CGFloat shadowOpacity;    ///< 透明度
@property (assign, nonatomic) CGSize shadowOffset;      ///< 偏移量
@property (assign, nonatomic) CGFloat cornerRadius;     ///< 圆角
@property (assign, nonatomic) CGFloat shadowRadius;     ///< 模糊计算的半径

@end

@interface UIView (SMRShadowView)

- (void)setShadowWithItem:(SMRShadowItem *)shadowItem;
/** 如果path是视图大小而定的, 建议在layoutSubviews方法中使用 */
- (void)setShadowWithItem:(SMRShadowItem *)shadowItem shadowPath:(nullable CGPathRef)shadowPath;

@end

NS_ASSUME_NONNULL_END
