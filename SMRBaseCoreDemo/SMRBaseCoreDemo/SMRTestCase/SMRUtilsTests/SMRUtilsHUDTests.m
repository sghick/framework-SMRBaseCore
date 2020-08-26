//
//  SMRUtilsHUDTests.m
//  SMRBaseCoreDemo
//
//  Created by 丁治文 on 2019/4/8.
//  Copyright © 2019 sumrise. All rights reserved.
//

#import "SMRUtilsHUDTests.h"

@implementation SMRUtilsHUDTests

- (id)begin {
    [self testToast];
    return self;
}

- (void)testHUD {
    
}

- (void)testToast {
    static NSInteger index = 0;
    [SMRUtils toast:[NSString stringWithFormat:@"小明和小刚和小风%@", @(index++)]];
}

- (void)testMixture {
    
}

@end
