//
//  SMRSliderBarContentViewTests.m
//  SMRBaseCoreDemo
//
//  Created by 丁治文 on 2019/4/11.
//  Copyright © 2019 sumrise. All rights reserved.
//

#import "SMRSliderBarContentViewTests.h"
#import "SMRSliderBarContentViewTestsController.h"

@implementation SMRSliderBarContentViewTests

- (id)begin {
    
    SMRSliderBarContentViewTestsController *controller = [[SMRSliderBarContentViewTestsController alloc] init];
    [SMRNavigator pushOrPresentToViewController:controller animated:YES];
    
    return self;
}

@end
