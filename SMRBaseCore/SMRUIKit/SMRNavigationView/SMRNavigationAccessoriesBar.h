//
//  SMRNavigationAccessoriesBar.h
//  SMRBaseCoreDemo
//
//  Created by 丁治文 on 2019/1/21.
//  Copyright © 2019 sumrise. All rights reserved.
//

#import "SMRNavigationBar.h"

NS_ASSUME_NONNULL_BEGIN

@interface SMRNavigationAccessoriesBar : SMRNavigationBar

@property (assign, nonatomic) CGSize leftViewSize;
@property (assign, nonatomic) CGSize rightViewSize;
@property (assign, nonatomic) CGSize centerViewSize;

@property (nonatomic, copy  , nullable) NSArray<UIView *> *leftViews;
@property (nonatomic, copy  , nullable) NSArray<UIView *> *rightViews;

@property (nonatomic, strong, nullable) UIView *leftView;
@property (nonatomic, strong, nullable) UIView *rightView;
@property (nonatomic, strong, nullable) UIView *centerView;

@end

NS_ASSUME_NONNULL_END
