//
//  SMRScanLineAnimation.m
//  Gucci
//
//  Created by Tinswin on 2020/1/8.
//  Copyright © 2020 sumrise. All rights reserved.
//

#import "SMRScanLineAnimation.h"

@interface SMRScanLineAnimation ()

@property (nonatomic, assign) int num;
@property (nonatomic, assign) BOOL down;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) BOOL isAnimationing;

@property (nonatomic, assign) CGRect animationRect;

@end

@implementation SMRScanLineAnimation

- (void)setupAnimation {
    if (!_isAnimationing) {
        return;
    }
    CGFloat leftx = _animationRect.origin.x + 5;
    CGFloat width = _animationRect.size.width - 10;
    
    self.frame = CGRectMake(leftx, _animationRect.origin.y + 8, width, 8);
    
    self.alpha = 0.0;
    self.hidden = NO;
        
    [UIView animateWithDuration:0.5 animations:^{
         self.alpha = 1.0;
    } completion:nil];
    
    [UIView animateWithDuration:3 animations:^{
        CGFloat leftx = self.animationRect.origin.x + 5;
        CGFloat width = self.animationRect.size.width - 10;
        self.frame = CGRectMake(leftx, self.animationRect.origin.y + self.animationRect.size.height - 8, width, 4);
    } completion:^(BOOL finished) {
         self.hidden = YES;
         [self performSelector:_cmd withObject:nil afterDelay:0.3];
     }];
}

#pragma mark - SMRScanAnimation

- (void)startAnimatingWithRect:(CGRect)animationRect inView:(nonnull UIView *)parentView image:(nonnull UIImage *)image {
    if (self.isAnimationing) {
        return;
    }
    
    self.isAnimationing = YES;

    self.animationRect = animationRect;
    self.down = YES;
    self.num = 0;
    
    CGFloat centery = CGRectGetMinY(animationRect) + CGRectGetHeight(animationRect)/2;
    CGFloat leftx = animationRect.origin.x + 5;
    CGFloat width = animationRect.size.width - 10;
    
    self.frame = CGRectMake(leftx, centery + 2*self.num, width, 2);
    self.image = image;
    
    [parentView addSubview:self];
    
    [self setupAnimation];
}

- (void)stopAnimating {
    if (self.isAnimationing) {
        self.isAnimationing = NO;
        if (self.timer) {
            [self.timer invalidate];
            self.timer = nil;
        }
        [self removeFromSuperview];
    }
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}

@end
