//
//  SMRAlertViewTests.m
//  SMRBaseCoreDemo
//
//  Created by 丁治文 on 2019/2/13.
//  Copyright © 2019 sumrise. All rights reserved.
//

#import "SMRAlertViewTests.h"
#import "SMRBaseCoreConfig.h"
#import "PureLayout.h"

@implementation SMRAlertViewTests

- (id)begin {
    static NSInteger touchIdx = 0;
    NSArray<NSNumber *> *stls = @[@(SMRAlertViewStyleWhite),
                                  @(SMRAlertViewStyleOrange),
                                  @(SMRAlertViewStyleConfig)];
    SMRAlertViewStyle style = stls[touchIdx%stls.count].integerValue;
    [SMRBaseCoreConfig sharedInstance].alertViewStyle = style;
    
    [self testContentMaskView_001];
    touchIdx++;
    return self;
}

- (void)testContentMaskView_001 {
    SMRAlertView *view = [SMRAlertView alertViewWithContent:@"您编辑的信息未保存,确定不对信息未保存,确定不确定不确定不?"
                                               buttonTitles:@[@"不确定"]
                                              deepColorType:SMRAlertViewButtonDeepColorTypeSure];
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
        [self testContentMaskView_002];
    }];
}

- (void)testContentMaskView_002 {
    SMRAlertView *view = [SMRAlertView alertViewWithTitle:@"提示"
                                                  content:@"确定删除该图片吗？"
                                             buttonTitles:@[@"取消", @"确定"]
                                            deepColorType:SMRAlertViewButtonDeepColorTypeSure];
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

- (void)testSafeAreaView {
    // safe view
    UIView *btview = [[UIView alloc] initWithFrame:CGRectMake(100, 300, 200, 300)];
    btview.backgroundColor = [UIColor blueColor];
    [[UIApplication sharedApplication].delegate.window addSubview:btview];
    
    [[UIApplication sharedApplication].delegate.window setSafeAreaViewWithColor:[UIColor redColor] fromBottomOfView:btview];

}

@end
