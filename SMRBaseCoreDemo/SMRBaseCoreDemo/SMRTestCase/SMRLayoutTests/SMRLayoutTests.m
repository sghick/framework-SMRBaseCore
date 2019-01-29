//
//  SMRLayoutTests.m
//  SMRBaseCoreDemo
//
//  Created by 丁治文 on 2019/1/29.
//  Copyright © 2019 sumrise. All rights reserved.
//

#import "SMRLayoutTests.h"
#import "SMRLayoutTestController.h"
#import "SMRNavigator.h"

@implementation SMRLayoutTests

- (id)begin {
    SMRLayoutTestController *controller = [[SMRLayoutTestController alloc] init];
    [SMRNavigator pushOrPresentToViewController:controller animated:YES];
    return controller;
}

@end
