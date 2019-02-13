//
//  UIView+SMRResponder.m
//  SMRBaseCoreDemo
//
//  Created by 丁治文 on 2019/2/13.
//  Copyright © 2019 sumrise. All rights reserved.
//

#import "UIView+SMRResponder.h"

@implementation UIView (SMRResponder)

+ (void)smr_toBecomeFirstResponderWhenReturn:(UIView *)responder
                           inOrderResponders:(NSArray<UIView *> *)inOrderResponders
                                   lastBlcok:(void (^)(UIView * _Nonnull))lastBlcok {
    if (responder == inOrderResponders.lastObject) {
        if (lastBlcok) {
            lastBlcok(responder);
        }
        return;
    }
    BOOL shouldBecomeFirstResponder = NO;
    for (UIView *resp in inOrderResponders) {
        BOOL canBecomeFirstResponder = (resp.canBecomeFirstResponder &&
                                        resp.userInteractionEnabled &&
                                        !resp.hidden &&
                                        resp.alpha!=0.0 &&
                                        resp.superview);
        if (!canBecomeFirstResponder) {
            continue;
        }
        if (responder == resp) {
            shouldBecomeFirstResponder = YES;
            continue;
        }
        if (shouldBecomeFirstResponder) {
            [resp becomeFirstResponder];
            break;
        }
    }
    return;
}

@end
