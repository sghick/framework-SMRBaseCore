//
//  SMRTableViewTests.m
//  SMRBaseCoreDemo
//
//  Created by 丁治文 on 2019/1/22.
//  Copyright © 2019 sumrise. All rights reserved.
//

#import "SMRTableViewTests.h"
#import "SMRNavigator.h"
#import "SMRTestTableController.h"

@implementation SMRTableViewTests

- (id)begin {
    [SMRNavigationView appearance].appearanceBlock = ^(SMRNavigationView *navigationView) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.exclusiveTouch = YES;
        button.adjustsImageWhenHighlighted = NO;
        [button setTitle:@"返回<-" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:14.0];
        
        navigationView.theme = [SMRNavigationTheme themeForNormal];
        navigationView.backBtn = button;
        navigationView.title = @"这是一个默认的标题";
    };
    
    SMRTestTableController *controller = [[SMRTestTableController alloc] init];
    [SMRNavigator pushOrPresentToViewController:controller animated:YES];
    return self;
}

@end
