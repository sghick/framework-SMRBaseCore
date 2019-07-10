//
//  SMRCircleProgressBar.h
//  SMRBaseCoreDemo
//
//  Created by 丁治文 on 2019/7/8.
//  Copyright © 2019 sumrise. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#define SMRCircleProgressToRadian(d) ((d)*M_PI)/180.0

@interface SMRCircleProgressBar : UIView

/** 进度[0,1] */
@property (assign, nonatomic) CGFloat progress;
/** 线宽,默认:10 */
@property (assign, nonatomic) CGFloat strokeWidth;
/** 线色,多个颜色为渐变色,必须为RGB颜色 */
@property (strong, nonatomic) NSArray<UIColor *> *strokeColors;

/** 是否显示轨道,默认NO */
@property (assign, nonatomic) BOOL railShow;
/** 轨道线宽,默认:8 */
@property (assign, nonatomic) CGFloat railWidth;
/** 轨道线色,多个颜色为渐变色,必须为RGB颜色 */
@property (strong, nonatomic) UIColor *railColor;

/** 线头是否为圆角,默认NO */
@property (assign, nonatomic) BOOL lineCapRound;
/** 动画的时长,默认0.35 */
@property (assign, nonatomic) NSTimeInterval animationDuration;

/** 起点弧度 */
@property (assign, nonatomic, readonly) CGFloat startAngle;
/** 丢弃弧度 */
@property (assign, nonatomic, readonly) CGFloat reduceAngle;

/** 初始化方法[推荐](圆的半径是以view的宽高中最长的值来确认的) */
- (instancetype)initWithFrame:(CGRect)frame startAngle:(CGFloat)startAngle reduceAngle:(CGFloat)reduceAngle;

/** 设置进度 */
- (void)setProgress:(CGFloat)progress animated:(BOOL)animated;
- (void)setProgress:(CGFloat)progress animated:(BOOL)animated progressBlock:(nullable void (^)(CGFloat pg))progressBlock;

@end

NS_ASSUME_NONNULL_END
