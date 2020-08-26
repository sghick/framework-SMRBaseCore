//
//  SMRScanView.m
//  Gucci
//
//  Created by Tinswin on 2020/1/8.
//  Copyright © 2020 sumrise. All rights reserved.
//

#import "SMRScanView.h"
#import "SMRAdapter.h"
#import "SMRUIKitBundle.h"
#import "SMRScanLineAnimation.h"
#import "SMRScanNetAnimation.h"

@implementation SMRScanViewStyle

- (instancetype)init {
    self = [super init];
    if (self) {
        self.shouldShowBorder = YES;
        self.whRatio = 1.0;
        self.colorOfBorder = [UIColor whiteColor];
        self.offsetOfCenterY = 44;
        self.margin = 60;
        self.animationStyle = SMRScanViewAnimationStyleLineMove;
        self.imageCornerStyle = SMRScanViewImageCornerStyleOuter;
        self.colorOfCorner = [UIColor colorWithRed:0. green:167./255. blue:231./255. alpha:1.0];
        self.colorOfOtherArea = [UIColor colorWithRed:0. green:.0 blue:.0 alpha:.5];
        self.sizeOfCorner = CGSizeMake(12, 12);
        self.widthOfCornerLine = 4;
    }
    return self;
}

+ (instancetype)defaultStyle {
    SMRScanViewStyle *style = [[SMRScanViewStyle alloc] init];
    style.imageCornerStyle = SMRScanViewImageCornerStyleInner;
    style.colorOfCorner = [UIColor smr_colorWithHexRGB:@"#FFCE38"];
    style.colorOfBorder = [UIColor smr_colorWithHexRGB:@"#FFCE38"];
    style.margin = [SMRUIAdapter value:40.0];
    style.animationStyle = SMRScanViewAnimationStyleLineMove;
    style.animationImage = [SMRUIKitBundle imageNamed:@"photo_scan_line@3x"];
    style.colorOfOtherArea = [[UIColor smr_blackColor] smr_colorWithAlphaComponent:0.5];
    return style;
}

@end

@interface SMRScanView ()

// 扫码区域
@property (nonatomic, assign) CGRect scanRetangleRect;
// 线条在中间位置，不移动
@property (nonatomic, strong, nullable) UIImageView *scanLineStill;
// 启动相机时,菊花等待
@property (nonatomic, strong, nullable) UIActivityIndicatorView *activityView;
// 启动相机中的提示文字
@property (nonatomic, strong, nullable) UILabel *labelReadying;

@end

@implementation SMRScanView

- (instancetype)initWithFrame:(CGRect)frame style:(nonnull SMRScanViewStyle *)style {
    if (self = [super initWithFrame:frame]) {
        _viewStyle = style;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    [self drawScanRect];
}

- (void)startDeviceReadyingWithText:(NSString*)text {
    int XRetangleLeft = _viewStyle.margin;
    CGSize sizeRetangle = CGSizeMake(self.frame.size.width - XRetangleLeft*2, self.frame.size.width - XRetangleLeft*2);
    
    if (!_viewStyle.shouldShowBorder) {
        CGFloat w = sizeRetangle.width;
        CGFloat h = (NSInteger)(w/_viewStyle.whRatio);
        sizeRetangle = CGSizeMake(w, h);
    }
    
    // Y轴坐标
    CGFloat YMinRetangle = self.frame.size.height/2.0 - sizeRetangle.height/2.0 - _viewStyle.offsetOfCenterY;
    
    //设备启动状态提示
    if (!_activityView) {
        self.activityView = [[UIActivityIndicatorView alloc] init];
        [_activityView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
      
        self.labelReadying = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, sizeRetangle.width, 30)];
        _labelReadying.backgroundColor = [UIColor clearColor];
        _labelReadying.textColor  = [UIColor whiteColor];
        _labelReadying.font = [UIFont systemFontOfSize:18.];
        _labelReadying.text = text;
        [_labelReadying sizeToFit];
        CGRect frame = _labelReadying.frame;
        CGPoint centerPt = CGPointMake(self.frame.size.width/2 + 20, YMinRetangle + sizeRetangle.height/2);
        _labelReadying.bounds = CGRectMake(0, 0, frame.size.width,30);
        _labelReadying.center = centerPt;
        
        _activityView.bounds = CGRectMake(0, 0, 30, 30);
        if (text)
            _activityView.center = CGPointMake(centerPt.x - frame.size.width/2 - 24 , _labelReadying.center.y);
        else
            _activityView.center = CGPointMake(self.frame.size.width/2 , _labelReadying.center.y);
        
        [self addSubview:_activityView];
        [self addSubview:_labelReadying];
        [_activityView startAnimating];
    }
}

