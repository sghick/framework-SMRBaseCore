//
//  SMRCircleProgressBar.m
//  SMRBaseCoreDemo
//
//  Created by 丁治文 on 2019/7/8.
//  Copyright © 2019 sumrise. All rights reserved.
//

#import "SMRCircleProgressBar.h"

@interface SMRCircleProgressBar ()

/** 轨道线色 */
@property (strong, nonatomic) NSArray *strokeCGColors;
/** 轨道layer */
@property (strong, nonatomic) CAShapeLayer *railLayer;
/** 进度layer */
@property (strong, nonatomic) CAGradientLayer *strokeLayer;
/** 定时器 */
@property (nonatomic, strong) dispatch_source_t timer;

@end

@implementation SMRCircleProgressBar

- (instancetype)initWithFrame:(CGRect)frame startAngle:(CGFloat)startAngle reduceAngle:(CGFloat)reduceAngle {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        _startAngle = startAngle;
        _reduceAngle = reduceAngle;
        
        _strokeWidth = 10;
        _railWidth = 8;
        
        _animationDuration = 0.35;
    }
    return self;
}

- (void)createSublayers {
    if (self.railShow) {
        [self.layer addSublayer:self.railLayer];
    } else {
        if (_railLayer) {
            [self.railLayer removeFromSuperlayer];
        }
    }
    [self.layer addSublayer:self.strokeLayer];
}

#pragma mark - Utils

- (CAShapeLayer *)shapeLayerWithFrame:(CGRect)frame lineWidth:(CGFloat)lineWidth strokeColor:(UIColor *)strokeColor lineCapRound:(BOOL)lineCapRound center:(CGPoint)center radius:(CGFloat)radian startAngle:(CGFloat)startAngle reduceAngle:(CGFloat)reduceAngle {
    // 轨道
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.frame = frame;
    layer.fillColor = [UIColor clearColor].CGColor; // 只是一根线,不需要设置填充色
    layer.strokeColor = strokeColor.CGColor;
    layer.opacity = 1;
    layer.lineCap = lineCapRound ? kCALineCapRound : kCALineCapButt;
    layer.lineWidth = lineWidth;
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center
                                                        radius:radian
                                                    startAngle:startAngle
                                                      endAngle:startAngle + 2*M_PI - reduceAngle
                                                     clockwise:YES];
    layer.path = path.CGPath;
    return layer;
}

- (CAGradientLayer *)gradientLayerWithFrame:(CGRect)frame lineWidth:(CGFloat)lineWidth strokeColors:(NSArray *)strokeColors lineCapRound:(BOOL)lineCapRound center:(CGPoint)center radius:(CGFloat)radian startAngle:(CGFloat)startAngle reduceAngle:(CGFloat)reduceAngle {
    // 创建一个shapeLayer 类,因为要使用渐变色,因层底层layer的strokeColor只用设置一个不透明的任意颜色即可
    CAShapeLayer *arc = [self shapeLayerWithFrame:frame
                                        lineWidth:lineWidth
                                      strokeColor:[UIColor whiteColor]
                                     lineCapRound:lineCapRound
                                           center:center
                                           radius:radian
                                       startAngle:startAngle
                                      reduceAngle:reduceAngle];
    // 创建渐变层layer
    CAGradientLayer *layer = [CAGradientLayer layer];
    layer.frame = frame;
    layer.colors = strokeColors;
    layer.mask = arc;
    layer.startPoint = CGPointMake(0, 0.5);
    layer.endPoint = CGPointMake(1, 0.5);
    return layer;
}

