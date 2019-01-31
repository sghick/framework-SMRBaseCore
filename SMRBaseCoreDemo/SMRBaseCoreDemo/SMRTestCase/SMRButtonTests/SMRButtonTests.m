//
//  SMRButtonTests.m
//  SMRBaseCoreDemo
//
//  Created by 丁治文 on 2019/1/31.
//  Copyright © 2019 sumrise. All rights reserved.
//

#import "SMRButtonTests.h"
#import "SMRButtonTestsController.h"

@implementation SMRButtonTests

- (id)begin {
    SMRButtonTestsController *controller = [[SMRButtonTestsController alloc] init];
    [SMRNavigator pushOrPresentToViewController:controller animated:YES];
    return self;
}

@end
