//
//  SMRTextAttribute.m
//  SMRBaseCoreDemo
//
//  Created by Tinswin on 2020/1/20.
//  Copyright © 2020 sumrise. All rights reserved.
//

#import "SMRTextAttribute.h"
#import <CoreText/CoreText.h>

@interface SMRTextAttribute ()

@property (strong, nonatomic) NSMutableDictionary<NSAttributedStringKey, id> *dict;
@property (strong, nonatomic) NSMutableParagraphStyle *editParagraphStyle;

@end

@implementation SMRTextAttribute

+ (instancetype)textAttribute:(NSAttributedString *)attributedString {
    SMRTextAttribute *textAttr =
    [SMRTextAttribute textAttributeWithDictionary:[attributedString attributesAtIndex:0 effectiveRange:nil]];
    return textAttr;
}

+ (instancetype)textAttributeWithDictionary:(NSDictionary<NSAttributedStringKey,id> *)attributedDictionary {
    SMRTextAttribute *textAttr = [[SMRTextAttribute alloc] init];
    textAttr.dict = [attributedDictionary mutableCopy];
    return textAttr;
}

#pragma mark - Setters

- (void)setFont:(UIFont *)font {
    [self setAttribute:NSFontAttributeName value:font];
}
- (UIFont *)font {
    return [self attributeValueWithName:NSFontAttributeName];
}

- (void)setKern:(CGFloat)kern {
    [self setAttribute:NSKernAttributeName value:@(kern)];
}
- (CGFloat)kern {
    return ((NSNumber *)[self attributeValueWithName:NSKernAttributeName]).doubleValue;
}

- (void)setColor:(UIColor *)color {
    [self setAttribute:(id)kCTForegroundColorAttributeName value:(id)color.CGColor];
    [self setAttribute:NSForegroundColorAttributeName value:color];
}
- (UIColor *)color {
    return [self attributeValueWithName:NSForegroundColorAttributeName];
}

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    [self setAttribute:NSBackgroundColorAttributeName value:backgroundColor];
}
- (UIColor *)backgroundColor {
    return [self attributeValueWithName:NSBackgroundColorAttributeName];
}

- (void)setStrokeWidth:(CGFloat)strokeWidth {
    [self setAttribute:NSStrokeWidthAttributeName value:@(strokeWidth)];
}
- (CGFloat)strokeWidth {
    return ((NSNumber *)[self attributeValueWithName:NSStrokeWidthAttributeName]).doubleValue;
}

- (void)setStrokeColor:(UIColor *)strokeColor {
    [self setAttribute:(id)kCTStrokeColorAttributeName value:(id)strokeColor.CGColor];
    [self setAttribute:NSStrokeColorAttributeName value:strokeColor];
}
- (UIColor *)strokeColor {
    return [self attributeValueWithName:NSStrokeColorAttributeName];
}

- (void)setShadow:(NSShadow *)shadow {
    [self setAttribute:NSShadowAttributeName value:shadow];
}
- (NSShadow *)shadow {
    return [self attributeValueWithName:NSShadowAttributeName];
}

- (void)setStrikethroughStyle:(NSUnderlineStyle)strikethroughStyle {
    [self setAttribute:NSStrikethroughStyleAttributeName value:@(strikethroughStyle)];
}
- (NSUnderlineStyle)strikethroughStyle {
    return ((NSNumber *)[self attributeValueWithName:NSStrikethroughStyleAttributeName]).integerValue;
}

- (void)setStrikethroughColor:(UIColor *)strikethroughColor {
    [self setAttribute:NSStrikethroughColorAttributeName value:strikethroughColor];
}
- (UIColor *)strikethroughColor {
    return [self attributeValueWithName:NSStrikethroughColorAttributeName];
}

- (void)setUnderlineStyle:(NSUnderlineStyle)underlineStyle {
    [self setAttribute:NSUnderlineStyleAttributeName value:@(underlineStyle)];
}
- (NSUnderlineStyle)underlineStyle {
    return ((NSNumber *)[self attributeValueWithName:NSUnderlineStyleAttributeName]).integerValue;
}

- (void)setUnderlineColor:(UIColor *)underlineColor {
    [self setAttribute:(id)kCTUnderlineColorAttributeName value:(id)underlineColor.CGColor];
    [self setAttribute:NSUnderlineColorAttributeName value:underlineColor];
}
- (UIColor *)underlineColor {
    return [self attributeValueWithName:NSUnderlineColorAttributeName];
}

- (void)setLigature:(NSInteger)ligature {
    [self setAttribute:NSLigatureAttributeName value:@(ligature)];
}
- (NSInteger)ligature {
    return ((NSNumber *)[self attributeValueWithName:NSLigatureAttributeName]).integerValue;
}

- (void)setTextEffect:(NSString *)textEffect {
    [self setAttribute:NSTextEffectAttributeName value:textEffect];
}
- (NSString *)textEffect {
    return [self attributeValueWithName:NSTextEffectAttributeName];
}

