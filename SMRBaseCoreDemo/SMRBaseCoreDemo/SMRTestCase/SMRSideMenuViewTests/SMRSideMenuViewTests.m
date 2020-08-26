//
//  SMRSideMenuViewTests.m
//  SMRBaseCoreDemo
//
//  Created by Tinswin on 2020/6/10.
//  Copyright © 2020 sumrise. All rights reserved.
//

#import "SMRSideMenuViewTests.h"
#import "SMRSideMenuView.h"
#import "SMRSideMenuItem.h"
#import <SMRDebuger.h>
#import "UIView+SMRShadowView.h"

@implementation SMRSideMenuViewTests

- (id)begin {
    [self testNormalMenu];
    return self;
}

- (void)testNormalMenu {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"MenuJson" ofType:@"json"];
    NSData *data = [[NSData alloc] initWithContentsOfFile:filePath];
    NSArray *menuParams = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    
    NSArray<SMRSideMenuItemParams *> *itemParams = [SMRSideMenuItemParams smr_arrayWithArray:menuParams];
    NSArray *menuItems = [SMRSideMenuItem menuItemsWithParams:itemParams];
    CGPoint menuOrigin = CGPointMake(200, 300);
    
    SMRSideMenuView *sideMenu = [[SMRSideMenuView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    sideMenu.tableView.leftMargin = 10;
    sideMenu.tableView.rightMargin = 10;
    sideMenu.maxHeightOfContent = 245;
    sideMenu.trangleStyle = SMRSideMenuTrangleStyleUp;
    sideMenu.trangleOffset = CGPointMake(10, 0);
    
    sideMenu.trangleOffsetReverse = YES;
    
    [sideMenu loadMenuWithItems:menuItems
                           menuWidth:125
                              origin:menuOrigin];
    sideMenu.menuTouchedBlock = ^(SMRSideMenuView *menu, UIView *item, NSInteger index) {
        SMRLog1(@"item touched at index:%@", @(index), NSStringFromClass(self.class));
        [menu hide];
    };
    [sideMenu show];
}

@end
