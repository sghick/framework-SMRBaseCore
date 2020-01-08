//
//  SMRScanNetAnimation.m
//  Gucci
//
//  Created by Tinswin on 2020/1/8.
//  Copyright © 2020 sumrise. All rights reserved.
//

#import "SMRScanNetAnimation.h"

@interface SMRScanNetAnimation ()

@property (nonatomic, assign) BOOL isAnimationing;
@property (nonatomic,assign) CGRect animationRect;
@property (nonatomic,strong) UIImageView *scanImageView;

@end

@implementation SMRScanNetAnimation

- (instancetype)init {
    self = [super init];
    if (self) {
        self.clipsToBounds = YES;
        [self addSubview:self.scanImageView];
    }
    return self;
}

- (void)setupAnimation {
    if (!self.isAnimationing) {
        return;
    }
    
    self.frame = _animationRect;
    
    CGFloat scanNetImageViewW = self.frame.size.width;
    CGFloat scanNetImageH = self.frame.size.height;
 
    self.alpha = 0.5;
    _scanImageView.frame = CGRectMake(0, -scanNetImageH, scanNetImageViewW, scanNetImageH);
    [UIView animateWithDuration:1.4 animations:^{
        self.alpha = 1.0;
        self.scanImageView.frame = CGRectMake(0, scanNetImageViewW-scanNetImageH, scanNetImageViewW, scanNetImageH);
        
    } completion:^(BOOL finished) {
         [self performSelector:_cmd withObject:nil afterDelay:0.3];
     }];
}

#pragma mark - SMRScanAnimation

- (void)startAnimatingWithRect:(CGRect)animationRect inView:(nonnull UIView *)parentView image:(nonnull UIImage *)image {
    [self.scanImageView setImage:image];
    
    self.animationRect = animationRect;
    
    [parentView addSubview:self];
    
    self.hidden = NO;
    
    self.isAnimationing = YES;
    
    [self setupAnimation];
}

- (void)stopAnimating {
    self.hidden = YES;
    self.isAnimationing = NO;
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}

#pragma mark - Getters

- (UIImageView *)scanImageView{
    if (!_scanImageView) {
        _scanImageView = [[UIImageView alloc] init];
    }
    return _scanImageView;
}

@end
