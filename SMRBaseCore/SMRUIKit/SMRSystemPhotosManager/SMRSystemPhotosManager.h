//
//  SMRSystemPhotosManager.h
//  SMRBaseCoreDemo
//
//  Created by Tinswin on 2020/7/27.
//  Copyright © 2020 Tinswin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class SMRSystemPhotosManager;
@protocol SMRSystemPhotosManagerDelegate <NSObject>

- (void)systemPhotosManager:(SMRSystemPhotosManager *)manager didFinishedPickingImage:(UIImage *)image data:(NSData *)data;

@end

@interface SMRSystemPhotosManager : NSObject

@property (weak  , nonatomic) id<SMRSystemPhotosManagerDelegate> delegate;

- (void)showImagePickerAlert;

@end

NS_ASSUME_NONNULL_END
