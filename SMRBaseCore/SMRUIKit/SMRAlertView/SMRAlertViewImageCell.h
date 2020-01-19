//
//  SMRAlertViewImageCell.h
//  SMRBaseCoreDemo
//
//  Created by Tinswin on 2020/1/19.
//  Copyright © 2020 sumrise. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SMRAlertViewImageCell : UITableViewCell

@property (copy  , nonatomic) NSString *imageURL;
@property (strong, nonatomic) UIImage *image;
@property (assign, nonatomic) CGSize imageSize;
@property (assign, nonatomic) CGFloat imageTop;

@end

NS_ASSUME_NONNULL_END
