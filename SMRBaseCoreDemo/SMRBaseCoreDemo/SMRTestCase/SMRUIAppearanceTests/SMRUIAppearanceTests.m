//
//  SMRUIAppearanceTests.m
//  SMRBaseCoreDemo
//
//  Created by Tinswin on 2020/7/23.
//  Copyright © 2020 sumrise. All rights reserved.
//

#import "SMRUIAppearanceTests.h"
#import "SMRObject.h"
#import "SMRSubview.h"

@implementation SMRUIAppearanceTests

- (id)begin {
    [self test002];
    return self;
}

- (void)test001 {
    UIView *view1 = [UIView appearance];
    UIView *view2 = [UIView appearance];
    UIControl *view3 = [UIControl appearance];
    UIControl *view4 = [UIControl appearance];
    UIButton *view5 = [UIButton appearance];
    UIButton *view6 = [UIButton appearance];
    view1.backgroundColor = [UIColor yellowColor];
    view2.backgroundColor = [UIColor blueColor];
    NSLog(@"color:%@", view1.backgroundColor);
}

- (void)test002 {
    SMRView *view1 = [SMRView smr_appearance];
    SMRView *view2 = [SMRView smr_appearance];
    SMRSubview *view3 = [SMRSubview smr_appearance];
    SMRSubview *view4 = [SMRSubview smr_appearance];
    SMRObject *obj5 = [SMRObject smr_appearance];
    SMRObject *obj6 = [SMRObject smr_appearance];

    view1.bgcolor = [UIColor redColor];
    view3.bgcolor = [UIColor blueColor];
    obj5.objname = @"mingming";
    
    SMRView *testView = [[SMRView alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    [[UIApplication sharedApplication].keyWindow addSubview:testView];
    
    NSLog(@"1:%@", view1.bgcolor);
    NSLog(@"2:%@", view3.bgcolor);
    NSLog(@"3:%@", obj5.objname);
}

@end
