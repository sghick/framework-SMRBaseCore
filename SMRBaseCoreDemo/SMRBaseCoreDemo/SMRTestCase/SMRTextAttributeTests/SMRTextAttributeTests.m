//
//  SMRTextAttributeTests.m
//  SMRBaseCoreDemo
//
//  Created by Tinswin on 2020/4/7.
//  Copyright © 2020 sumrise. All rights reserved.
//

#import "SMRTextAttributeTests.h"
#import "PureLayout.h"
#import "SMRCommon.h"

@implementation SMRTextAttributeTests

- (id)begin {
    [self text_markAttributes];
    return self;
}

#pragma mark - Privates

- (UIScrollView *)displayScrollView {
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, SCREEN_HEIGHT - 20)];
    [[UIApplication sharedApplication].delegate.window addSubview:scrollView];
    return scrollView;
}

- (UILabel *)displayLabelWithText:(NSString *)text below:(nullable UIView *)below systemSize:(BOOL)systemSize inView:(UIView *)inView {
    SMRTextAttribute *attr = [self textAttribute];
    CGSize fitSize = CGSizeMake(SCREEN_WIDTH - 20, CGFLOAT_MAX);
    
    UILabel *label = [[UILabel alloc] init];
    label.attributedText = [attr attributedStringWithText:text];
    label.numberOfLines = 0;
    [inView addSubview:label];
    CGSize autoSize = CGSizeZero;
    if (systemSize) {
        label.backgroundColor = [UIColor smr_deepOrangeColor];
        autoSize = [label systemLayoutSizeFittingSize:fitSize];
    } else {
        label.backgroundColor = [UIColor smr_whiteColor];
        autoSize = [attr sizeOfText:text fitSize:fitSize];
    }
    NSLog(@"systemSize:%@,size:%@", @(systemSize), NSStringFromCGSize(autoSize));
    if (below) {
        [label autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:below withOffset:[SMRUIAdapter value:5]];
    } else {
        [label autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:30];
    }
    [label autoAlignAxisToSuperviewAxis:ALAxisVertical];
//    [label autoSetDimension:ALDimensionHeight toSize:autoSize.height];
//    [label autoSetDimension:ALDimensionWidth toSize:autoSize.width];
    [label autoSetDimensionsToSize:autoSize];
//    label.preferredMaxLayoutWidth = fitSize.width;
    return label;
}

- (UILabel *)displayLabelWithText:(NSString *)text markText:(NSString *)markText below:(nullable UIView *)below systemSize:(BOOL)systemSize inView:(UIView *)inView {
    SMRTextAttribute *attr = [[SMRTextAttribute alloc] init];
    attr.color = [UIColor smr_generalBlackColor];
    attr.font = [UIFont systemFontOfSize:18];
    
    SMRTextAttribute *markAttr = [[SMRTextAttribute alloc] init];
    markAttr.color = [UIColor smr_generalRedColor];
    markAttr.font = [UIFont systemFontOfSize:22];
    
    CGSize fitSize = CGSizeMake(SCREEN_WIDTH - 20, CGFLOAT_MAX);
    
    UILabel *label = [[UILabel alloc] init];
    label.attributedText = [attr attributedStringWithText:text markText:markText markTextAttribute:markAttr];
    label.numberOfLines = 0;
    [inView addSubview:label];
    CGSize autoSize = CGSizeZero;
    if (systemSize) {
        label.backgroundColor = [UIColor smr_deepOrangeColor];
        autoSize = [label systemLayoutSizeFittingSize:fitSize];
    } else {
        label.backgroundColor = [UIColor smr_generalOrangeColor];
        autoSize = [attr sizeOfText:text fitSize:fitSize];
    }
    NSLog(@"systemSize:%@,size:%@", @(systemSize), NSStringFromCGSize(autoSize));
    if (below) {
        [label autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:below withOffset:[SMRUIAdapter value:5]];
    } else {
        [label autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:30];
    }
    [label autoAlignAxisToSuperviewAxis:ALAxisVertical];
//    [label autoSetDimension:ALDimensionHeight toSize:autoSize.height];
//    [label autoSetDimension:ALDimensionWidth toSize:autoSize.width];
//    [label autoSetDimensionsToSize:autoSize];
    label.preferredMaxLayoutWidth = fitSize.width;
    return label;
}

