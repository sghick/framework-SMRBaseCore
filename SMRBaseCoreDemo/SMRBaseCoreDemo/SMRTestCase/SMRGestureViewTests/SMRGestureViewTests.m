//
//  SMRGestureViewTests.m
//  SMRBaseCoreDemo
//
//  Created by 丁治文 on 2019/5/14.
//  Copyright © 2019 sumrise. All rights reserved.
//

#import "SMRGestureViewTests.h"
#import "SMRGestureViewTestsController.h"

@implementation SMRGestureViewTests

- (id)begin {
    SMRGestureViewTestsController *controller = [[SMRGestureViewTestsController alloc] init];
    controller.preImage = [UIImage smr_imageNamed:@"pikaqu.jpg"];
    [SMRNavigator pushOrPresentToViewController:controller animated:YES];
    return self;
}

@end