- (void)stopDeviceReadying {
    if (_activityView) {
        [_activityView stopAnimating];
        [_activityView removeFromSuperview];
        [_labelReadying removeFromSuperview];
        
        self.activityView = nil;
        self.labelReadying = nil;
    }
}

- (void)startScanAnimation {
    switch (_viewStyle.animationStyle) {
        case SMRScanViewAnimationStyleLineMove: {
            // 线条动画
            if (!_animations) {
                _animations = [[SMRScanLineAnimation alloc] init];
            }
            [_animations startAnimatingWithRect:_scanRetangleRect
                                         inView:self
                                          image:_viewStyle.animationImage];
        }
            break;
        case SMRScanViewAnimationStyleNetGrid: {
            // 网格动画
            if (!_animations) {
                _animations = [[SMRScanNetAnimation alloc] init];
            }
            [_animations startAnimatingWithRect:_scanRetangleRect
                                         inView:self
                                          image:_viewStyle.animationImage];
        }
            break;
        case SMRScanViewAnimationStyleCustom: {
            // 网格动画
            if (_animations) {
               [_animations startAnimatingWithRect:_scanRetangleRect
                                            inView:self
                                             image:_viewStyle.animationImage];
            }
        }
            break;
        case SMRScanViewAnimationStyleLineStill: {
            if (!_scanLineStill) {
                CGRect stillRect = CGRectMake(_scanRetangleRect.origin.x+20,
                                              _scanRetangleRect.origin.y + _scanRetangleRect.size.height/2,
                                              _scanRetangleRect.size.width-40,
                                              2);
                _scanLineStill = [[UIImageView alloc]initWithFrame:stillRect];
                _scanLineStill.image = _viewStyle.animationImage;
            }
            [self addSubview:_scanLineStill];
        }
        default:
            break;
    }
}

- (void)stopScanAnimation {
    if (_animations) {
        [_animations stopAnimating];
    }
    if (_scanLineStill) {
        [_scanLineStill removeFromSuperview];
    }
}

