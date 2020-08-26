//
//  SMRWebTests.m
//  SMRBaseCoreDemo
//
//  Created by 丁治文 on 2019/5/6.
//  Copyright © 2019 sumrise. All rights reserved.
//

#import "SMRWebTests.h"
#import "SMRWebController.h"
#import "SMRSerivceWebConfig.h"

@implementation SMRWebTests

- (id)begin {
    [SMRWebConfig shareConfig].webJSRegisterConfig = [SMRSerivceWebConfig defaultConfig];
    [SMRWebConfig shareConfig].webReplaceConfig = [SMRSerivceWebConfig defaultConfig];
    [SMRWebConfig shareConfig].webNavigationViewConfig = [SMRSerivceWebConfig defaultConfig];
    
    [self testCookie];
    return self;
}

- (void)testWebJS {
    SMRWebController *web = [[SMRWebController alloc] init];
    web.url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"web_test_protocol" ofType:@"html"]].absoluteString;
    [SMRNavigator pushOrPresentToViewController:web animated:YES];
}

- (void)testWebBack {
    SMRWebController *web = [[SMRWebController alloc] init];
    web.isMainPage = YES;
    web.url = [NSURL URLWithString:@"https://www.baidu.com"].absoluteString;
    [SMRNavigator pushOrPresentToViewController:web animated:YES];
}

- (void)testCookie {
//    [SMRUtils jumpToAnyURL:@"http://192.168.2.26/index.php"];
//    [SMRUtils jumpToAnyURL:@"https://www.baidu.com"];
//    [SMRUtils jumpToAnyURL:@"https://u.sumrise.com/1V"];
    
}

- (void)testWebJump {
    NSString *url = @"http://mwx.sumrise.com/SaleBag/DelegateApp?Phone=__LOGIN_PHONE__";
    [SMRUtils jumpToAnyURL:url];
}

- (void)testContentMaskView {
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

@end
