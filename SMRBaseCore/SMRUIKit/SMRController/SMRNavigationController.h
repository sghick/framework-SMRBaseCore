//
//  SMRNavigationController.h
//  SMRBaseCoreDemo
//
//  Created by 丁治文 on 2019/1/21.
//  Copyright © 2019 sumrise. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SMRNavigationController : UINavigationController

@property (assign, nonatomic, readonly) BOOL backGesture;

/**
 增加右滑手势的方法
 */
- (void)addSupportBackGesture;

/**
 移除右滑手势的方法
 */
- (void)removeSupportBackGesture;

@end

NS_ASSUME_NONNULL_END
