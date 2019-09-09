//
//  SMRSeparatorTests.m
//  SMRBaseCoreDemo
//
//  Created by 丁治文 on 2019/9/9.
//  Copyright © 2019 sumrise. All rights reserved.
//

#import "SMRSeparatorTests.h"
#import "UITableView+Separator.h"

@interface UITableView ()

- (NSRange)rangeFromFormat:(NSString *)format;

@end

@implementation SMRSeparatorTests

- (id)begin {
    [self testRangeFromFormat];
    return self;
}

#pragma mark - Unit Test Case

- (void)testRangeFromFormat {
    UITableView *tableView = [[UITableView alloc] init];
    NSAssert(NSEqualRanges([tableView rangeFromFormat:nil], NSMakeRange(0, 0)), @"error");
    NSAssert(NSEqualRanges([tableView rangeFromFormat:@""], NSMakeRange(0, 0)), @"error");
    
    NSAssert(NSEqualRanges([tableView rangeFromFormat:@"#"], NSMakeRange(0, 0)), @"error");
    NSAssert(NSEqualRanges([tableView rangeFromFormat:@":"], NSMakeRange(0, 0)), @"error");
    NSAssert(NSEqualRanges([tableView rangeFromFormat:@"|"], NSMakeRange(0, 0)), @"error");
    
    NSAssert(NSEqualRanges([tableView rangeFromFormat:@"cden"], NSMakeRange(0, 0)), @"error");
    NSAssert(NSEqualRanges([tableView rangeFromFormat:@"n|"], NSMakeRange(0, 0)), @"error");
    NSAssert(NSEqualRanges([tableView rangeFromFormat:@"F|"], NSMakeRange(0, 0)), @"error");
    NSAssert(NSEqualRanges([tableView rangeFromFormat:@"On"], NSMakeRange(0, 0)), @"error");
    NSAssert(NSEqualRanges([tableView rangeFromFormat:@"On|"], NSMakeRange(0, 0)), @"error");
    NSAssert(NSEqualRanges([tableView rangeFromFormat:@"Fn|"], NSMakeRange(0, 0)), @"error");
    NSAssert(NSEqualRanges([tableView rangeFromFormat:@"Ln|"], NSMakeRange(0, 0)), @"error");
    NSAssert(NSEqualRanges([tableView rangeFromFormat:@"Rn|"], NSMakeRange(0, 0)), @"error");
    NSAssert(NSEqualRanges([tableView rangeFromFormat:@"Cn|"], NSMakeRange(0, 0)), @"error");
    NSAssert(NSEqualRanges([tableView rangeFromFormat:@"On{3}"], NSMakeRange(3, 0)), @"error");
    
    NSAssert(NSEqualRanges([tableView rangeFromFormat:@"y"], NSMakeRange(0, 0)), @"error");
    NSAssert(NSEqualRanges([tableView rangeFromFormat:@"C"], NSMakeRange(0, 0)), @"error");
    NSAssert(NSEqualRanges([tableView rangeFromFormat:@"O"], NSMakeRange(0, 0)), @"error");
    
    NSAssert(NSEqualRanges([tableView rangeFromFormat:@"C0"], NSMakeRange(0, 1)), @"error");
    NSAssert(NSEqualRanges([tableView rangeFromFormat:@"C2"], NSMakeRange(2, 1)), @"error");
    NSAssert(NSEqualRanges([tableView rangeFromFormat:@"C-3"], NSMakeRange(3, 1)), @"error");
    NSAssert(NSEqualRanges([tableView rangeFromFormat:@"F{1,1}"], NSMakeRange(1, 1)), @"error");
    NSAssert(NSEqualRanges([tableView rangeFromFormat:@"L{2,2}"], NSMakeRange(2, 2)), @"error");
    NSAssert(NSEqualRanges([tableView rangeFromFormat:@"O-{4,4}"], NSMakeRange(4, 4)), @"error");
    NSAssert(NSEqualRanges([tableView rangeFromFormat:@"E{5,-5}"], NSMakeRange(5, 5)), @"error");
    NSAssert(NSEqualRanges([tableView rangeFromFormat:@"E{-6,6}"], NSMakeRange(6, 6)), @"error");
    
    NSLog(@"test finished");
}

@end
