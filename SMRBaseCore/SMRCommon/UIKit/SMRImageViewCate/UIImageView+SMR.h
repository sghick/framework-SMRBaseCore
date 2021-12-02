//
//  UIImageView+SMR.h
//  SMRBaseCoreDemo
//
//  Created by 丁治文 on 2019/8/5.
//  Copyright © 2019 sumrise. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/PhotosTypes.h>
#import <Photos/PHImageManager.h>

NS_ASSUME_NONNULL_BEGIN

@interface SMRPHAssetResult : NSObject

@property (strong, nonatomic) UIImage *image;
@property (strong, nonatomic) NSDictionary *info;

@property (assign, nonatomic, readonly) BOOL isInCloud;
@property (assign, nonatomic, readonly) BOOL isDegraded;
@property (assign, nonatomic, readonly) PHImageRequestID requestID;
@property (assign, nonatomic, readonly) BOOL cancelled;
@property (assign, nonatomic, readonly) NSError *error;

@end

@class PHAsset;
@class PHImageRequestOptions;
@interface UIImageView (SMR)

/** 设置动图 */
- (void)smr_setAnimatedImage:(UIImage *)animatedImage;
- (void)smr_setAnimatedImage:(UIImage *)animatedImage repeatCount:(NSInteger)repeatCount;

/** 默认高清图 */
- (void)smr_setImageWithAsset:(PHAsset *)asset;
- (void)smr_setImageWithAsset:(PHAsset *)asset fitWidth:(CGFloat)fitWidth;
- (void)smr_setImageWithAsset:(PHAsset *)asset options:(PHImageRequestOptions *)options fitWidth:(CGFloat)fitWidth;
- (void)smr_setImageWithAsset:(PHAsset *)asset
                      options:(PHImageRequestOptions *)options
                     fitWidth:(CGFloat)fitWidth
                resultHandler:(nullable void (^)(UIImage *_Nullable result, NSDictionary *_Nullable info))resultHandler;

+ (void)smr_requestImageForAsset:(PHAsset *)asset
                      targetSize:(CGSize)targetSize
                     contentMode:(PHImageContentMode)contentMode
                         options:(nullable PHImageRequestOptions *)options
                   resultHandler:(void (^)(UIImage *_Nullable result, NSDictionary *_Nullable info))resultHandler;

+ (void)smr_requestImageForAssets:(NSArray<PHAsset *> *)assets
                         fitWidth:(CGFloat)fitWidth
                      contentMode:(PHImageContentMode)contentMode
                          options:(nullable PHImageRequestOptions *)options
                      targetCount:(NSInteger)targetCount
                    resultHandler:(nullable BOOL (^)(SMRPHAssetResult *result))resultHandler
                   resultHandlers:(void (^)(NSArray<SMRPHAssetResult *> *results))resultHandlers;

/** 设置视频某一帧的图片 */
- (void)smr_setImageWithVideoURL:(NSURL *)videoURL atTime:(NSTimeInterval)time;

@end

NS_ASSUME_NONNULL_END
