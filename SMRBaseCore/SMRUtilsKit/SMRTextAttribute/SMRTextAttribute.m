//
//  SMRTextAttribute.m
//  Hermes
//
//  Created by Tinswin on 2020/1/20.
//  Copyright © 2020 sumrise. All rights reserved.
//

#import "SMRTextAttribute.h"
#import <CoreText/CoreText.h>

@interface SMRTextAttribute ()

@property (strong, nonatomic) NSMutableDictionary<NSAttributedStringKey, id>  *dict;

@property (strong, nonatomic) NSMutableParagraphStyle *editParagraphStyle;

@end

@implementation SMRTextAttribute

+ (instancetype)textAttribute:(NSAttributedString *)attributedString {
    SMRTextAttribute *textAttr = [[SMRTextAttribute alloc] init];
    textAttr.dict = [[attributedString attributesAtIndex:0 effectiveRange:nil] mutableCopy];
    return textAttr;
}

- (void)setFont:(UIFont *)font {
    _font = font;
    [self setAttribute:NSFontAttributeName value:font];
}

- (void)setKern:(CGFloat)kern {
    _kern = kern;
    [self setAttribute:NSKernAttributeName value:@(kern)];
}

- (void)setColor:(UIColor *)color {
    _color = color;
    [self setAttribute:(id)kCTForegroundColorAttributeName value:(id)color.CGColor];
    [self setAttribute:NSForegroundColorAttributeName value:color];
}

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    _backgroundColor = backgroundColor;
    [self setAttribute:NSBackgroundColorAttributeName value:backgroundColor];
}

- (void)setStrokeWidth:(CGFloat)strokeWidth {
    _strokeWidth = strokeWidth;
    [self setAttribute:NSStrokeWidthAttributeName value:@(strokeWidth)];
}

- (void)setStrokeColor:(UIColor *)strokeColor {
    _strokeColor = strokeColor;
    [self setAttribute:(id)kCTStrokeColorAttributeName value:(id)strokeColor.CGColor];
    [self setAttribute:NSStrokeColorAttributeName value:strokeColor];
}

- (void)setShadow:(NSShadow *)shadow {
    _shadow = shadow;
    [self setAttribute:NSShadowAttributeName value:shadow];
}

- (void)setStrikethroughStyle:(NSUnderlineStyle)strikethroughStyle {
    _strikethroughStyle = strikethroughStyle;
    [self setAttribute:NSStrikethroughStyleAttributeName value:@(strikethroughStyle)];
}

- (void)setStrikethroughColor:(UIColor *)strikethroughColor {
    _strikethroughColor = strikethroughColor;
    [self setAttribute:NSStrikethroughColorAttributeName value:strikethroughColor];
}

- (void)setUnderlineStyle:(NSUnderlineStyle)underlineStyle {
    _underlineStyle = underlineStyle;
    [self setAttribute:NSUnderlineStyleAttributeName value:@(underlineStyle)];
}

- (void)setUnderlineColor:(UIColor *)underlineColor {
    _underlineColor = underlineColor;
    [self setAttribute:(id)kCTUnderlineColorAttributeName value:(id)underlineColor.CGColor];
    [self setAttribute:NSUnderlineColorAttributeName value:underlineColor];
}

- (void)setLigature:(NSInteger)ligature {
    _ligature = ligature;
    [self setAttribute:NSLigatureAttributeName value:@(ligature)];
}

- (void)setTextEffect:(NSString *)textEffect {
    _textEffect = textEffect;
    [self setAttribute:NSTextEffectAttributeName value:textEffect];
}

- (void)setObliqueness:(CGFloat)obliqueness {
    _obliqueness = obliqueness;
    [self setAttribute:NSObliquenessAttributeName value:@(obliqueness)];
}

- (void)setExpansion:(CGFloat)expansion {
    _expansion = expansion;
    [self setAttribute:NSExpansionAttributeName value:@(expansion)];
}

- (void)setBaselineOffset:(CGFloat)baselineOffset {
    _baselineOffset = baselineOffset;
    [self setAttribute:NSBaselineOffsetAttributeName value:@(baselineOffset)];
}

