//
//  SMRCarouselViewTests.m
//  SMRBaseCoreDemo
//
//  Created by 丁治文 on 2019/8/22.
//  Copyright © 2019 sumrise. All rights reserved.
//

#import "SMRCarouselViewTests.h"
#import "SMRCarouselView.h"

@implementation SMRCarouselViewTests

- (id)begin {
    SMRCarouselView *view = [[SMRCarouselView alloc] init];
    view.frame = CGRectMake(0, 100, SCREEN_WIDTH, [SMRUIAdapter value:80]);
    view.backgroundColor = [UIColor yellowColor];
    [view reloadData];
    [[UIApplication sharedApplication].delegate.window addSubview:view];
    
    return self;
}

@end
