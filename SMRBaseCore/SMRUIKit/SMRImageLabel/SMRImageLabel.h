//
//  SMRImageLabel.h
//  SMRBaseCore
//
//  Created by 丁治文 on 2019/9/23.
//  Copyright © 2019 sumrise. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SMRImageLabel : UIView

@property (strong, nonatomic, readonly) UIImageView *backImageView;
@property (strong, nonatomic, readonly) UILabel *textLabel;

@property (assign, nonatomic) UIEdgeInsets textLabelInsets;

@end

NS_ASSUME_NONNULL_END
