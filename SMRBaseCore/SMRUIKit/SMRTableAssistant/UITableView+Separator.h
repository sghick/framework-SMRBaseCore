//
//  UITableView+Separator.h
//  SeperatorLine
//
//  Created by 丁治文 on 16/7/11.
//  Copyright © 2016年 丁治文. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 format格式:
 
 说明:以下所有下标请以0开始计算
     正数计算时:数组下标值,如{2,3},表示正数下标为2的位置,往后数3个的范围;
     倒数计算时:为正常数值,如-{3,2},表示倒第3行开始,往前数2个的范围.
 
 符号:
 -:倒数:倒数位置
 |:分隔符号
 {:NSRange的开始
 }:NSRange的结束
 ,:NSRange的分隔
 n:缺省位置
 
 位置:
 {a}:NSRange范围,{a,0}
 {a,b}:NSRange范围,{a,b}
 n:表示从左至右,下一个开始的任意连续位置,(n在一个format中最多只有一个,可以默认不写,则其它位置是默认无线的样式)
 
 样式:
 F:长线的样式,默认样式
 O:无线的样式
 L:带左margin的样式
 R:带右margin的样式
 C:带左右margin的样式
 
 组合:
 每个row由 "样式"+"位置" 构成, 以","分隔
 
 示例:
 "Fn",表示:全部为F样式
 "Ln|L2|F3|F-4|L-3",表示:第2行为L,第3行为F,倒数第4行为F,最后3行为L,其他的为L
 "Cn|R{0,2}|F3|F-{3,2}|L-1",表示:第0行到第2行为R,第3行为F,倒数第3行至倒数第4行2个行为F,最后一行为L,其他的为C

 [补充]以上格式中以分隔符'|'分隔的单位,与顺序无关,但顺序的不同可能会对执行时间产生细微的影响.
 [推荐]估计占某种样式最多的,请尽量往前写.
      带n的格式块写在最前.
 */

/// On
extern NSString * const SMRSeperatorsFormatAllNone;
/// Fn
extern NSString * const SMRSeperatorsFormatAllLong;
/// Ln
extern NSString * const SMRSeperatorsFormatAllLeftLess;
/// Rn
extern NSString * const SMRSeperatorsFormatAllRightLess;
/// Cn
extern NSString * const SMRSeperatorsFormatAllCenterLess;

@interface UITableView (Separator)

@property (nonatomic, assign) CGFloat leftMargin;///< default:10
@property (nonatomic, assign) CGFloat rightMargin;///< default:10

/**
 *  标记使用自定义type的线,并隐藏系统多余的线条(必须)
 *  推荐写在初始化方法中
 */
- (void)smr_markCustomTableViewSeparators;

/**
 以相应格式创建分隔线
 推荐写在下面方法中(必须)
 - (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath;
 @param format 参照以上说明
 */
- (void)smr_setSeparatorsWithFormat:(NSString *)format cell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath;

/**
 隐藏底部额外的线
 */
- (void)smr_setExtraCellLineHidden;

@end
