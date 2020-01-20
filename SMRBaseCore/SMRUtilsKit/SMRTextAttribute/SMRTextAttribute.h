//
//  SMRTextAttribute.h
//  Hermes
//
//  Created by Tinswin on 2020/1/20.
//  Copyright © 2020 sumrise. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SMRTextAttribute : NSObject

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

- (id)attributeValueWithName:(NSString *)name;
- (void)setAttribute:(NSString *)name value:(id)value;
- (NSAttributedString *)attributedStringWithText:(NSString *)text;

@end

