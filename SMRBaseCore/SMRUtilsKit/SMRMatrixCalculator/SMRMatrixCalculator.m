//
//  SMRMatrixCalculator.m
//  SMRBaseCoreDemo
//
//  Created by 丁治文 on 2019/2/1.
//  Copyright © 2019 sumrise. All rights reserved.
//

#import "SMRMatrixCalculator.h"

@implementation SMRMatrixCalculator

- (instancetype)init {
    self = [super init];
    if (self) {
        _spaceOfRow = CGFLOAT_MIN;
        _spaceOfColumn = CGFLOAT_MIN;
    }
    return self;
}

- (instancetype)initWithType:(SMRMatrixCalculatorType)type {
    self = [self init];
    if (self) {
        _type = type;
    }
    return self;
}

+ (instancetype)calculatorForVerticalWithBounds:(CGRect)bounds
                                   columnsCount:(NSUInteger)columnsCount
                                     spaceOfRow:(CGFloat)spaceOfRow
                                       cellSize:(CGSize)cellSize {
    SMRMatrixCalculator *calculator = [[SMRMatrixCalculator alloc] initWithType:SMRMatrixCalculatorTypeVertical];
    calculator.bounds = bounds;
    calculator.columnsCount = columnsCount;
    calculator.spaceOfRow = spaceOfRow;
    calculator.cellSize = cellSize;
    return calculator;
}

+ (instancetype)calculatorForHorizontalWithBounds:(CGRect)bounds
                                        rowsCount:(NSUInteger)rowsCount
                                    spaceOfColumn:(CGFloat)spaceOfColumn
                                         cellSize:(CGSize)cellSize {
    SMRMatrixCalculator *calculator = [[SMRMatrixCalculator alloc] initWithType:SMRMatrixCalculatorTypeHorizontal];
    calculator.bounds = bounds;
    calculator.rowsCount = rowsCount;
    calculator.spaceOfColumn = spaceOfColumn;
    calculator.cellSize = cellSize;
    return calculator;
}

- (CGRect)cellFrameWithIndex:(NSInteger)index {
    CGRect frame = {[self cellOriginWithIndex:index], self.cellSize};
    return frame;
}

- (CGPoint)cellOriginWithIndex:(NSInteger)index {
    CGPoint subscript = [self cellSubscriptWithIndex:index];
    CGFloat x = self.bounds.origin.x + (self.cellSize.width + self.spaceOfColumn)*subscript.y;
    CGFloat y = self.bounds.origin.y + (self.cellSize.height + self.spaceOfRow)*subscript.x;
    CGPoint orgin = CGPointMake(x, y);
    return orgin;
}

- (CGPoint)cellSubscriptWithIndex:(NSInteger)index {
    if (self.type == SMRMatrixCalculatorTypeVertical) {
        /**
         公式1: x = floor(i*1.0/columns)
         公式2: i = columns*x + y
         */
        CGFloat x = floor(index*1.0/self.columnsCount);
        CGFloat y = index - self.columnsCount*x;
        CGPoint point = CGPointMake(x, y);
        return point;
    } else {
        /**
         公式1: y = floor(i*1.0/rows)
         公式2: i = rows*y + x
         */
        CGFloat y = floor(index*1.0/self.rowsCount);
        CGFloat x = index - self.rowsCount*y;
        CGPoint point = CGPointMake(x, y);
        return point;
    }
}

- (CGFloat)spaceOfColumnForEqualization {
    if (self.columnsCount <= 1) {
        return 0;
    }
    CGFloat spaceH = (CGRectGetWidth(self.bounds) - self.cellSize.width*self.columnsCount)/(self.columnsCount - 1);
    return spaceH;
}

- (CGFloat)spaceOfRowsForEqualization {
    if (self.rowsCount <= 1) {
        return 0;
    }
    CGFloat spaceV = (CGRectGetHeight(self.bounds) - self.cellSize.height*self.rowsCount)/(self.rowsCount - 1);
    return spaceV;
}

#pragma mark - Getters

- (CGFloat)spaceOfColumn {
    if (_spaceOfColumn == CGFLOAT_MIN) {
        if (self.type == SMRMatrixCalculatorTypeVertical) {
            _spaceOfColumn = [self spaceOfColumnForEqualization];
        } else {
            _spaceOfColumn = 0;
        }
    }
    return _spaceOfColumn;
}

- (CGFloat)spaceOfRow {
    if (_spaceOfRow == CGFLOAT_MIN) {
        if (self.type == SMRMatrixCalculatorTypeHorizontal) {
            _spaceOfRow = [self spaceOfRowsForEqualization];
        } else {
            _spaceOfRow = 0;
        }
    }
    return _spaceOfRow;
}

@end
