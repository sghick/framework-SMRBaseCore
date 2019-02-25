//
//  SMRTextView.h
//  SMRBaseCoreDemo
//
//  Created by 丁治文 on 2019/2/19.
//  Copyright © 2019 sumrise. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class SMRTextView;
@protocol SMRTextViewDelegate <NSObject>

- (void)textView:(SMRTextView *)textView didChangedWithText:(NSString *)text;
- (void)textView:(SMRTextView *)textView didEndEditingWithText:(NSString *)text;

@end

@interface SMRTextView : UIView

/** 内容缩进,默认{15, 15, 15, 15} */
@property (assign, nonatomic) UIEdgeInsets contentInsets;
/** 最多字数, 小于等于0表示不限制, 默认500 */
@property (assign, nonatomic) NSInteger maxLength;
/** 计数区域格式:"(c / a)",如:(12 / 55) */
@property (strong, nonatomic) NSString *countFormat;
/** 是否展示计数标签,默认NO */
@property (assign, nonatomic) BOOL showCountLabel;

/** 获取text文本 */
@property (copy  , nonatomic, readonly) NSString *text;

@property (strong, nonatomic, readonly) UITextView *contentTextView;
@property (strong, nonatomic, readonly) UILabel *placeHolderLabel;
@property (strong, nonatomic, readonly) UILabel *countLabel;

@property (weak  , nonatomic) id<SMRTextViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
