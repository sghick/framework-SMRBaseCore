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
    NSUInteger index;  ///< 线性索引
    NSUInteger length; ///< 矩阵长度
    NSUInteger x;      ///< 矩阵x
    NSUInteger y;      ///< 矩阵y
} SMRMatrix;
/** 判断是否相等 */
NS_INLINE bool SMRMatrixEqualToMatrix(SMRMatrix matrix1, SMRMatrix matrix2) {
    bool rtn =
    (matrix1.index == matrix2.index) &&
    (matrix1.length == matrix2.length) &&
    (matrix1.x == matrix2.x) &&
    (matrix1.y == matrix2.y);
    return rtn;
}
/** 将线性结构转换成矩阵结构 */
NS_INLINE SMRMatrix SMRMatrixMake(NSUInteger index, NSUInteger length) {
    SMRMatrix matrix;
    matrix.index = index;
    matrix.length = length;
    matrix.x = (index + length)/length - 1;
    matrix.y = index%length;
    return matrix;
}
NS_INLINE SMRMatrix SMRMatrixMakeHorizontal(NSUInteger index, NSUInteger length) {
    SMRMatrix matrix;
    matrix.index = index;
    matrix.length = length;
    matrix.x = index%length;
    matrix.y = (index + length)/length - 1;
    return matrix;
}
/** 获取矩阵在线性位置中的range */
NS_INLINE NSString *NSStringFromMatrix(SMRMatrix matrix) {
    NSString *string = [NSString stringWithFormat:@"{%@, %@, %@, %@}",
                        @(matrix.index), @(matrix.length), @(matrix.x), @(matrix.y)];
    return string;
}
/** 获取当前矩阵元在线性结构中的位置 */
NS_INLINE NSRange SMRMatrixGetRangeFromMatrix(SMRMatrix matrix) {
    NSRange range = NSMakeRange(matrix.x*matrix.length, matrix.length);
    return range;
}
/** 获取矩阵在线性位置中的range */
NS_INLINE NSRange SMRMatrixGetRange(NSUInteger groupX, NSUInteger groupY, NSUInteger length) {
    NSRange range = NSMakeRange(groupX*length, groupY);
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
