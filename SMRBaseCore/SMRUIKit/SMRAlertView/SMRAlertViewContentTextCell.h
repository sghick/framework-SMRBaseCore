//
//  SMRAlertViewContentTextCell.h
//  SMRBaseCoreDemo
//
//  Created by 丁治文 on 2019/2/14.
//  Copyright © 2019 sumrise. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class SMRAlertViewContentTextCell;
@protocol SMRAlertViewContentTextCellDelegate <NSObject>

@optional
- (void)alertTextCell:(SMRAlertViewContentTextCell *)cell didSelectLinkWithPhoneNumber:(NSString *)phoneNumber;
- (void)alertTextCell:(SMRAlertViewContentTextCell *)cell didSelectLinkWithURL:(NSURL *)url;

@end

@interface SMRAlertViewContentTextCell : UITableViewCell

@property (strong, nonatomic) NSAttributedString *attributeText;
@property (assign, nonatomic) CGFloat maxLayoutWidth;
@property (assign, nonatomic) NSTextAlignment alignment;

@property (weak  , nonatomic) id<SMRAlertViewContentTextCellDelegate> delegate;

- (void)addLinkToURL:(NSURL *)url withRange:(NSRange)range;

+ (CGFloat)heightOfCellWithAttributeText:(NSAttributedString *)attributeText fitWidth:(CGFloat)fitWidth;

+ (NSAttributedString *)attributeStringWithAttributedContent:(NSAttributedString *)attributedContent alignment:(NSTextAlignment)alignment;

@end

NS_ASSUME_NONNULL_END
