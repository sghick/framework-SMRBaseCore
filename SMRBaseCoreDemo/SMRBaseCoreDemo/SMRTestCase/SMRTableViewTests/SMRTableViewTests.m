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
    SMRTestTableController *controller = [[SMRTestTableController alloc] init];
    [SMRNavigator pushOrPresentToViewController:controller animated:YES];
    return self;
}

@end
