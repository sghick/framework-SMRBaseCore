//
//  SMRMatrixCalculatorTests.m
//  SMRBaseCoreDemo
//
//  Created by 丁治文 on 2019/3/4.
//  Copyright © 2019 sumrise. All rights reserved.
//

#import "SMRMatrixCalculatorTests.h"

@implementation SMRMatrixCalculatorTests

- (id)begin {
    [self testV];
    [self testH];
    
    return self;
}

- (void)testV {
    CGRect bounds = CGRectMake(10, 100, SCREEN_WIDTH - 20, 100);
    SMRMatrixCalculator *cal = [SMRMatrixCalculator calculatorForVerticalWithBounds:bounds columnsCount:3 spaceOfRow:10 cellSize:CGSizeMake(30, 30)];
    cal.spaceOfColumn = 5;
    
    NSArray<NSString *> *arr = [@"1 2 3 4 5 6 7" componentsSeparatedByString:@" "];
    [arr enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UILabel *view = [[UILabel alloc] init];
        view.textAlignment = NSTextAlignmentCenter;
        view.text = obj;
        view.backgroundColor = [UIColor yellowColor];
        view.frame = [cal cellFrameWithIndex:idx];
        [[UIApplication sharedApplication].delegate.window addSubview:view];
    }];
}

- (void)testH {
    CGRect bounds = CGRectMake(130, 100, SCREEN_WIDTH - 20, 100);
    SMRMatrixCalculator *cal = [SMRMatrixCalculator calculatorForHorizontalWithBounds:bounds rowsCount:3 spaceOfColumn:10 cellSize:CGSizeMake(30, 30)];
    cal.spaceOfRow = 5;
    
    NSArray<NSString *> *arr = [@"1 2 3 4 5 6 7" componentsSeparatedByString:@" "];
    [arr enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UILabel *view = [[UILabel alloc] init];
        view.textAlignment = NSTextAlignmentCenter;
        view.text = obj;
        view.backgroundColor = [UIColor cyanColor];
        view.frame = [cal cellFrameWithIndex:idx];
        [[UIApplication sharedApplication].delegate.window addSubview:view];
    }];
}

@end
