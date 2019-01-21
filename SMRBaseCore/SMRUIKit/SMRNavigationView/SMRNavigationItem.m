//
//  SMRNavigationItem.m
//  SMRBaseCoreDemo
//
//  Created by 丁治文 on 2019/1/21.
//  Copyright © 2019 sumrise. All rights reserved.
//

#import "SMRNavigationItem.h"

@implementation SMRNavigationItem

@end

@implementation SMRNavigationTheme

// 普通主题, default
+ (SMRNavigationTheme *)themeForNormal {
    SMRNavigationTheme *item = [[SMRNavigationTheme alloc] init];
    item.splitLineHidden = NO;
    item.splitLineColor = [UIColor grayColor];
    item.characterColor = [UIColor blackColor];
    item.backgroudColor = [UIColor whiteColor];
    return item;
}

// 透明主题, 背景为透明, 文字为白色
+ (SMRNavigationTheme *)themeForAlpha {
    SMRNavigationTheme *item = [[SMRNavigationTheme alloc] init];
    item.splitLineHidden = YES;
    item.splitLineColor = [UIColor clearColor];
    item.characterColor = [UIColor whiteColor];
    item.backgroudColor = [UIColor clearColor];
    return item;
}

@end
