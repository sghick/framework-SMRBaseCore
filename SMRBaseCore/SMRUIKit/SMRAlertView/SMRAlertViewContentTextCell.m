//
//  SMRAlertViewContentTextCell.m
//  SMRBaseCoreDemo
//
//  Created by 丁治文 on 2019/2/14.
//  Copyright © 2019 sumrise. All rights reserved.
//

#import "SMRAlertViewContentTextCell.h"
#import "SMRAdapter.h"
#import "PureLayout.h"
#import "SMRLinkLabel.h"
#import "SMRUtils+MBProgressHUD.h"
#import "SMRUtils+Jump.h"

@interface SMRAlertViewContentTextCell ()<
SMRLinkLabelDelegate>

@property (strong, nonatomic) SMRLinkLabel *contentLabel;
@property (assign, nonatomic) BOOL didLoadLayout;

@end

@implementation SMRAlertViewContentTextCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [self.contentView addSubview:self.contentLabel];
    [self setNeedsUpdateConstraints];
}

- (void)updateConstraints {
    if (!self.didLoadLayout) {
        self.didLoadLayout = YES;
        [self.contentLabel autoPinEdgesToSuperviewEdges];
    }
    [super updateConstraints];
}

#pragma mark - SMRLinkLabelDelegate

- (void)attributedLabel:(SMRLinkLabel *)label didSelectLinkWithPhoneNumber:(NSString *)phoneNumber {
    if ([self.delegate respondsToSelector:@selector(alertTextCell:didSelectLinkWithPhoneNumber:)]) {
        [self.delegate alertTextCell:self didSelectLinkWithPhoneNumber:phoneNumber];
    }
}

- (void)attributedLabel:(SMRLinkLabel *)label didSelectLinkWithURL:(NSURL *)url {
    if ([self.delegate respondsToSelector:@selector(alertTextCell:didSelectLinkWithURL:)]) {
        [self.delegate alertTextCell:self didSelectLinkWithURL:url];
    }
}

#pragma mark - Utils

- (void)addLinkToURL:(NSURL *)url withRange:(NSRange)range {
    [self.contentLabel addLinkToURL:url withRange:range];
}

+ (NSAttributedString *)attributeStringWithAttributedContent:(NSAttributedString *)attributedContent alignment:(NSTextAlignment)alignment {
    NSMutableAttributedString *attributeContentString = [[NSMutableAttributedString alloc] initWithString:attributedContent.string];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:[SMRUIAdapter value:6]];
    [paragraphStyle setAlignment:alignment];
    [attributeContentString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, attributedContent.length)];
    [attributeContentString addAttribute:NSFontAttributeName value:[UIFont smr_systemFontOfSize:16.0] range:NSMakeRange(0, attributedContent.length)];
    [attributeContentString addAttribute:NSForegroundColorAttributeName value:[UIColor smr_colorWithHexRGB:@"#333333"] range:NSMakeRange(0, attributedContent.length)];
    
    [attributedContent enumerateAttributesInRange:NSMakeRange(0, attributedContent.length) options:NSAttributedStringEnumerationReverse usingBlock:^(NSDictionary<NSString *,id> * _Nonnull attrs, NSRange range, BOOL * _Nonnull stop) {
        [attributeContentString addAttributes:attrs range:range];
    }];
    
    return attributeContentString;
}

+ (CGFloat)heightOfCellWithAttributeText:(NSAttributedString *)attributeText fitWidth:(CGFloat)fitWidth {
    SMRAlertViewContentTextCell *cell = [[SMRAlertViewContentTextCell alloc] init];
    cell.attributeText = attributeText;
    CGFloat height = [cell.contentLabel systemLayoutSizeFittingSize:CGSizeMake(fitWidth, CGFLOAT_MAX)].height;
    if (@available(iOS 13.0, *)) {
        // None
    } else {
        // fix:iOS12的系统cell的精度会因为特殊字符'~'而有损失
        height = height + 1;
    }
    return height;
}

#pragma mark - Setters

- (void)setAttributeText:(NSAttributedString *)attributeText {
    _attributeText = attributeText;
    self.contentLabel.text = attributeText.string;
    self.contentLabel.attributedText = [SMRAlertViewContentTextCell attributeStringWithAttributedContent:attributeText alignment:NSTextAlignmentCenter];
}

- (void)setMaxLayoutWidth:(CGFloat)maxLayoutWidth {
    self.contentLabel.preferredMaxLayoutWidth = maxLayoutWidth;
}

- (void)setAlignment:(NSTextAlignment)alignment {
    self.contentLabel.textAlignment = alignment;
}

#pragma mark - Getters

- (SMRLinkLabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [[SMRLinkLabel alloc] initWithFrame:CGRectZero];
        _contentLabel.numberOfLines = 0;
        _contentLabel.lineBreakMode = NSLineBreakByCharWrapping;
        _contentLabel.delegate = self;
        _contentLabel.enabledTextCheckingTypes = NSTextCheckingTypeLink|NSTextCheckingTypePhoneNumber;
        _contentLabel.delegate = self;
        _contentLabel.linkAttributes = @{NSForegroundColorAttributeName:[UIColor blueColor],
                                         NSUnderlineStyleAttributeName:[NSNumber numberWithInteger:NSUnderlineStyleSingle]};
    }
    return _contentLabel;
}

@end
