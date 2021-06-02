//
//  SMRDialogSheetView.m
//  Hermes
//
//  Created by Tinswin on 2021/3/26.
//  Copyright © 2021 isumrise. All rights reserved.
//

#import "SMRDialogSheetView.h"

@implementation SMRDialogSheetView

#pragma mark - Override

- (void)dialogViewCreated {
    CGRect frame = self.frame;
    [self setContentViewSize:CGSizeMake(CGRectGetWidth(frame), 300) animated:YES];
}

- (void)setContentViewSize:(CGSize)size animated:(BOOL)animated {
    [super setContentViewSize:size animated:animated];
    CGRect frame = self.frame;
    self.maskContentView.frame = CGRectMake((CGRectGetWidth(frame) - size.width)/2.0,
                                            CGRectGetHeight(frame) - size.height,
                                            size.width, size.height);
}

#pragma mark - SMRDialogMaskViewAnimation

- (void)animationOfShow {
    [super animationOfShow];
    CGFloat offsetY = CGRectGetHeight(self.maskContentView.frame);
    self.maskContentView.transform = CGAffineTransformMakeTranslation(0, offsetY);
    [UIView animateWithDuration:self.animationDuration animations:^{
        self.maskContentView.transform = CGAffineTransformMakeTranslation(0, 0);
    }];
}

- (void)animationOfHide {
    CGFloat offsetY = CGRectGetHeight(self.maskContentView.frame);
    [UIView animateWithDuration:self.animationDuration animations:^{
        self.maskContentView.transform = CGAffineTransformMakeTranslation(0, offsetY);
    }];
    [super animationOfHide];
}

@end
