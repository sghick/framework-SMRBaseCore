//
//  UIView+SMRResponder.h
//  SMRBaseCoreDemo
//
//  Created by 丁治文 on 2019/2/13.
//  Copyright © 2019 sumrise. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (SMRResponder)

/**
 按照一定顺序使responder获得焦点
 
 @param lastBlcok 最后一个时的回调,可以在这里处理登录/完成逻辑
 */
+ (void)smr_toBecomeFirstResponderWhenReturn:(UIView *)responder
                           inOrderResponders:(NSArray<UIView *> *)inOrderResponders
                                   lastBlcok:(void (^)(UIView *responder))lastBlcok;

@end

NS_ASSUME_NONNULL_END
