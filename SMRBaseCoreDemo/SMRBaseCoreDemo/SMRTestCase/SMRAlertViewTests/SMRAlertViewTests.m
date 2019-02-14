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
    SMRAlertView *view = [SMRAlertView alertViewWithContent:@"您编辑的信息未保存,确定不对信息未保存,确定不确定不确定不?"
                                               buttonTitles:@[@"取消", @"不确定"]
                                              deepColorType:SMRAlertViewButtonDeepColorTypeCancel];
    [view showAnimated:YES];
    [view setContentViewTouchedBlock:^(id  _Nonnull maskView) {
        NSLog(@"内容载体被点了一下~^_^");
    }];
    [view setBackgroundTouchedBlock:^(id  _Nonnull maskView) {
        [maskView hideAnimated:YES];
    }];
    [view setCancelButtonTouchedBlock:^(id  _Nonnull maskView) {
        [maskView hideAnimated:YES];
        NSLog(@"已取消");
    }];
    [view setSureButtonTouchedBlock:^(id  _Nonnull maskView) {
        NSLog(@"我知道了");
    }];
}

@end