- (void)drawScanRect {
    int XRetangleLeft = _viewStyle.margin;
    CGSize sizeRetangle = CGSizeMake(self.frame.size.width - XRetangleLeft*2, self.frame.size.width - XRetangleLeft*2);

    if (_viewStyle.whRatio != 1) {
        CGFloat w = sizeRetangle.width;
        CGFloat h = (NSInteger)(w/_viewStyle.whRatio);
        sizeRetangle = CGSizeMake(w, h);
    }

    // Y轴坐标
    CGFloat YMinRetangle = self.frame.size.height / 2.0 - sizeRetangle.height/2.0 - _viewStyle.offsetOfCenterY;
    CGFloat YMaxRetangle = YMinRetangle + sizeRetangle.height;
    CGFloat XRetangleRight = self.frame.size.width - XRetangleLeft;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    // 非扫码区域半透明
    {
        // 设置非识别区域颜色
        const CGFloat *components = CGColorGetComponents(_viewStyle.colorOfOtherArea.CGColor);
        CGFloat red_notRecoginitonArea = components[0];
        CGFloat green_notRecoginitonArea = components[1];
        CGFloat blue_notRecoginitonArea = components[2];
        CGFloat alpa_notRecoginitonArea = components[3];
        CGContextSetRGBFillColor(context,
                                 red_notRecoginitonArea,
                                 green_notRecoginitonArea,
                                 blue_notRecoginitonArea,
                                 alpa_notRecoginitonArea);
        
        //填充矩形
        //扫码区域上面填充
        CGRect rect = CGRectMake(0, 0, self.frame.size.width, YMinRetangle);
        CGContextFillRect(context, rect);
        
        //扫码区域左边填充
        rect = CGRectMake(0, YMinRetangle, XRetangleLeft,sizeRetangle.height);
        CGContextFillRect(context, rect);
        
        //扫码区域右边填充
        rect = CGRectMake(XRetangleRight, YMinRetangle, XRetangleLeft,sizeRetangle.height);
        CGContextFillRect(context, rect);
        
        //扫码区域下面填充
        rect = CGRectMake(0, YMaxRetangle, self.frame.size.width,self.frame.size.height - YMaxRetangle);
        CGContextFillRect(context, rect);
        //执行绘画
        CGContextStrokePath(context);
    }
    
    if (_viewStyle.shouldShowBorder) {
        //中间画矩形(正方形)
        CGContextSetStrokeColorWithColor(context, _viewStyle.colorOfCorner.CGColor);
        CGContextSetLineWidth(context, 1);
        CGContextAddRect(context, CGRectMake(XRetangleLeft, YMinRetangle, sizeRetangle.width, sizeRetangle.height));
        CGContextStrokePath(context);
    }
     _scanRetangleRect = CGRectMake(XRetangleLeft, YMinRetangle, sizeRetangle.width, sizeRetangle.height);

    // 画矩形框4格外围相框角
    //相框角的宽度和高度
    int wAngle = _viewStyle.sizeOfCorner.width;
    int hAngle = _viewStyle.sizeOfCorner.height;
    
    //4个角的 线的宽度
    CGFloat linewidthAngle = _viewStyle.widthOfCornerLine;
    
    //画扫码矩形以及周边半透明黑色坐标参数
    CGFloat diffAngle = 0.0f;
    //diffAngle = linewidthAngle/2; //框外面4个角，与框有缝隙
    //diffAngle = linewidthAngle/2;  //框4个角 在线上加4个角效果
    //diffAngle = 0;//与矩形框重合
    
    switch (_viewStyle.imageCornerStyle) {
        case SMRScanViewImageCornerStyleOuter: {
            //框外面4个角，与框紧密联系在一起
            diffAngle = linewidthAngle/3;
        }
            break;
        case SMRScanViewImageCornerStyleOn: {
            diffAngle = 0;
        }
            break;
        case SMRScanViewImageCornerStyleInner: {
            diffAngle = -_viewStyle.widthOfCornerLine/2;
        }
            break;
            
        default: {
            diffAngle = linewidthAngle/3;
        }
            break;
    }
    
    CGContextSetStrokeColorWithColor(context, _viewStyle.colorOfCorner.CGColor);
    CGContextSetRGBFillColor(context, 1.0, 1.0, 1.0, 1.0);
    
    // Draw them with a 2.0 stroke width so they are a bit more visible.
    CGContextSetLineWidth(context, linewidthAngle);
    
    //
    CGFloat leftX = XRetangleLeft - diffAngle;
    CGFloat topY = YMinRetangle - diffAngle;
    CGFloat rightX = XRetangleRight + diffAngle;
    CGFloat bottomY = YMaxRetangle + diffAngle;
    
    //左上角水平线
    CGContextMoveToPoint(context, leftX-linewidthAngle/2, topY);
    CGContextAddLineToPoint(context, leftX + wAngle, topY);
    
    //左上角垂直线
    CGContextMoveToPoint(context, leftX, topY-linewidthAngle/2);
    CGContextAddLineToPoint(context, leftX, topY+hAngle);
    
    
    //左下角水平线
    CGContextMoveToPoint(context, leftX-linewidthAngle/2, bottomY);
    CGContextAddLineToPoint(context, leftX + wAngle, bottomY);
    
    //左下角垂直线
    CGContextMoveToPoint(context, leftX, bottomY+linewidthAngle/2);
    CGContextAddLineToPoint(context, leftX, bottomY - hAngle);
    
    
    //右上角水平线
    CGContextMoveToPoint(context, rightX+linewidthAngle/2, topY);
    CGContextAddLineToPoint(context, rightX - wAngle, topY);
    
    //右上角垂直线
    CGContextMoveToPoint(context, rightX, topY-linewidthAngle/2);
    CGContextAddLineToPoint(context, rightX, topY + hAngle);
    
    
    //右下角水平线
    CGContextMoveToPoint(context, rightX+linewidthAngle/2, bottomY);
    CGContextAddLineToPoint(context, rightX - wAngle, bottomY);
    
    //右下角垂直线
    CGContextMoveToPoint(context, rightX, bottomY+linewidthAngle/2);
    CGContextAddLineToPoint(context, rightX, bottomY - hAngle);
    
    CGContextStrokePath(context);
}

//根据矩形区域，获取识别区域
+ (CGRect)getScanRectWithPreView:(UIView *)view style:(SMRScanViewStyle *)style {
    int XRetangleLeft = style.margin;
    CGSize sizeRetangle = CGSizeMake(view.frame.size.width - XRetangleLeft*2, view.frame.size.width - XRetangleLeft*2);
    
    if (style.whRatio != 1) {
        CGFloat w = sizeRetangle.width;
        CGFloat h = (NSInteger)(w/style.whRatio);
        sizeRetangle = CGSizeMake(w, h);
    }
    
    // 扫码区域Y轴最小坐标
    CGFloat YMinRetangle = view.frame.size.height / 2.0 - sizeRetangle.height/2.0 - style.offsetOfCenterY;
    
    //扫码区域坐标
    CGRect cropRect =  CGRectMake(XRetangleLeft,
                                  YMinRetangle,
                                  sizeRetangle.width,
                                  sizeRetangle.height);
    
    return cropRect;
}

@end
