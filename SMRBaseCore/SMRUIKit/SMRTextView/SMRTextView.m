//
//  SMRTextView.m
//  SMRBaseCoreDemo
//
//  Created by 丁治文 on 2019/2/19.
//  Copyright © 2019 sumrise. All rights reserved.
//

#import "SMRTextView.h"
#import "SMRAdapter.h"
#import "PureLayout.h"

@interface SMRTextView () <
UITextViewDelegate>

@property (nonatomic, assign) BOOL didSetupConstraints;

@end

@implementation SMRTextView

@synthesize contentTextView = _contentTextView;
@synthesize placeHolderLabel = _placeHolderLabel;
@synthesize countLabel = _countLabel;

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _maxLength = 500;
        _countFormat = @"(c / a)";
        _contentInsets = [SMRUIAdapter insets:UIEdgeInsetsMake(15, 15, 15, 15)];
        [self createSMRTextViewSubviews];
        [self setNeedsUpdateConstraints];
    }
    return self;
}

- (void)createSMRTextViewSubviews {
    self.layer.borderColor = [UIColor smr_colorWithHexRGB:@"#999999"].CGColor;
    self.layer.borderWidth = 1.0/[UIScreen mainScreen].scale;
    self.layer.cornerRadius = [SMRUIAdapter value:1.0];

    self.contentTextView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    [self addSubview:self.contentTextView];
    [self addSubview:self.placeHolderLabel];
    [self addSubview:self.countLabel];
}

- (void)updateConstraints {
    if (!self.didSetupConstraints) {
        UIEdgeInsets insets = self.contentInsets;
        CGFloat contentOffset = self.placeHolderLabel.font.pointSize/1.5;
        [self.contentTextView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(insets.top - contentOffset,
                                                                                      insets.left - contentOffset,
                                                                                      insets.bottom - contentOffset,
                                                                                      insets.right - contentOffset)];

        [self.placeHolderLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:insets.top];
        [self.placeHolderLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:insets.left];
        
        [self.countLabel autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:insets.bottom];
        [self.countLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:insets.right];
        
        self.didSetupConstraints = YES;
    }
    [super updateConstraints];
}

#pragma mark -- UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView {
    if (textView.text.length == 0) {
        self.placeHolderLabel.hidden = NO;
    } else {
        self.placeHolderLabel.hidden = YES;
    }
    if (textView.text.length > self.maxLength) {
        textView.text = [textView.text substringToIndex:self.maxLength];
    }
    self.countLabel.text = [self p_ountTextWithCount:textView.text.length maxLength:self.maxLength format:self.countFormat];
    // 回调
    if ([self.delegate respondsToSelector:@selector(textView:didChangedWithText:)]) {
        [self.delegate textView:self didChangedWithText:textView.text];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@""]) {
        return YES;
    }
    NSString *willText = [textView.text stringByReplacingCharactersInRange:range withString:text];
    if (willText.length > self.maxLength) {
        textView.text = [willText substringToIndex:self.maxLength];
        self.countLabel.text = [self p_ountTextWithCount:self.maxLength maxLength:self.maxLength format:self.countFormat];
        // 回调
        if ([self.delegate respondsToSelector:@selector(textView:didChangedWithText:)]) {
            [self.delegate textView:self didChangedWithText:textView.text];
        }
        return NO;
    }
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if ([self.delegate respondsToSelector:@selector(textView:didEndEditingWithText:)]) {
        [self.delegate textView:self didEndEditingWithText:textView.text];
    }
}

#pragma mark - Utils

- (NSString *)p_ountTextWithCount:(NSInteger)count maxLength:(NSInteger)maxLength format:(NSString *)format {
    NSString *rtnString = [format stringByReplacingOccurrencesOfString:@"c" withString:[NSString stringWithFormat:@"%@", @(count)]];
    if (maxLength > 0) {
        rtnString = [rtnString stringByReplacingOccurrencesOfString:@"a" withString:[NSString stringWithFormat:@"%@", @(maxLength)]];
    } else {
        rtnString = [rtnString stringByReplacingOccurrencesOfString:@"a" withString:@"∞"];
    }
    return rtnString;
}

#pragma mark - Setters

- (void)setShowCountLabel:(BOOL)showCountLabel {
    _showCountLabel = showCountLabel;
    self.countLabel.hidden = !showCountLabel;
}

- (void)setMaxLength:(NSInteger)maxLength {
    _maxLength = maxLength;
    self.countLabel.text = [self p_ountTextWithCount:self.contentTextView.text.length maxLength:self.maxLength format:self.countFormat];
}

#pragma mark - Getters

- (NSString *)text {
    return self.contentTextView.text;
}

- (UILabel *)placeHolderLabel {
    if (_placeHolderLabel == nil) {
        _placeHolderLabel = [[UILabel alloc] init];
        _placeHolderLabel.textColor = [UIColor grayColor];
        _placeHolderLabel.font = [UIFont systemFontOfSize:12];
        _placeHolderLabel.textAlignment = NSTextAlignmentLeft;
        _placeHolderLabel.numberOfLines = 0;
    }
    return _placeHolderLabel;
}

- (UITextView *)contentTextView {
    if (_contentTextView == nil) {
        _contentTextView = [[UITextView alloc] init];
        _contentTextView.delegate = self;
        _contentTextView.scrollEnabled = YES;
        _contentTextView.textAlignment = NSTextAlignmentLeft;
        _contentTextView.textColor = [UIColor smr_colorWithHexRGB:@"#333333"];
        _contentTextView.font = [UIFont smr_systemFontOfSize:12.0];
    }
    return _contentTextView;
}

- (UILabel *)countLabel {
    if (_countLabel == nil) {
        _countLabel = [[UILabel alloc] init];
        _countLabel.textColor = [UIColor smr_colorWithHexRGB:@"#333333"];
        _countLabel.font = [UIFont smr_systemFontOfSize:10];
        _countLabel.text = [self p_ountTextWithCount:0 maxLength:_maxLength format:_countFormat];
        _countLabel.hidden = YES;
    }
    return _countLabel;
}

@end