- (SMRTextAttribute *)textAttribute {
    SMRTextAttribute *attr = [[SMRTextAttribute alloc] init];
    attr.color = [UIColor redColor];
    attr.font = [UIFont systemFontOfSize:18];
    attr.lineSpacing = 10;
//    attr.lineBreakMode = NSLineBreakByCharWrapping;
//    attr.underlineStyle = NSUnderlineStyleThick;
//    attr.strikethroughStyle = NSUnderlineStyleThick;
//    attr.maximumLineHeight = 25;
//    attr.minimumLineHeight = 10 + (NSInteger)(attr.font.lineHeight);
//    attr.baselineOffset = 10/4.0;
//    attr.alignment = NSTextAlignmentRight;
//    attr.backgroundColor = [UIColor smr_backgroundGrayColor];
    return attr;
}

#pragma mark -

// 创建一套属性字符串
- (void)text_createAttributes {
    NSString *text1 = @"创建一套属性字符串==>";
    NSString *text2 = @"创建一套属性字符串==>\n测试房价下跌也没有那么新鲜哪";
    NSString *text3 = @"创建一套属性字符串==>\n测试房价下跌也没有那么新鲜哪个城市房价都有下跌的时候，但是这次全部一线城市无论是同比还是环比都下跌了。\n中国房地产协会主办的全国房价行情数据显示，有121个城市3月份二手房价环比2月份下跌。";
    
    
    UIScrollView *scrollView = [self displayScrollView];
    UILabel *label1 = nil;
    UILabel *label2 = nil;
    UILabel *label3 = nil;
    UILabel *label4 = nil;
    UILabel *label5 = nil;
    UILabel *label6 = nil;
    label1 = [self displayLabelWithText:text1 below:nil systemSize:YES inView:scrollView];
    label2 = [self displayLabelWithText:text1 below:label1 systemSize:NO inView:scrollView];
    label3 = [self displayLabelWithText:text2 below:label2 systemSize:YES inView:scrollView];
    label4 = [self displayLabelWithText:text2 below:label3 systemSize:NO inView:scrollView];
    label5 = [self displayLabelWithText:text3 below:label4 systemSize:YES inView:scrollView];
    label6 = [self displayLabelWithText:text3 below:label5 systemSize:NO inView:scrollView];
    
    [scrollView layoutIfNeeded];
    scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, label6.bottom);
}

// 创建一套属性字符串,并进行标记
- (void)text_markAttributes {
    NSString *markText = @"房价下跌";
    NSString *text = [NSString stringWithFormat:@"创建一套属性字符串==>\n测试%@也没有那么新鲜哪", markText];
    
    SMRTextAttribute *attr = [[SMRTextAttribute alloc] init];
    attr.color = [UIColor smr_generalBlackColor];
    attr.font = [UIFont systemFontOfSize:18];
    
    SMRTextAttribute *markAttr = [[SMRTextAttribute alloc] init];
    markAttr.color = [UIColor smr_generalRedColor];
    markAttr.font = [UIFont systemFontOfSize:22];
    
    NSAttributedString *attrString =
    [attr attributedStringWithText:text markText:markText markTextAttribute:markAttr];
    
    UIScrollView *scrollView = [self displayScrollView];
    UILabel *label1 = nil;
    UILabel *label2 = nil;
    label1 = [self displayLabelWithText:text markText:markText below:nil systemSize:NO inView:scrollView];
    label2 = [self displayLabelWithText:text markText:markText below:label1 systemSize:YES inView:scrollView];
    
    [scrollView layoutIfNeeded];
    scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, label2.bottom);
}

@end
