//
//  SMRIndexView.h
//  SMRBaseCoreDemo
//
//  Created by 丁治文 on 2019/3/8.
//  Copyright © 2019 sumrise. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SMRIndexView;

@protocol SMRIndexViewDataSource

@required
/** 返回index的标题 */
- (NSArray *)sectionIndexTitlesForIndexView:(SMRIndexView *)indexView;
/** 选择索引的事件触发 */
- (void)indexView:(SMRIndexView *)indexView selectedTitle:(NSString *)title atIndex:(NSInteger)index;

@end


@interface SMRIndexView : UIControl

@property (nonatomic, weak) id <SMRIndexViewDataSource> dataSource;

/** 所有颜色请不要使用 whiteColor, blackColor, grayColor or colorWithWhite, colorWithHue */

/** 如果您想在手势变换时就响应点击事件,请设置为NO,默认:YES */
@property (nonatomic, assign) BOOL getSelectedItemsAfterPanGestureIsFinished;

/** 设置字体,如果字体太大,将会以自适应的方式显示,默认:HelveticaNeue 15.0 points */
@property (nonatomic, strong) UIFont *font;

/** 设置选中的字体,如果字体太大,将会以自适应的方式显示,默认:HelveticaNeue 40.0 points */
@property (nonatomic, strong) UIFont *selectedItemFont;

/** 设置字体颜色 */
@property (nonatomic, strong) UIColor *fontColor;

/** 设置选中字体颜色 */
@property (nonatomic, strong) UIColor *selectedItemFontColor;

/** 如果您想显示手指两旁的索引,请设置为NO,默认:YES */
@property (nonatomic, assign) BOOL darkening;

/** 如果您想把手指两旁的索引变为不透明,请设置为NO,默认:YES */
@property (nonatomic, assign) BOOL fading;

/** 设置索引的水平位置,默认:居中 */
@property (nonatomic, assign) NSTextAlignment itemsAligment;

/** 设置索引的右边距,默认:10.0 points */
@property (nonatomic, assign) CGFloat rightMargin;

/** 设置索引的上边距,默认:20.0 points,可能会因此影响字体大小 */
@property (nonatomic, assign) CGFloat upperMargin;

/** 设置索引的下边距,默认:20.0 points,可能会因此影响字体大小 */
@property (nonatomic, assign) CGFloat lowerMargin;

/** 设置选中索引最大偏移,默认:75.0 points */
@property (nonatomic, assign) CGFloat maxItemDeflection;

/** 设置选中索引单边偏移个数,默认:3 */
@property (nonatomic, assign) int rangeOfDeflection;

/** 设置索引的背景,默认:nil */
@property (nonatomic, strong) UIColor *curtainColor;

/** 设置索引的背景的褪变度(0-1),默认:0.2 */
@property (nonatomic, assign) CGFloat curtainFade;

/** 如果您想显示背景,请设置为YES,默认:NO */
@property (nonatomic, assign) BOOL curtainStays;

/** 如果您想在手势期间背景变化,请设置为YES,默认:NO */
@property (nonatomic, assign) BOOL curtainMoves;

/** 如果您想显示上下完整的背景,请设置为YES,默认:NO */
@property (nonatomic, assign) BOOL curtainMargins;

/** 设置索引的间隙,默认:5.0 */
@property (nonatomic, assign) CGFloat minimumGapBetweenItems;

/** 设置索引自动间隙和位置,YES时,upperMargin和lowerMargin属性无效,默认:YES */
@property BOOL ergonomicHeight;

/** 设置索引总高度,如果ergonomicHeight为YES,这个可能在iPad中有用,默认:400.0 points */
@property (nonatomic, assign) CGFloat maxValueForErgonomicHeight;

/** 刷新索引 */
- (void)refreshIndexItems;

@end
