//
//  SMRUtils+YYText.m
//  SMRBaseCoreDemo
//
//  Created by 丁治文 on 2019/2/26.
//  Copyright © 2019 sumrise. All rights reserved.
//

#import "SMRUtils+YYText.h"

@implementation SMRUtils (YYText)

+ (NSMutableAttributedString *)yy_attributedStringWithTags:(NSArray<NSString *> *)tags
                                                  textFont:(UIFont *)textFont
                                                 textColor:(UIColor *)textColor
                                          hilitedTextColor:(UIColor *)hilitedTextColor
                                                  tagSpace:(NSString *)tagSpace
                                                 lineSpace:(CGFloat)lineSpace
                                               borderWidth:(CGFloat)borderWidth
                                               borderColor:(UIColor *)borderColor
                                              cornerRadius:(CGFloat)cornerRadius
                                              borderInsets:(UIEdgeInsets)borderInsets
                                           backgroundColor:(UIColor *)backgroundColor
                                                 tapAction:(void (^)(NSString *text, NSInteger index))tapAction {
    NSMutableAttributedString *text = [NSMutableAttributedString new];
    
    for (int i = 0; i < tags.count; i++) {
        NSString *tag = tags[i];
        NSMutableAttributedString *tagText = [[NSMutableAttributedString alloc] initWithString:tag];
        [tagText yy_insertString:@"   " atIndex:0];
        [tagText yy_appendString:@"   "];
        tagText.yy_font = textFont;
        tagText.yy_color = textColor;
        [tagText yy_setTextBinding:[YYTextBinding bindingWithDeleteConfirm:NO] range:tagText.yy_rangeOfAll];
        
        YYTextBorder *border = [YYTextBorder new];
        border.strokeWidth = borderWidth;
        border.strokeColor = borderColor;
        border.fillColor = backgroundColor;
        border.cornerRadius = cornerRadius;
        border.insets = UIEdgeInsetsEqualToEdgeInsets(borderInsets, UIEdgeInsetsZero) ? UIEdgeInsetsMake(-2, -5.5, -2, -8) : borderInsets;
        [tagText yy_setTextBackgroundBorder:border range:[tagText.string rangeOfString:tag]];
        
        YYTextHighlight *highlight = [[YYTextHighlight alloc] init];
        [highlight setColor:(hilitedTextColor ?: [UIColor clearColor])];
        highlight.tapAction = ^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect) {
            if (tapAction) {
                tapAction(tags[i], i);
            }
        };
        [tagText yy_setTextHighlight:highlight range:tagText.yy_rangeOfAll];
        
        if ((i != (tags.count - 1)) && tagSpace) {
            [text yy_appendString:tagSpace];
        }
        [text appendAttributedString:tagText];
    }
    text.yy_lineSpacing = lineSpace;
    text.yy_lineBreakMode = NSLineBreakByWordWrapping;
    return text;
}

@end
