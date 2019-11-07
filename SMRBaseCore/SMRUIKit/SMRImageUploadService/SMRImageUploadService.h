//
//  SMRImageUploadService.h
//  SMRBaseCoreDemo
//
//  Created by 丁治文 on 2019/8/23.
//  Copyright © 2019 sumrise. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#pragma mark - --SMRImageUploadService

FOUNDATION_EXPORT NSString * const kImageUploadTaskChangedNotification;

FOUNDATION_EXPORT NSString * const kSMRImageTaskProgressChangedNotification;    // 进度变化时的通知
FOUNDATION_EXPORT NSString * const kSMRImageTaskSuccessNotification;            // 上传成功时的通知
FOUNDATION_EXPORT NSString * const kSMRImageTaskFaildNotification;              // 上传失败时的通知
FOUNDATION_EXPORT NSString * const kSMRImageTaskCanceledNotification;           // 上传取消时的通知

@class SMRImageTask;
@class SMRImageUploadService;
typedef void(^SMRImageUploadingBlock)(SMRImageUploadService *service, SMRImageTask *uploadingImageTask);
typedef void(^SMRImageCancelBlock)(SMRImageUploadService *service, SMRImageTask *uploadingImageTask);

typedef void(^SMRImageCacheSaveBlock)(SMRImageUploadService *service, UIImage *image, NSString *taskIdentifier);
typedef UIImage *_Nullable(^SMRImageCacheGetBlock)(SMRImageUploadService *service, NSString *taskIdentifier);
typedef void(^SMRImageCacheRemoveBlock)(SMRImageUploadService *service, NSString *taskIdentifier);

@class SMRImageTaskObserver;
@interface SMRImageUploadService : NSObject

@property (copy  , nonatomic) SMRImageUploadingBlock uploadingBlock;
@property (copy  , nonatomic) SMRImageCancelBlock cancelBlock;

@property (copy  , nonatomic) SMRImageCacheSaveBlock cacheSaveBlock;
@property (copy  , nonatomic) SMRImageCacheGetBlock cacheGetBlock;
@property (copy  , nonatomic) SMRImageCacheRemoveBlock cacheRemoveBlock;

@property (assign, nonatomic) NSInteger maxIngCount; ///< 最大任务并发数,0表示无限制,默认1

@property (assign, nonatomic, readonly) NSInteger ingCount; ///< 进行中任务的数量
@property (assign, nonatomic, readonly) NSInteger watingCount; ///< 等待中任务的数量
@property (assign, nonatomic, readonly) NSInteger loadingCount; ///< 未成功且未取消的数量

+ (instancetype)sharedService;

/** 首次任务时可使用此方法 */
- (SMRImageTask *)taskWithBondingImage:(UIImage *)image;
/** 获取任务队列中的任务,没有则会自动创建一个 */
- (SMRImageTask *)taskWithIdentifier:(NSString *)taskIdentifier;

/** 首次任务时可使用此方法 */
- (SMRImageTaskObserver *)taskObserverWithBondingImage:(UIImage *)image;
/** 可根据identifier获取任务接口,每个任务可对应多个任务接口对象,未找到则返回nil */
- (SMRImageTaskObserver *)taskObserverWithTaskIdentifier:(NSString *)taskIdentifier;

/** 获取缓存的image */
- (UIImage *)imageCacheWithTaskIdentifier:(NSString *)taskIdentifier;
/** 移除缓存的image */
- (void)removeImageCacheWithTaskIdentifier:(NSString *)taskIdentifier;

/** 移除任务,仅正常完成的会被自动移除 */
- (void)removeTaskWithIdentifier:(NSString *)taskIdentifier;
- (void)removeTaskWithIdentifier:(NSString *)taskIdentifier removeImageCache:(BOOL)removeImageCache;

@end

#pragma mark - --SMRImageTask

@class SMRImageTask;
@protocol SMRImageTaskDelegate <NSObject>

- (void)didResumeImageTask:(SMRImageTask *)imageTask;
- (void)didCancelImageTask:(SMRImageTask *)imageTask;

- (void)imageTask:(SMRImageTask *)imageTask didRecivedProgressWithCompletedBytesCount:(int64_t)completedBytesCount totalBytesCount:(int64_t)totalBytesCount;
- (void)imageTask:(SMRImageTask *)imageTask didRecivedSuccessWithImageURL:(NSString *)imageURL;
- (void)imageTask:(SMRImageTask *)imageTask didRecivedFaildWithError:(NSError *)error;
- (void)imageTask:(SMRImageTask *)imageTask didRecivedCanceledWithError:(NSError *)error;

@end

@interface SMRImageTask : NSObject

@property (strong, nonatomic) NSString *identifier;

/** 任务完成是否自动移除,默认YES */
@property (assign, nonatomic) BOOL autoRemove;

/** progress */
@property (assign, nonatomic) int64_t completedBytesCount;
@property (assign, nonatomic) int64_t totalBytesCount;

/** success */
@property (copy  , nonatomic) NSString *imageURL;

/** error */
@property (strong, nonatomic) NSError *error;

/** info */
@property (strong, nonatomic) id object;
@property (strong, nonatomic) NSDictionary *userInfo;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithIdentifier:(NSString *)identifier delegate:(id<SMRImageTaskDelegate>)delegate;

- (void)resume;
- (void)cancel;

- (void)resetStatus;

- (void)fillTaskProgressWithCompletedBytesCount:(int64_t)completedBytesCount totalBytesCount:(int64_t)totalBytesCount;
- (void)fillTaskSuccessWithImageURL:(NSString *)imageURL;
- (void)fillTaskFaildWithError:(NSError *)error;
- (void)fillTaskCanceledWithError:(NSError *)error;

@end

#pragma mark - --SMRImageTaskObserver

@class SMRImageTaskObserver;
typedef void(^SMRImageTaskProgressBlock)(SMRImageTaskObserver *observer, UIImage *image, int64_t completedBytesCount, int64_t totalBytesCount);
typedef void(^SMRImageTaskSuccessBlock)(SMRImageTaskObserver *observer, UIImage *image, NSString *imageURL);
typedef void(^SMRImageTaskFaildBlock)(SMRImageTaskObserver *observer, UIImage *image, NSError *error);

@protocol SMRImageTaskObserverDelegate <NSObject>

- (void)didResumeImageTaskObserver:(SMRImageTaskObserver *)observer;
- (void)didCancelImageTaskObserver:(SMRImageTaskObserver *)observer;

@end

@class SMRImageTask;
@interface SMRImageTaskObserver : NSObject

@property (strong, nonatomic, readonly) NSString *taskIdentifier;

@property (weak  , nonatomic, readonly) SMRImageTask * _Nullable task; ///< 如果未开始上传或任务结束,则有可能task为nil

@property (copy  , nonatomic) SMRImageTaskProgressBlock progressBlock;
@property (copy  , nonatomic) SMRImageTaskSuccessBlock successBlock;
@property (copy  , nonatomic) SMRImageTaskFaildBlock faildBlock;
@property (copy  , nonatomic) SMRImageTaskFaildBlock canceledBlock;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithTaskIdentifier:(NSString *)taskIdentifier;

+ (instancetype)observerWithTaskIdentifier:(NSString *)taskIdentifier;

- (void)resume;
- (void)cancel;

@end

NS_ASSUME_NONNULL_END