- (void)countProgressWithDuration:(NSTimeInterval)duration maxProgress:(CGFloat)maxProgress progressBlock:(nullable void (^)(CGFloat pg))progressBlock {
    if (!progressBlock) {
        return;
    }
    __block CGFloat _progress = 0;
    dispatch_queue_t quene = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, quene);
    dispatch_source_set_timer(timer, dispatch_walltime(NULL, 0), NSEC_PER_SEC * (duration/(maxProgress*100)), 0);
    dispatch_source_set_event_handler(timer, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (_progress < maxProgress) {
                _progress = _progress + 0.01;
                if (progressBlock) {
                    progressBlock(_progress);
                }
            } else {
                if (progressBlock) {
                    progressBlock(maxProgress);
                }
                dispatch_source_cancel(timer);
            }
            
            
        });
    });
    dispatch_resume(timer);
    self.timer = timer;
}

#pragma mark - Setters

- (void)setStrokeColors:(NSArray<UIColor *> *)strokeColors {
    _strokeColors = strokeColors;
    
    NSMutableArray *colors = [NSMutableArray array];
    [strokeColors enumerateObjectsUsingBlock:^(UIColor * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [colors addObject:(__bridge id)obj.CGColor];
    }];
    _strokeCGColors = [colors copy];
}

- (void)setProgress:(CGFloat)progress {
    [self setProgress:progress animated:NO];
}

- (void)setProgress:(CGFloat)progress animated:(BOOL)animated {
    [self setProgress:progress animated:animated progressBlock:nil];
}

- (void)setProgress:(CGFloat)progress animated:(BOOL)animated progressBlock:(nullable void (^)(CGFloat pg))progressBlock {
    _progress = progress;
    // 重新设置layer层级
    [self createSublayers];
    // 执行动画
    if (animated) {
        // 给strokeLayer的shapeLayer层增加一个隐藏动画
        [self.strokeLayer.mask removeAnimationForKey:@"shapeLayerAnimation"];
        CABasicAnimation *pathAniamtion = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        pathAniamtion.duration = self.animationDuration;
        pathAniamtion.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        pathAniamtion.fromValue = @(0);
        pathAniamtion.toValue = @(progress);
        pathAniamtion.removedOnCompletion = NO;
        pathAniamtion.fillMode = kCAFillModeForwards;
        [self.strokeLayer.mask addAnimation:pathAniamtion forKey:@"shapeLayerAnimation"];
        
        // 回调进度
        [self countProgressWithDuration:self.animationDuration maxProgress:progress progressBlock:progressBlock];
    } else {
        // 直接更新进度
        [self.strokeLayer.mask setValue:@(progress) forKeyPath:@"strokeEnd"];
        if (progressBlock) {
            progressBlock(progress);
        }
    }
}

#pragma mark - Getters

- (CAShapeLayer *)railLayer {
    if (!_railLayer) {
        CGRect inBounds = self.bounds;
        CGFloat r = MAX(inBounds.size.width, inBounds.size.height)/2 - self.strokeWidth/2;
        CGPoint center = CGPointMake(r + self.strokeWidth/2, r + self.strokeWidth/2);
        // 轨道
        CAShapeLayer *layer = [self shapeLayerWithFrame:inBounds
                                              lineWidth:self.railWidth
                                            strokeColor:self.railColor
                                           lineCapRound:self.lineCapRound
                                                 center:center
                                                 radius:r
                                             startAngle:self.startAngle
                                            reduceAngle:self.reduceAngle];
        _railLayer = layer;
    }
    return _railLayer;
}

- (CAGradientLayer *)strokeLayer {
    if (!_strokeLayer) {
        CGRect inBounds = self.bounds;
        CGFloat r = MAX(inBounds.size.width, inBounds.size.height)/2 - self.strokeWidth/2;
        CGPoint center = CGPointMake(r + self.strokeWidth/2, r + self.strokeWidth/2);
        // 进度
        CAGradientLayer *layer = [self gradientLayerWithFrame:inBounds
                                                    lineWidth:self.strokeWidth
                                                 strokeColors:self.strokeCGColors
                                                 lineCapRound:self.lineCapRound
                                                       center:center
                                                       radius:r
                                                   startAngle:self.startAngle
                                                  reduceAngle:self.reduceAngle];
        _strokeLayer = layer;
    }
    return _strokeLayer;
}




@end
