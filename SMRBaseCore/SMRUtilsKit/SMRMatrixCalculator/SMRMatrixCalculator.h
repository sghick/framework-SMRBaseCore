//
//  SMRMatrixCalculator.h
//  SMRBaseCoreDemo
//
//  Created by 丁治文 on 2019/2/1.
//  Copyright © 2019 sumrise. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef struct SMRMatrix {
    NSUInteger index;       ///< 线性结构的索引下标
    NSUInteger columnCount; ///< 矩阵每行的个数
    NSUInteger row;         ///< 矩阵行下标
    NSUInteger column;      ///< 矩阵列下标
} SMRMatrix;
/** 判断是否相等 */
NS_INLINE bool SMRMatrixEqualToMatrix(SMRMatrix matrix1, SMRMatrix matrix2) {
    bool rtn =
    (matrix1.index == matrix2.index) &&
    (matrix1.columnCount == matrix2.columnCount) &&
    (matrix1.row == matrix2.row) &&
    (matrix1.column == matrix2.column);
    return rtn;
}
/** 将线性结构转换成矩阵结构,当index传count-1值时,得到的row+1值为总行数 */
NS_INLINE SMRMatrix SMRMatrixMake(NSUInteger index, NSUInteger columnCount) {
    SMRMatrix matrix;
    matrix.index = index;
    matrix.columnCount = columnCount;
    matrix.row = (index + columnCount)/columnCount - 1;
    matrix.column = index%columnCount;
    return matrix;
}
/** 将线性结构转换成矩阵结构时,总行数的获取 */
NS_INLINE NSUInteger SMRMatrixGetCount(NSUInteger count, NSUInteger columnCount) {
    SMRMatrix all = SMRMatrixMake(count - 1, columnCount);
    return all.row + 1;
};
/** 获取矩阵在线性位置中的range */
NS_INLINE NSString *NSStringFromMatrix(SMRMatrix matrix) {
    NSString *string = [NSString stringWithFormat:@"{%@, %@, %@, %@}",
    @(matrix.index), @(matrix.columnCount), @(matrix.row), @(matrix.column)];
    return string;
}
/** 获取矩阵在线性位置中的range */
NS_INLINE NSRange SMRMatrixGetRange(NSUInteger row, NSUInteger count, NSUInteger columnCount) {
    NSUInteger location = row*columnCount;
    if (location > (count - 1)) {
        return NSMakeRange(0, 0);
    }
    NSUInteger exCount = count - location;
    NSUInteger length = (exCount < columnCount) ? exCount : columnCount;
    NSRange range = NSMakeRange(location, length);
    return range;
}

typedef NS_ENUM(NSInteger, SMRMatrixCalculatorType) {
    SMRMatrixCalculatorTypeVertical     = 0,    ///< 纵向矩阵
    SMRMatrixCalculatorTypeHorizontal   = 1,    ///< 横向矩阵
};

/**
 矩阵布局计算器,模型的下标位置等都以0开始,目前仅支持横向计算
 */
@interface SMRMatrixCalculator : NSObject

@property (assign, nonatomic) SMRMatrixCalculatorType type; ///< 矩阵类型
@property (assign, nonatomic) CGRect bounds;    ///< 矩阵的位置
@property (assign, nonatomic) CGSize cellSize;  ///< 每个单位的size

@property (assign, nonatomic) NSUInteger columnsCount;  ///< 矩阵列数,纵向矩阵时需要
@property (assign, nonatomic) NSUInteger rowsCount;     ///< 矩阵行数,横向矩阵时需要
@property (assign, nonatomic) CGFloat spaceOfColumn;    ///< 列间距,纵向计算时,默认使用均等分布时的列间距,否则默认0
@property (assign, nonatomic) CGFloat spaceOfRow;       ///< 行间距,横向计算时,默认使用均等分布时的行间距,否则默认0

/** 初始化一个矩阵 */
- (instancetype)initWithType:(SMRMatrixCalculatorType)type;

/** 纵向矩阵计算 */
+ (instancetype)calculatorForVerticalWithBounds:(CGRect)bounds
                                   columnsCount:(NSUInteger)columnsCount
                                     spaceOfRow:(CGFloat)spaceOfRow
                                       cellSize:(CGSize)cellSize;

/** 横向矩阵计算 */
+ (instancetype)calculatorForHorizontalWithBounds:(CGRect)bounds
                                        rowsCount:(NSUInteger)rowsCount
                                    spaceOfColumn:(CGFloat)spaceOfColumn
                                         cellSize:(CGSize)cellSize;

/** 计算底部位置 */
- (CGFloat)bottomWithIndex:(NSInteger)index;

/** 计算右边位置 */
- (CGFloat)rightWithIndex:(NSInteger)index;

/** 根据序号计算每个cell的frame */
- (CGRect)cellFrameWithIndex:(NSInteger)index;

/** 计算行列起始位置 */
- (CGPoint)cellOriginWithIndex:(NSInteger)index;

/** 计算行列下标值,如{0,0}表示第0行,第0列 */
- (CGPoint)cellSubscriptWithIndex:(NSInteger)index;

/** 均等分布时的列间距 */
- (CGFloat)spaceOfColumnForEqualization;

@end

NS_ASSUME_NONNULL_END
