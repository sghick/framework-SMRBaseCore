//
//  SMRSearchBar.h
//  SMRBaseCoreDemo
//
//  Created by Tinswin on 2020/8/7.
//  Copyright © 2020 sumrise. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SMRSearchBar : UIView

@property (assign, nonatomic) UIEdgeInsets contentInsets; ///< 默认{0,10,0,0}

@property (strong, nonatomic) UIImageView *iconImageView; ///< 设置为nil时表示无icon
@property (assign, nonatomic) CGSize iconImageSize; ///< CGSizeZero表示使用icon的size,默认{14,14}
@property (assign, nonatomic) CGFloat space; ///< icon和textfield的间隔,默认10
@property (strong, nonatomic) UITextField *searchTextField;


@end

NS_ASSUME_NONNULL_END