- (void)setObliqueness:(CGFloat)obliqueness {
    [self setAttribute:NSObliquenessAttributeName value:@(obliqueness)];
}
- (CGFloat)obliqueness {
    return ((NSNumber *)[self attributeValueWithName:NSObliquenessAttributeName]).doubleValue;
}

- (void)setExpansion:(CGFloat)expansion {
    [self setAttribute:NSExpansionAttributeName value:@(expansion)];
}
- (CGFloat)expansion {
    return ((NSNumber *)[self attributeValueWithName:NSExpansionAttributeName]).doubleValue;
}

- (void)setBaselineOffset:(CGFloat)baselineOffset {
    [self setAttribute:NSBaselineOffsetAttributeName value:@(baselineOffset)];
}
- (CGFloat)baselineOffset {
    return ((NSNumber *)[self attributeValueWithName:NSBaselineOffsetAttributeName]).doubleValue;
}

- (void)setVerticalGlyphForm:(BOOL)verticalGlyphForm {
    [self setAttribute:NSVerticalGlyphFormAttributeName value:@(verticalGlyphForm)];
}
- (BOOL)verticalGlyphForm {
    return ((NSNumber *)[self attributeValueWithName:NSVerticalGlyphFormAttributeName]).boolValue;
}

- (void)setLanguage:(NSString *)language {
    [self setAttribute:(id)kCTLanguageAttributeName value:language];
}
- (NSString *)language {
    return [self attributeValueWithName:(id)kCTLanguageAttributeName];
}

- (void)setWritingDirection:(NSArray *)writingDirection {
    [self setAttribute:(id)kCTWritingDirectionAttributeName value:writingDirection];
}
- (NSArray *)writingDirection {
    return [self attributeValueWithName:(id)kCTWritingDirectionAttributeName];
}

- (void)setParagraphStyle:(NSParagraphStyle *)paragraphStyle {
    [self setAttribute:NSParagraphStyleAttributeName value:paragraphStyle];
}
- (NSParagraphStyle *)paragraphStyle {
    return [self attributeValueWithName:NSParagraphStyleAttributeName];
}

#define SMRParagraphStyleSet(_attr_) \
[self beginSetParagraphStyle]._attr_ = _attr_; \
[self endSetParagraphStyle]; \

- (NSMutableParagraphStyle *)beginSetParagraphStyle {
    _editParagraphStyle = [self.paragraphStyle mutableCopy];
    if (!_editParagraphStyle) {
        _editParagraphStyle = [[NSMutableParagraphStyle alloc] init];
    }
    return _editParagraphStyle;
}

- (void)endSetParagraphStyle {
    self.paragraphStyle = [_editParagraphStyle copy];
}

- (void)setAlignment:(NSTextAlignment)alignment {
    SMRParagraphStyleSet(alignment);
}
- (NSTextAlignment)alignment {
    return self.paragraphStyle.alignment;
}

- (void)setBaseWritingDirection:(NSWritingDirection)baseWritingDirection {
    SMRParagraphStyleSet(baseWritingDirection);
}
- (NSWritingDirection)baseWritingDirection {
    return self.paragraphStyle.baseWritingDirection;
}

- (void)setLineSpacing:(CGFloat)lineSpacing {
    SMRParagraphStyleSet(lineSpacing);
}
- (CGFloat)lineSpacing {
    return self.paragraphStyle.lineSpacing;
}

- (void)setParagraphSpacing:(CGFloat)paragraphSpacing {
    SMRParagraphStyleSet(paragraphSpacing);
}
- (CGFloat)paragraphSpacing {
    return self.paragraphStyle.paragraphSpacing;
}

- (void)setParagraphSpacingBefore:(CGFloat)paragraphSpacingBefore {
    SMRParagraphStyleSet(paragraphSpacingBefore);
}
- (CGFloat)paragraphSpacingBefore {
    return self.paragraphStyle.paragraphSpacingBefore;
}

- (void)setFirstLineHeadIndent:(CGFloat)firstLineHeadIndent {
    SMRParagraphStyleSet(firstLineHeadIndent);
}
- (CGFloat)firstLineHeadIndent {
    return self.paragraphStyle.firstLineHeadIndent;
}

- (void)setHeadIndent:(CGFloat)headIndent {
    SMRParagraphStyleSet(headIndent);
}
- (CGFloat)headIndent {
    return self.paragraphStyle.headIndent;
}

- (void)setTailIndent:(CGFloat)tailIndent {
    SMRParagraphStyleSet(tailIndent);
}
- (CGFloat)tailIndent {
    return self.paragraphStyle.tailIndent;
}

- (void)setLineBreakMode:(NSLineBreakMode)lineBreakMode {
    SMRParagraphStyleSet(lineBreakMode);
}
- (NSLineBreakMode)lineBreakMode {
    return self.paragraphStyle.lineBreakMode;
}

- (void)setMinimumLineHeight:(CGFloat)minimumLineHeight {
    SMRParagraphStyleSet(minimumLineHeight);
}
- (CGFloat)minimumLineHeight {
    return self.paragraphStyle.minimumLineHeight;
}

