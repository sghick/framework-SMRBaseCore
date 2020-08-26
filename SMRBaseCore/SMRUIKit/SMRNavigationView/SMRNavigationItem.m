//
//  SMRNavigationItem.m
//  SMRGeneralUseDemo
//
//  Created by 丁治文 on 2019/1/9.
//  Copyright © 2019 sumrise. All rights reserved.
//

#import "SMRNavigationItem.h"

@implementation SMRNavigationItem

@end

@implementation SMRNavigationTheme

+ (SMRNavigationTheme *)themeForNormal {
    SMRNavigationTheme *item = [[SMRNavigationTheme alloc] init];
    item.splitLineHidden = NO;
    item.splitLineColor = [UIColor colorWithWhite:0.92 alpha:1];
    item.characterColor = [UIColor colorWithWhite:0.2 alpha:1];
    item.backgroudColor = [UIColor whiteColor];
    return item;
}

+ (SMRNavigationTheme *)themeForRed {
    SMRNavigationTheme *item = [[SMRNavigationTheme alloc] init];
    item.splitLineHidden = YES;
    item.splitLineColor = [UIColor clearColor];
    item.characterColor = [UIColor whiteColor];
    item.backgroudColor = [UIColor colorWithWhite:0.94 alpha:1];
    return item;
}

+ (SMRNavigationTheme *)themeForBlack {
    SMRNavigationTheme *item = [[SMRNavigationTheme alloc] init];
    item.splitLineHidden = YES;
    item.splitLineColor = [UIColor clearColor];
    item.characterColor = [UIColor whiteColor];
    item.backgroudColor = [UIColor colorWithWhite:0.2 alpha:1];
    return item;
}

+ (SMRNavigationTheme *)themeForAlpha {
    SMRNavigationTheme *item = [[SMRNavigationTheme alloc] init];
    item.splitLineHidden = YES;
    item.splitLineColor = [UIColor clearColor];
    item.characterColor = [UIColor whiteColor];
    item.backgroudColor = [UIColor clearColor];
    return item;
}

@end
