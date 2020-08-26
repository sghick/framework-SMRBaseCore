//
//  SMRMatrixTests.m
//  SMRBaseCoreDemo
//
//  Created by 丁治文 on 2019/9/6.
//  Copyright © 2019 sumrise. All rights reserved.
//

#import "SMRMatrixTests.h"
#import "SMRMatrixCalculator.h"

@implementation SMRMatrixTests

- (id)begin {
    [self testTableRectal];
    [self testCalculator];
    return self;
}

- (void)testTableRectal {
    NSInteger length = 4;// 每行个数
    NSInteger count = 10;
    for (int i = 0; i < count; i++) {
        SMRMatrix matrix = SMRMatrixMake(i, length);
        NSLog(@"matrix:%@", NSStringFromMatrix(matrix));
    }
    NSUInteger rowCount = SMRMatrixGetCount(count, length);
    NSLog(@"总行数:%@", @(rowCount));
    for (int i = 0; i < rowCount; i++) {
        NSLog(@"每行A:%@", NSStringFromRange(SMRMatrixGetRange(i, count, length)));
    }
    NSLog(@"超出:%@", NSStringFromRange(SMRMatrixGetRange(rowCount, count, length)));
}

- (void)testCalculator {
    NSInteger length = 4;
    SMRMatrixCalculator *calculator = [SMRMatrixCalculator calculatorForVerticalWithBounds:CGRectZero
                                                                              columnsCount:length
                                                                                spaceOfRow:0
                                                                                  cellSize:CGSizeZero];
    
//    SMRMatrixCalculator *calculator = [SMRMatrixCalculator calculatorForHorizontalWithBounds:CGRectZero
//                                                                                   rowsCount:length
//                                                                               spaceOfColumn:0
//                                                                                    cellSize:CGSizeZero];
    for (int i = 0; i < 10; i++) {
        CGPoint point = [calculator cellSubscriptWithIndex:i];
        NSLog(@"%@, %@", @(i), NSStringFromCGPoint(point));
    }
}

@end