- (void)setMaximumLineHeight:(CGFloat)maximumLineHeight {
    SMRParagraphStyleSet(maximumLineHeight);
}
- (CGFloat)maximumLineHeight {
    return self.paragraphStyle.maximumLineHeight;
}

- (void)setLineHeightMultiple:(CGFloat)lineHeightMultiple {
    SMRParagraphStyleSet(lineHeightMultiple);
}
- (CGFloat)lineHeightMultiple {
    return self.paragraphStyle.lineHeightMultiple;
}

- (void)setHyphenationFactor:(float)hyphenationFactor {
    SMRParagraphStyleSet(hyphenationFactor);
}
- (float)hyphenationFactor {
    return self.paragraphStyle.hyphenationFactor;
}

- (void)setDefaultTabInterval:(CGFloat)defaultTabInterval {
    SMRParagraphStyleSet(defaultTabInterval);
}
- (CGFloat)defaultTabInterval {
    return self.paragraphStyle.defaultTabInterval;
}

- (void)setTabStops:(NSArray *)tabStops {
    SMRParagraphStyleSet(tabStops);
}
- (NSArray<NSTextTab *> *)tabStops {
    return self.paragraphStyle.tabStops;
}

#pragma mark - Utils

- (NSAttributedString *)attributedStringWithText:(NSString *)text {
    return [self attributedStringWithText:text fixLineSpacing:YES];
}

- (NSAttributedString *)attributedStringWithText:(NSString *)text fixLineSpacing:(BOOL)fixLineSpacing {
    if (!text) {
        return nil;
    }
    if (fixLineSpacing) {
        SMRTextAttribute *textAttr = [self p_textAttributeWithFixLineSpaceing];
        return [textAttr p_attributedStringWithText:text];
    } else {
        return [self p_attributedStringWithText:text];
    }
}

- (NSAttributedString *)attributedStringWithText:(NSString *)text markText:(NSString *)markText markTextAttribute:(SMRTextAttribute *)markTextAttribute {
    NSMutableAttributedString *attr = [[self attributedStringWithText:text] mutableCopy];
    NSRange markRange = [text rangeOfString:markText];
    if (markRange.location != NSNotFound) {
        NSAttributedString *markAttr = [markTextAttribute attributedStringWithText:markText];
        [attr replaceCharactersInRange:markRange withAttributedString:markAttr];
    }
    return [attr copy];
}

- (NSAttributedString *)attributedStringWithText:(NSString *)text markRange:(NSRange)markRange markTextAttribute:(SMRTextAttribute *)markTextAttribute {
    NSMutableAttributedString *attr = [[self attributedStringWithText:text] mutableCopy];
    if (markRange.location != NSNotFound) {
        NSString *markText = [text substringWithRange:markRange];
        NSAttributedString *markAttr = [markTextAttribute attributedStringWithText:markText];
        [attr replaceCharactersInRange:markRange withAttributedString:markAttr];
    }
    return [attr copy];
}

- (NSAttributedString *)p_attributedStringWithText:(NSString *)text {
    if (!text) {
        return nil;
    }
    NSAttributedString *attr =
    [[NSAttributedString alloc] initWithString:text
                                    attributes:self.dict];
    return attr;
}

- (SMRTextAttribute *)p_textAttributeWithFixLineSpaceing {
    SMRTextAttribute *attr = [SMRTextAttribute textAttributeWithDictionary:self.dict];
    attr.lineSpacing = 0;
    attr.minimumLineHeight = self.lineSpacing + ceil(self.font.lineHeight);
    attr.maximumLineHeight = self.lineSpacing + ceil(self.font.lineHeight);
    attr.baselineOffset = self.lineSpacing/4.0;
    return attr;
}

- (CGSize)sizeOfText:(NSString *)text fitSize:(CGSize)fitSize {
    return [self sizeOfText:text fitSize:fitSize fixLineSpacing:YES];
}

- (CGSize)sizeOfText:(NSString *)text fitSize:(CGSize)fitSize fixLineSpacing:(BOOL)fixLineSpacing {
    NSAttributedString *attr = [self attributedStringWithText:text fixLineSpacing:fixLineSpacing];
    CGSize size = [attr boundingRectWithSize:fitSize
                                     options:NSStringDrawingUsesLineFragmentOrigin
                                     context:nil].size;
    // 计算出的宽有些偏差,暂时采用向上取整的方式来修补
    return CGSizeMake(ceil(size.width), size.height);
}

#pragma mark - Utils Setters

- (void)setAttribute:(NSString *)name value:(id)value {
    if (!name.length) {
        return;
    }
    self.dict[name] = value;
}

#pragma mark - Utils Getters

- (id)attributeValueWithName:(NSString *)name {
    if (!name.length) {
        return nil;
    }
    return self.dict[name];
}

- (NSMutableDictionary<NSAttributedStringKey, id> *)dict {
    if (!_dict) {
        _dict = [NSMutableDictionary dictionary];
    }
    return _dict;
}

- (NSMutableDictionary<NSAttributedStringKey,id> *)attributedDictionary {
    return self.dict;
}

@end
