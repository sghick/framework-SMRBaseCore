//
//  SMRAdapterTests.m
//  SMRBaseCoreDemo
//
//  Created by 丁治文 on 2019/2/21.
//  Copyright © 2019 sumrise. All rights reserved.
//

#import "SMRAdapterTests.h"

@implementation SMRAdapterTests

- (id)begin {
    [self testColorPropertyGet];
    return self;
}

- (void)testColorPropertyGet {
    UIColor *color = [UIColor smr_colorWithHexRGB:@"0xFFFFCC" alpha:0.5];
    assert([color smr_colorHexRGBValue] == 0xFFFFCC);
    assert([[color smr_colorHexRGBStringWithPrefix:nil] isEqualToString:@"FFFFCC"]);
    assert([color smr_colorAlpha] == 0.5);
    
    color = [UIColor smr_colorWithHexRGBValue:0xFFFFEE alpha:0.6];
    assert([color smr_colorHexRGBValue] == 0xFFFFEE);
    assert([[color smr_colorHexRGBStringWithPrefix:@"0x"] isEqualToString:@"0xFFFFEE"]);
    assert([color smr_colorAlpha] == 0.6);
}

@end
