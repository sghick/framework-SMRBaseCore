//
//  SMRTextAttribute.h
//  SMRBaseCoreDemo
//
//  Created by Tinswin on 2020/1/20.
//  Copyright © 2020 sumrise. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SMRTextAttribute : NSObject

@property (strong, nonatomic, readonly) NSDictionary<NSAttributedStringKey, id>  *attributedDictionary;

@property (strong, nonatomic) UIFont *font;
@property (strong, nonatomic) UIColor *color;
@property (strong, nonatomic) UIColor *backgroundColor;

@property (assign, nonatomic) CGFloat strokeWidth;
@property (strong, nonatomic) UIColor *strokeColor;

@property (assign, nonatomic) NSUnderlineStyle strikethroughStyle;
@property (strong, nonatomic) UIColor *strikethroughColor;

@property (assign, nonatomic) NSUnderlineStyle underlineStyle;
@property (strong, nonatomic) UIColor *underlineColor;

@property (strong, nonatomic) NSParagraphStyle *paragraphStyle;
@property (assign, nonatomic) NSTextAlignment alignment;
@property (assign, nonatomic) NSLineBreakMode lineBreakMode;
@property (assign, nonatomic) CGFloat lineSpacing;
@property (assign, nonatomic) CGFloat paragraphSpacing;
@property (assign, nonatomic) CGFloat paragraphSpacingBefore;
@property (assign, nonatomic) CGFloat firstLineHeadIndent;
@property (assign, nonatomic) CGFloat headIndent;
@property (assign, nonatomic) CGFloat tailIndent;
@property (assign, nonatomic) CGFloat minimumLineHeight;
@property (assign, nonatomic) CGFloat maximumLineHeight;
@property (assign, nonatomic) CGFloat lineHeightMultiple;
@property (assign, nonatomic) NSWritingDirection baseWritingDirection;
@property (assign, nonatomic) float hyphenationFactor;
@property (assign, nonatomic) CGFloat defaultTabInterval;
@property (strong, nonatomic) NSArray<NSTextTab *> *tabStops;

@property (assign, nonatomic) CGFloat kern;
@property (strong, nonatomic) NSShadow *shadow;
@property (assign, nonatomic) NSInteger ligature;
@property (copy  , nonatomic) NSString *textEffect;
@property (assign, nonatomic) CGFloat obliqueness;
@property (assign, nonatomic) CGFloat expansion;
@property (assign, nonatomic) CGFloat baselineOffset;
@property (assign, nonatomic) BOOL verticalGlyphForm;
@property (strong, nonatomic) NSString *language;
@property (strong, nonatomic) NSArray *writingDirection;

+ (instancetype)textAttribute:(NSAttributedString *)attributedString;
+ (instancetype)textAttributeWithDictionary:(NSDictionary<NSAttributedStringKey, id>  *)attributedDictionary;

- (id)attributeValueWithName:(NSString *)name;
- (void)setAttribute:(NSString *)name value:(id)value;

/** 修正了属性字符串后,需要给Label设置preferredMaxLayoutWidth值才能正确自适应宽高 */
- (NSAttributedString *)attributedStringWithText:(NSString *)text; ///< fixLineSpacing:YES
- (NSAttributedString *)attributedStringWithText:(NSString *)text fixLineSpacing:(BOOL)fixLineSpacing;

/** 标记属性字符串,fixLineSpacing:YES */
- (NSAttributedString *)attributedStringWithText:(NSString *)text markText:(NSString *)markText markTextAttribute:(SMRTextAttribute *)markTextAttribute;
- (NSAttributedString *)attributedStringWithText:(NSString *)text markRange:(NSRange)markRange markTextAttribute:(SMRTextAttribute *)markTextAttribute;

/** 计算出修正后的Label的宽高,也可以使用Label的systemLayoutSizeFittingSize方法计算 */
- (CGSize)sizeOfText:(NSString *)text fitSize:(CGSize)fitSize; ///< fixLineSpacing:YES
- (CGSize)sizeOfText:(NSString *)text fitSize:(CGSize)fitSize fixLineSpacing:(BOOL)fixLineSpacing;

@end

