//
//  SMRAlertViewTests.m
//  SMRBaseCoreDemo
//
//  Created by 丁治文 on 2019/2/13.
//  Copyright © 2019 sumrise. All rights reserved.
//

#import "SMRAlertViewTests.h"

@implementation SMRAlertViewTests

- (id)begin {
    [self testContentMaskView_001];
    return self;
}

- (void)testContentMaskView_001 {
    SMRContentMaskView *view = [[SMRContentMaskView alloc] init];
    [view showAnimated:YES];
    [view setContentViewTouchedBlock:^(SMRContentMaskView * _Nonnull maskView) {
        NSLog(@"内容载体视频被点了一下~^_^");
    }];
    [view setBackgroundTouchedBlock:^(SMRContentMaskView * _Nonnull maskView) {
        [maskView hideAnimated:YES];
    }];
}

@end
