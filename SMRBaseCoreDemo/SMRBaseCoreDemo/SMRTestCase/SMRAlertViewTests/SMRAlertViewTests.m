//
//  SMRAlertViewTests.m
//  SMRBaseCoreDemo
//
//  Created by 丁治文 on 2019/2/18.
//  Copyright © 2019 sumrise. All rights reserved.
//

#import "SMRAlertViewTests.h"
#import "SMRBaseCoreConfig.h"
#import "PureLayout.h"

@interface SMRAlertViewTests ()

@property (strong, nonatomic) SMRContentMaskView *maskView;

@end

@implementation SMRAlertViewTests

- (id)begin {
    [self testAlertTextField:nil];
//    [self testConfigOld];
//    [self testConfigNew];
//    [self testAlertNavigationInView:[self testAlertAttrTextInView:[self testAlertTextInView:nil]]];
//    [self testAlertWithImageNormal];
    return self;
}

- (void)testConfigOld {
    [SMRBaseCoreConfig sharedInstance].alertViewStyle = SMRAlertViewStyleOrange;
    [SMRBaseCoreConfig sharedInstance].alertTitleColor = [UIColor smr_generalRedColor];
    [self testAlertTextInView:nil];
}

- (void)testConfigNew {
    [SMRAlertView smr_appearance].alertViewStyle = SMRAlertViewStyleOrange;
    [SMRAlertView smr_appearance].titleColor = [UIColor smr_generalRedColor];
    [self testAlertTextInView:nil];
}

- (UIView *)testAlertTextField:(UIView *)view {
    SMRAlertView *alert = [SMRAlertView alertViewWithTextFieldAndButtonTitles:@[@"取消", @"确定"]
                                                                deepColorType:SMRAlertViewButtonDeepColorTypeSure
                                                                  configStyle:^UITextField * _Nonnull(UITextField * _Nonnull textField) {
        textField.placeholder = @"请输入昵称";
        
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = [UIColor smr_lineGrayColor];
        [textField addSubview:line];
        [line autoPinEdgeToSuperviewEdge:ALEdgeLeft];
        [line autoPinEdgeToSuperviewEdge:ALEdgeRight];
        [line autoPinEdgeToSuperviewEdge:ALEdgeBottom];
        [line autoSetDimension:ALDimensionHeight toSize:LINE_HEIGHT];
        return textField;
    }];
    [alert show];
    return alert;
}

- (UIView *)testAlertTextInView:(UIView *)view {
    SMRAlertView *alert = [SMRAlertView alertViewWithTitle:@"温馨提示"
                                                   content:@"地址：北京市朝阳区北三环福利双子座b座2101 \n营业时间：9:30-21:30（周一至周日）\n联系电话：18910035715"
                                              buttonTitles:@[@"确定"]
                                             deepColorType:SMRAlertViewButtonDeepColorTypeCancel];
//    alert.contentTextAlignment = NSTextAlignmentLeft;
//    alert.roundContentIfAligmentCenter = NO;
    [alert showInView:view animated:YES];
    alert.sureButtonTouchedBlock = ^(SMRAlertView *maskView) {
        maskView.alertViewStyle = SMRAlertViewStyleRed;
        maskView.buttonTitles = @[@"取消", @"确定"];
        maskView.deepColorType = SMRAlertViewButtonDeepColorTypeSure;
        maskView.reversCancleAndSureButtonPostion = YES;
        [maskView smr_reloadViewIfNeeded];
    };
    return alert;
}

- (void)testAlertWithImageNormal {
    SMRTextAttribute *attr = [[SMRTextAttribute alloc] init];
    attr.font = [UIFont smr_systemFontOfSize:13];
    attr.color = [UIColor smr_darkGrayColor];
    NSString *text = @"请按照以下示例图测量表盘直径大小请按照以下示例图测量表盘直径大小请按照以下示例图测量表盘直径大小请按照以下示例图测量表盘直径大小请按照以下示例图测量表盘直径大小请按照以下示例图测量表盘直径大小请按照以下示例图测量表盘直径大小请按照以下示例图测量表盘直径大小请按照以下示例图测量表盘直径大小请按照以下示例图测量表盘直径大小请按照以下示例图测量表盘直径大小请按照以下示例图测量表盘直径大小请按照以下示例图测量表盘直径大小请按照以下示例图测量表盘直径大小请按照以下示例图测量表盘直径大小请按照以下示例图测量表盘直径大小请按照以下示例图测量表盘直径大小请按照以下示例图测量表盘直径大小";
    NSAttributedString *attrStr = [attr attributedStringWithText:text];
    SMRAlertView *alert =
    [SMRAlertView alertViewWithTitle:@"表盘直径测量说明"
                    attributeContent:attrStr
                        buttonTitles:@[@"我知道了"]
                       deepColorType:SMRAlertViewButtonDeepColorTypeSure];
    UIImage *image = [UIImage smr_imageNamed:@"sale_watch_diameter_help"];
    [alert addImage:image
               size:[SMRUIAdapter size:CGSizeMake(237, 237)]
              space:[SMRUIAdapter value:10]];
    [alert show];
}

