//
//  SMRCustomAlertView.m
//  SMRBaseCoreDemo
//
//  Created by Tinswin on 2020/8/6.
//  Copyright © 2020 sumrise. All rights reserved.
//

#import "SMRCustomAlertView.h"
#import "SMRUIAppearance.h"
#import "SMRAlertViewButton.h"
#import "PureLayout.h"
#import "SMRAdapter.h"

@implementation SMRCustomAlertView

+ (NSString *)smr_keyForAppearance {
    return @"SMRCustomAlertView";
}

+ (void)smr_beforeAppearance:(SMRCustomAlertView *)obj {
    obj.alertViewStyle = SMRAlertViewStyleBlack;
}

- (instancetype)initWithFrame:(CGRect)frame contentAlignment:(SMRContentMaskViewContentAlignment)contentAlignment {
    self = [super initWithFrame:frame contentAlignment:contentAlignment];
    if (self) {
        // 使用config配置的样式
        _alertViewStyle = self.smr_appearance.alertViewStyle;
    }
    return self;
}
   

#pragma mark - SMRTableAlertViewProtocol

- (CGFloat)smr_heightOfBottomBar {
    // 有按钮时
    if (self.buttonTitles.count) {
        return [self smr_topInsetsOfBottomButton] + [self heightOfButtonForStyle:self.alertViewStyle];
    }
    return 0;
}

- (UIView *)smr_bottomBarOfTableAlertView {
    // 有按钮时
    if (self.buttonTitles.count) {
        NSArray<UIButton *> *buttons = nil;
        if (self.buttonTitles.count == 1) {
            // 1个按钮时,sure]
            if (!self.reversCancleAndSureButtonPostion) {
                UIButton *sureBtn = [self buttonForStyle:self.alertViewStyle
                                                   title:self.buttonTitles[0]
                                                  target:self
                                                  action:@selector(sureBtnAction:)
                                               deepColor:YES];
                buttons = @[sureBtn];
            } else {
                UIButton *cancelBtn = [self buttonForStyle:self.alertViewStyle
                                                     title:self.buttonTitles[0]
                                                    target:self
                                                    action:@selector(cancelBtnAction:)
                                                 deepColor:YES];
                
                buttons = @[cancelBtn];
            }
        } else if (self.buttonTitles.count == 2) {
            // 2个按钮时,cancel+sure
            UIButton *cancelBtn = [self buttonForStyle:self.alertViewStyle
                                                 title:self.buttonTitles[0]
                                                target:self
                                                action:@selector(cancelBtnAction:)
                                             deepColor:NO];
            UIButton *sureBtn = [self buttonForStyle:self.alertViewStyle
                                               title:self.buttonTitles[1]
                                              target:self
                                              action:@selector(sureBtnAction:)
                                           deepColor:YES];
            if (!self.reversCancleAndSureButtonPostion) {
                buttons = @[cancelBtn, sureBtn];
            } else {
                buttons = @[sureBtn, cancelBtn];
            }
        }
        
        CGFloat height = [self heightOfButtonForStyle:self.alertViewStyle];
        UIView *bottomView = [[UIView alloc] init];
        SMRAlertViewButton *btn = [[SMRAlertViewButton alloc] initWithButtons:buttons height:height space:0];
        [bottomView addSubview:btn];
        [btn autoPinEdgeToSuperviewEdge:ALEdgeLeft];
        [btn autoPinEdgeToSuperviewEdge:ALEdgeRight];
        [btn autoPinEdgeToSuperviewEdge:ALEdgeBottom];
        [btn autoSetDimension:ALDimensionHeight toSize:height];
        
        return bottomView;
    }
    return nil;
}

#pragma mark - SMRCustomBottomButtonProtocol

- (CGFloat)smr_topInsetsOfBottomButton {
    return [SMRUIAdapter value:45];
}

- (void)sureBtnAction:(UIButton *)sender {
    if (self.sureButtonTouchedBlock) {
        self.sureButtonTouchedBlock(self);
    } else {
        [self hide];
    }
}

- (void)cancelBtnAction:(UIButton *)sender {
    if (self.cancelButtonTouchedBlock) {
        self.cancelButtonTouchedBlock(self);
    } else {
        [self hide];
    }
}

#pragma mark - Style

- (CGFloat)heightOfButtonForStyle:(SMRAlertViewStyle)style {
    return [SMRAlertViewButton generalHeightOfButton];
}

- (UIButton *)buttonForStyle:(SMRAlertViewStyle)style title:(NSString *)title target:(id)target action:(SEL)action deepColor:(BOOL)deepColor {
    // 非深色按钮为取消样式
    if (!deepColor) {
        return [SMRAlertViewButton buttonTitle:title target:target action:action style:style function:SMRAlertViewButtonFunctionCancel];
    }
    SMRAlertViewButtonDeepColorType deepColorType = self.deepColorType;
    switch (deepColorType) {
        case SMRAlertViewButtonDeepColorTypeCancel:
            return [SMRAlertViewButton buttonTitle:title target:target action:action style:style function:SMRAlertViewButtonFunctionCancel];
            break;
        
        case SMRAlertViewButtonDeepColorTypeSure:
            return [SMRAlertViewButton buttonTitle:title target:target action:action style:style function:SMRAlertViewButtonFunctionSure];
            break;
        
        case SMRAlertViewButtonDeepColorTypeDelete:
            return [SMRAlertViewButton buttonTitle:title target:target action:action style:style function:SMRAlertViewButtonFunctionDelete];
            break;
        default:
            return [SMRAlertViewButton buttonTitle:title target:target action:action style:style function:SMRAlertViewButtonFunctionCancel];
            break;
    }
    return nil;
}

#pragma mark - Setters

- (void)setAlertViewStyle:(SMRAlertViewStyle)alertViewStyle {
    _alertViewStyle = alertViewStyle;
    [self smr_setNeedsReloadView];
}

- (void)setButtonTitles:(NSArray<NSString *> *)buttonTitles {
    _buttonTitles = buttonTitles;
    [self smr_setNeedsReloadView];
}

- (void)setDeepColorType:(SMRAlertViewButtonDeepColorType)deepColorType {
    _deepColorType = deepColorType;
    [self smr_setNeedsReloadView];
}

- (void)setReversCancleAndSureButtonPostion:(BOOL)reversCancleAndSureButtonPostion {
    _reversCancleAndSureButtonPostion = reversCancleAndSureButtonPostion;
    [self smr_setNeedsReloadView];
}

@end
