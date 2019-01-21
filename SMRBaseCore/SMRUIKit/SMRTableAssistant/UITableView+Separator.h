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
 
 符号:
 -:连续,表示从正数或者倒数至某一行的连续位置
 ,:分隔符号
 
 位置:
 正整数:如13,表示从当前section数第13行的位置
 如-13,表示从上至下的13行的所有位置
 `正整数:如`23,表示从当前section倒数第23行的位置
 如`23-,表示从下至上的23行的所有位置
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
 "-L2,F3,Ln,F`4,L`3-",表示:第1-2行为L,第3行为F,第4行到倒数5(=4+1)行为L,倒数第4行为F,最后3行为L
 "Fn:L1.2",表示:第1-2行为L,第3行为F,第4行到倒数5(=4+1)行为L,倒数第4行为F,最后3行为L
 
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


@end
