//
//  SMRDialogAlertView.m
//  Hermes
//
//  Created by Tinswin on 2021/3/26.
//  Copyright © 2021 ibaodashi. All rights reserved.
//

#import "SMRDialogAlertView.h"

@implementation SMRDialogAlertView

#pragma mark - Override

- (void)dialogViewCreated {
    [self setContentViewSize:CGSizeMake(300, 300) animated:NO];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.maskContentView.center = self.center;
}

@end
