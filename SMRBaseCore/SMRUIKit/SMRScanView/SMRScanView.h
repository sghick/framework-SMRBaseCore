//
//  SMRScanView.h
//  Gucci
//
//  Created by Tinswin on 2020/1/8.
//  Copyright © 2020 sumrise. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, SMRScanViewImageCornerStyle) {
    SMRScanViewImageCornerStyleInner,   // 4个角内嵌
    SMRScanViewImageCornerStyleOuter,   // 4个角外嵌
    SMRScanViewImageCornerStyleOn       // 4个角覆盖
};

typedef NS_ENUM(NSInteger, SMRScanViewAnimationStyle) {
    SMRScanViewAnimationStyleLineMove,   // 线条上下移动
    SMRScanViewAnimationStyleNetGrid,    // 网格
    SMRScanViewAnimationStyleLineStill,  // 线条停止在扫码区域中央
    SMRScanViewAnimationStyleCustom,     // 自定义动画
    SMRScanViewAnimationStyleNone        // 无动画
};

@class SMRScanAnimation;
@interface SMRScanViewStyle : NSObject

/** 创建一个默认的Style */
+ (instancetype)defaultStyle;

#pragma mark - ViewStyle

/** 非设别区域的颜色,必须是RGB颜色 */
@property (nonatomic, strong) UIColor *colorOfOtherArea;

/** 是否需要绘制扫码矩形框，默认YES */
@property (nonatomic, assign) BOOL shouldShowBorder;

/** 矩形框线条颜色 */
@property (nonatomic, strong) UIColor *colorOfBorder;

/** 矩形框宽高比,默认1 */
@property (nonatomic, assign) CGFloat whRatio;

/** 矩形框与scanView中心y轴的偏移 */
@property (nonatomic, assign) CGFloat offsetOfCenterY;

/** 矩形框左边及右边距离，默认60 */
@property (nonatomic, assign) CGFloat margin;

/** 矩形框的4个角类型 */
@property (nonatomic, assign) SMRScanViewImageCornerStyle imageCornerStyle;

/** 4个角的颜色 */
@property (nonatomic, strong) UIColor *colorOfCorner;

/** 4个角的尺寸 */
@property (nonatomic, assign) CGSize sizeOfCorner;

/** 4个角的线条宽度,默认6 */
@property (nonatomic, assign) CGFloat widthOfCornerLine;

#pragma mark - Animations

/** 动画效果 */
@property (nonatomic, assign) SMRScanViewAnimationStyle animationStyle;

/** 执行动画效果的图像，如线条或网格的图像，如果为nil，表示不需要动画效果 */
@property (nonatomic, strong, nullable) UIImage *animationImage;


@end

@interface SMRScanView : UIView

/* 线条扫码动画,默认nil,使用viewStyle动画 */
@property (nonatomic, strong, nullable) SMRScanAnimation *animations;

/* 样式 */
@property (nonatomic, strong, readonly) SMRScanViewStyle *viewStyle;

- (instancetype)initWithFrame:(CGRect)frame style:(SMRScanViewStyle *)style;

/** 设备启动中文字提示 */
- (void)startDeviceReadyingWithText:(nullable NSString *)text;

/** 设备启动完成 */
- (void)stopDeviceReadying;

/** 开始扫描动画 */
- (void)startScanAnimation;

/** 结束扫描动画 */
- (void)stopScanAnimation;

/** 获取矩形框在view中的frame */
+ (CGRect)getScanRectWithPreView:(UIView *)view style:(SMRScanViewStyle *)style;

@end

NS_ASSUME_NONNULL_END
