//
//  SMRAlertViewContentTextCell.h
//  SMRBaseCoreDemo
//
//  Created by 丁治文 on 2019/2/14.
//  Copyright © 2019 sumrise. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SMRAlertViewContentTextCell : UITableViewCell

@property (strong, nonatomic) NSAttributedString *attributeText;

+ (CGFloat)heightOfCellWithAttributeText:(NSAttributedString *)attributeText fitWidth:(CGFloat)fitWidth;

+ (NSAttributedString *)defaultAttributeText:(NSString *)text;

@end

NS_ASSUME_NONNULL_END
