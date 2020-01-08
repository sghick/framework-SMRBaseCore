//
//  SMRScanAnimation.m
//  Gucci
//
//  Created by Tinswin on 2020/1/8.
//  Copyright © 2020 sumrise. All rights reserved.
//

#import "SMRScanAnimation.h"

@implementation SMRScanAnimation

- (void)dealloc {
    [self stopAnimating];
}

- (void)setupAnimation {
    
}

#pragma mark - SMRScanAnimation

- (void)startAnimatingWithRect:(CGRect)animationRect inView:(nonnull UIView *)parentView image:(nonnull UIImage *)image {
    [self setupAnimation];
}

- (void)stopAnimating {
    
}

@end
