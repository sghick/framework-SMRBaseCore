//
//  UIImage+SMRAdapter.h
//  SMRBaseCoreDemo
//
//  Created by Tinswin on 2019/10/14.
//  Copyright © 2019 sumrise. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (SMRAdapter)

+ (UIImage *)smr_fixOrientation:(UIImage *)aImage;

@end

NS_ASSUME_NONNULL_END
