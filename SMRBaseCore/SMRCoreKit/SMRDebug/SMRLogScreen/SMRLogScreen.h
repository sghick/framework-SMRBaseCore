//
//  SMRLogScreen.h
//  SMRLogScreenDemo
//
//  Created by 丁治文 on 2018/10/1.
//  Copyright © 2018年 sumrise.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SMRLogScreen : NSObject

/// log保存的最多条数(与linebreak无关),默认10000条,超出后每次会全部清除
@property (nonatomic, assign) NSUInteger maxNumberOfLine;
@property (nonatomic, strong) UIView *view;
/// 默认:YES,当view展示出来时,才会输入line的内容
@property (nonatomic, assign) BOOL enableOnlyWhenShow;

+ (instancetype)sharedScreen;

+ (void)show;
+ (void)hide;

+ (void)addLine:(NSString *)line linebreak:(BOOL)linebreak;
+ (void)addLine:(NSString *)line linebreak:(BOOL)linebreak groupLabel:(NSString *)groupLabel;
+ (void)clear;

@end