- (void)setVerticalGlyphForm:(BOOL)verticalGlyphForm {
    _verticalGlyphForm = verticalGlyphForm;
    [self setAttribute:NSVerticalGlyphFormAttributeName value:@(verticalGlyphForm)];
}

- (void)setLanguage:(NSString *)language {
    _language = language;
    [self setAttribute:(id)kCTLanguageAttributeName value:language];
}

- (void)setWritingDirection:(NSArray *)writingDirection {
    _writingDirection = writingDirection;
    [self setAttribute:(id)kCTWritingDirectionAttributeName value:writingDirection];
}

- (void)setParagraphStyle:(NSParagraphStyle *)paragraphStyle {
    _paragraphStyle = paragraphStyle;
    [self setAttribute:NSParagraphStyleAttributeName value:paragraphStyle];
}

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

#define SMRParagraphStyleSet(_attr_) \
[self beginSetParagraphStyle]._attr_ = _attr_; \
[self endSetParagraphStyle]; \

- (void)setAlignment:(NSTextAlignment)alignment {
    _alignment = alignment;
    SMRParagraphStyleSet(alignment);
}

- (void)setBaseWritingDirection:(NSWritingDirection)baseWritingDirection {
    _baseWritingDirection = baseWritingDirection;
    SMRParagraphStyleSet(baseWritingDirection);
}

- (void)setLineSpacing:(CGFloat)lineSpacing {
    _lineSpacing = lineSpacing;
    SMRParagraphStyleSet(lineSpacing);
}

- (void)setParagraphSpacing:(CGFloat)paragraphSpacing {
    _paragraphSpacing = paragraphSpacing;
    SMRParagraphStyleSet(paragraphSpacing);
}

- (void)setParagraphSpacingBefore:(CGFloat)paragraphSpacingBefore {
    _paragraphSpacingBefore = paragraphSpacingBefore;
    SMRParagraphStyleSet(paragraphSpacingBefore);
}

- (void)setFirstLineHeadIndent:(CGFloat)firstLineHeadIndent {
    _firstLineHeadIndent = firstLineHeadIndent;
    SMRParagraphStyleSet(firstLineHeadIndent);
}

- (void)setHeadIndent:(CGFloat)headIndent {
    _headIndent = headIndent;
    SMRParagraphStyleSet(headIndent);
}

- (void)setTailIndent:(CGFloat)tailIndent {
    _tailIndent = tailIndent;
    SMRParagraphStyleSet(tailIndent);
}

- (void)setLineBreakMode:(NSLineBreakMode)lineBreakMode {
    _lineBreakMode = lineBreakMode;
    SMRParagraphStyleSet(lineBreakMode);
}

- (void)setMinimumLineHeight:(CGFloat)minimumLineHeight {
    _minimumLineHeight = minimumLineHeight;
    SMRParagraphStyleSet(minimumLineHeight);
}

- (void)setMaximumLineHeight:(CGFloat)maximumLineHeight {
    _maximumLineHeight = maximumLineHeight;
    SMRParagraphStyleSet(maximumLineHeight);
}

- (void)setLineHeightMultiple:(CGFloat)lineHeightMultiple {
    _lineHeightMultiple = lineHeightMultiple;
    SMRParagraphStyleSet(lineHeightMultiple);
}

- (void)setHyphenationFactor:(float)hyphenationFactor {
    _hyphenationFactor = hyphenationFactor;
    SMRParagraphStyleSet(hyphenationFactor);
}

- (void)setDefaultTabInterval:(CGFloat)defaultTabInterval {
    _defaultTabInterval = defaultTabInterval;
    SMRParagraphStyleSet(defaultTabInterval);
}

- (void)setTabStops:(NSArray *)tabStops {
    _tabStops = tabStops;
    SMRParagraphStyleSet(tabStops);
}

#pragma mark - Utils

- (NSAttributedString *)attributedStringWithText:(NSString *)text {
    if (!text) {
        return nil;
    }
    NSAttributedString *attr =
    [[NSAttributedString alloc] initWithString:text
                                    attributes:self.dict];
    return attr;
}

#pragma mark - Setters

- (void)setAttribute:(NSString *)name value:(id)value {
    if (!name.length) {
        return;
    }
    self.dict[name] = value;
}

#pragma mark - Getters

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

@end
