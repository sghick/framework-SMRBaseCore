//
//  SMRView.m
//  SMRBaseCoreDemo
//
//  Created by Tinswin on 2020/6/12.
//  Copyright © 2020 sumrise. All rights reserved.
//

#import "SMRView.h"

@implementation SMRView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UIColor *bgcolor = self.smr_appearance.bgcolor;
        self.backgroundColor = bgcolor;
    }
    return self;
}

@end