- (UIView *)testAlertAttrTextInView:(UIView *)view {
    NSString *urlSymbol = @"《用户协议》";
    NSString *string = [NSString stringWithFormat:@"地址：北京市朝阳区北三环福利双子座b座2101 \n营业时间：9:30-21:30（周一至周日）\n联系电话：400-6011009\n请阅读%@", urlSymbol];
    NSAttributedString *attr = [[NSAttributedString alloc] initWithString:string];
    SMRAlertView *alert = [SMRAlertView alertViewWithAttributeContent:attr
                                                         buttonTitles:@[@"确定"]
                                                        deepColorType:SMRAlertViewButtonDeepColorTypeNone];
    alert.contentTextAlignment = NSTextAlignmentLeft;
    [alert addLinkToURL:[NSURL URLWithString:@"SMR-hermes://coupons"]
              withRange:[string rangeOfString:urlSymbol]];
    [alert showInView:view animated:YES];
    return alert;
}

- (UIView *)testAlertNavigationInView:(UIView *)view {
    NSString *urlSymbol = @"《用户协议》";
    NSString *content = [NSString stringWithFormat:@"111111\n111111\n111111\n222222\n%@", urlSymbol];
    SMRAlertView *alert = [SMRAlertView alertViewWithContent:content
                                               buttonTitles:@[@"cancel", @"ok"]
                                              deepColorType:SMRAlertViewButtonDeepColorTypeSure];
    [alert addLinkToURL:[NSURL URLWithString:@"SMR-hermes://coupons"]
              withRange:[content rangeOfString:urlSymbol]];
    [alert showInView:view animated:YES];
    alert.sureButtonTouchedBlock = ^(SMRAlertView *maskView) {
        [maskView updateHeightOfContentView:600 aniamted:YES];
        
//        SMRAlertView *view2 = [SMRAlertView alertViewWithContent:@"2222222\n2222222"
//                                                    buttonTitles:@[@"cancel", @"ok"]
//                                                   deepColorType:SMRAlertViewButtonDeepColorTypeCancel];
//        [view2 showInView:maskView animated:YES];
//
//        view2.sureButtonTouchedBlock = ^(SMRAlertView *maskView) {
//            SMRAlertView *view3 = [SMRAlertView alertViewWithContent:@"333333"
//                                                        buttonTitles:@[@"cancel", @"ok"]
//                                                       deepColorType:SMRAlertViewButtonDeepColorTypeCancel];
//            [view3 showInView:maskView animated:YES];
//
//            view3.sureButtonTouchedBlock = ^(SMRAlertView *maskView) {
//                [maskView hideAllMaskViewWithAnimated:YES];
//            };
//        };
    };
    return alert;
}

- (void)testMaskNavigation {
    
    SMRContentMaskView *view = self.maskView ?: [[SMRContentMaskView alloc] initWithContentAlignment:SMRContentMaskViewContentAlignmentBottom];
    self.maskView = view;
    
    [view updateHeightOfContentView:450];
    [view show];
    
    view.backgroundTouchedBlock = ^(id  _Nonnull maskView) {
        [maskView hide];
    };
    view.contentViewTouchedBlock = ^(SMRAlertView *maskView) {
        [maskView updateHeightOfContentView:600];
        [UIView animateWithDuration:0.35 animations:^{
            [maskView layoutIfNeeded];
        }];
        
//        SMRContentMaskView *view2 = [[SMRContentMaskView alloc] initWithContentAlignment:SMRContentMaskViewContentAlignmentBottom];
//        [view2 updateHeightOfContentView:650];
//        view2.contentView.backgroundColor = [UIColor blueColor];
//        [view2 showInView:maskView animated:YES];
//
//        view2.backgroundTouchedBlock = ^(id  _Nonnull maskView) {
//            [maskView hide];
//        };
//        view2.contentViewTouchedBlock = ^(SMRAlertView *maskView) {
//            SMRContentMaskView *view3 = [[SMRContentMaskView alloc] initWithContentAlignment:SMRContentMaskViewContentAlignmentBottom];
//            [view3 updateHeightOfContentView:580];
//            view3.contentView.backgroundColor = [UIColor redColor];
//            [view3 showInView:maskView animated:YES];
//
//            view3.backgroundTouchedBlock = ^(id  _Nonnull maskView) {
//                [maskView hide];
//            };
//            view3.contentViewTouchedBlock = ^(SMRAlertView *maskView) {
//                [maskView hideAllMaskViewWithAnimated:YES];
//            };
//        };
    };
}

- (void)testMaskView {
    SMRContentMaskView *view = [[SMRContentMaskView alloc] init];
    [view showAnimated:YES];
    
    [view setContentViewTouchedBlock:^(id  _Nonnull maskView) {
        [maskView hideAnimated:YES];
    }];

    [view setBackgroundTouchedBlock:^(id  _Nonnull maskView) {
        [maskView hideAnimated:YES];
    }];
}

- (void)testPresentView {
    SMRAlertView *view = [SMRAlertView alertViewWithContent:@"ceoijfaoisdjlasf"
                                               buttonTitles:@[@"cancel", @"ok"]
                                              deepColorType:SMRAlertViewButtonDeepColorTypeCancel];
    [view showAnimated:YES];
    
    [view setContentViewTouchedBlock:^(id  _Nonnull maskView) {
        [maskView hideAnimated:YES];
    }];
    
    [view setBackgroundTouchedBlock:^(id  _Nonnull maskView) {
        [maskView hideAnimated:YES];
    }];
    
    [view setSureButtonTouchedBlock:^(id  _Nonnull maskView) {
        NSLog(@"ok");
    }];
    
    [view setCancelButtonTouchedBlock:^(id  _Nonnull maskView) {
        NSLog(@"cancel");
    }];
    
    NSArray<NSLayoutConstraint *> *layouts = nil;
    [[UIApplication sharedApplication].delegate.window setSafeAreaViewWithColor:[UIColor redColor] height:BOTTOM_HEIGHT + 100];
    NSLog(@"layouts:%@", layouts);
}

@end
