//
//  SMRNavigationItem.h
//  SMRBaseCoreDemo
//
//  Created by 丁治文 on 2019/1/21.
//  Copyright © 2019 sumrise. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMRNavigationDefine.h"

NS_ASSUME_NONNULL_BEGIN

@interface SMRNavigationItem : NSObject

@property (nonatomic, assign) CGFloat leftMargin;                   // 左边缩进
@property (nonatomic, assign) CGFloat rightMargin;                  // 右边缩进
@property (nonatomic, assign) CGFloat heightOfNavigationContent;    // 内容高
@property (nonatomic, assign) CGFloat heightOfNavigation;           // 整高

@end

// 主题Model
@interface SMRNavigationTheme : NSObject

@property (nonatomic, assign) BOOL splitLineHidden;         // 是否隐藏底部线
@property (nonatomic, strong) UIColor *splitLineColor;      // 底部线颜色
@property (nonatomic, strong) UIColor *backgroudColor;      // 背景颜色
@property (nonatomic, strong) UIColor *characterColor;      // 文字颜色


// 普通主题, default
+ (SMRNavigationTheme *)themeForNormal;

// 透明主题，背景为透明，文字为白色
+ (SMRNavigationTheme *)themeForAlpha;

@end

NS_ASSUME_NONNULL_END
