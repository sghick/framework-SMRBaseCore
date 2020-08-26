//
//  UIImage+SMRAdapter.h
//  SMRBaseCoreDemo
//
//  Created by 丁治文 on 2019/1/23.
//  Copyright © 2019 sumrise. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (SMRAdapter)

+ (UIImage *)smr_fixOrientation:(UIImage*)aImage;
+ (UIImage *)smr_imageNamed:(NSString *)name;

@end

NS_ASSUME_NONNULL_END
