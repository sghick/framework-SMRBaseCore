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

@interface SMRAlertViewContentTextCell ()

@property (strong, nonatomic) UILabel *contentLabel;
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
        [self.contentLabel autoCenterInSuperview];
        [self.contentLabel autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self.contentView];
    }
    [super updateConstraints];
}

#pragma mark - Privates

+ (NSAttributedString *)p_attributeStringWithAttributedContent:(NSAttributedString *)attributedContent {
    NSMutableAttributedString *attributeContentString = [[NSMutableAttributedString alloc] initWithString:attributedContent.string];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:15];
    [paragraphStyle setAlignment:NSTextAlignmentCenter];
    [attributeContentString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, attributedContent.length)];
    [attributeContentString addAttribute:NSFontAttributeName value:[UIFont smr_systemFontOfSize:16.0] range:NSMakeRange(0, attributedContent.length)];
    [attributeContentString addAttribute:NSForegroundColorAttributeName value:[UIColor smr_colorWithHexRGB:@"#333333"] range:NSMakeRange(0, attributedContent.length)];
    
    [attributedContent enumerateAttributesInRange:NSMakeRange(0, attributedContent.length) options:NSAttributedStringEnumerationReverse usingBlock:^(NSDictionary<NSString *,id> * _Nonnull attrs, NSRange range, BOOL * _Nonnull stop) {
        [attributeContentString addAttributes:attrs range:range];
    }];
    
    return attributeContentString;
}

#pragma mark - Utils

+ (CGFloat)heightOfCellWithAttributeText:(NSAttributedString *)attributeText fitWidth:(CGFloat)fitWidth {
    SMRAlertViewContentTextCell *cell = [[SMRAlertViewContentTextCell alloc] init];
    cell.attributeText = attributeText;
    CGFloat height = [cell.contentLabel systemLayoutSizeFittingSize:CGSizeMake(fitWidth, CGFLOAT_MAX)].height;
    return height;
}

+ (NSAttributedString *)defaultAttributeText:(NSString *)text {
    NSAttributedString *attr = [[NSAttributedString alloc] initWithString:text];
    attr = [self p_attributeStringWithAttributedContent:attr];
    return attr;
}

#pragma mark - Setters

- (void)setAttributeText:(NSAttributedString *)attributeText {
    _attributeText = attributeText;
    self.contentLabel.attributedText = [SMRAlertViewContentTextCell p_attributeStringWithAttributedContent:attributeText];
}

#pragma mark - Getters

- (UILabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.numberOfLines = 0;
        _contentLabel.lineBreakMode = NSLineBreakByCharWrapping;
    }
    return _contentLabel;
}

@end
