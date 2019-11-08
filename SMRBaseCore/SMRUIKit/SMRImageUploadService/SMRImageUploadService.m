//
//  SMRImageUploadService.m
//  SMRBaseCoreDemo
//
//  Created by 丁治文 on 2019/8/23.
//  Copyright © 2019 sumrise. All rights reserved.
//

#import "SMRImageUploadService.h"

#pragma mark - --SMRImageUploadService

NSString * const kImageUploadTaskChangedNotification = @"kImageUploadTaskChangedNotification";

NSString * const kSMRImageTaskProgressChangedNotification = @"kSMRImageTaskProgressChangedNotification";
NSString * const kSMRImageTaskSuccessNotification = @"kSMRImageTaskSuccessNotification";
NSString * const kSMRImageTaskFaildNotification = @"kSMRImageTaskFaildNotification";
NSString * const kSMRImageTaskCanceledNotification = @"kSMRImageTaskCanceledNotification";

@interface SMRImageUploadService ()<
SMRImageTaskDelegate,
SMRImageTaskObserverDelegate>

@property (strong, nonatomic) NSMutableArray<NSString *> *taskQueue;
@property (strong, nonatomic) NSMutableArray<NSString *> *ingQueue;
@property (strong, nonatomic) NSMutableArray<NSString *> *waitingQueue;
@property (strong, nonatomic) NSMutableDictionary<NSString *, SMRImageTask *> *taskDict;

@property (strong, nonatomic) NSMutableDictionary<NSString *, UIImage *> *imageCache;

@end

@implementation SMRImageUploadService

+ (instancetype)sharedService {
    static SMRImageUploadService *_sharedImageUploadService = nil;
    static dispatch_once_t _sharedImageUploadServiceOnceToken;
    dispatch_once(&_sharedImageUploadServiceOnceToken, ^{
        _sharedImageUploadService = [[SMRImageUploadService alloc] init];
        _sharedImageUploadService.maxIngCount = 1;
    });
    return _sharedImageUploadService;
}

#pragma mark - ImageTask

- (SMRImageTask *)taskWithBondingImage:(UIImage *)image {
    NSString *taskIdentifier = [[NSUUID UUID].UUIDString stringByReplacingOccurrencesOfString:@"-" withString:@""];
    [self saveImageCacheWithTaskIdentifier:taskIdentifier image:image];
    SMRImageTask *task = [self taskWithIdentifier:taskIdentifier];
    return task;
}

- (SMRImageTask *)taskWithIdentifier:(NSString *)taskIdentifier {
    if (!taskIdentifier) {
        return nil;
    }
    SMRImageTask *task = self.taskDict[taskIdentifier];
    if (!task) {
        task = [[SMRImageTask alloc] initWithIdentifier:taskIdentifier delegate:self];
        task.identifier = taskIdentifier;
        self.taskDict[taskIdentifier] = task;
        [self.taskQueue addObject:taskIdentifier];
    }
    return task;
}

- (SMRImageTask *)imageTaskWithIdentifier:(NSString *)taskIdentifier {
    return [self taskWithIdentifier:taskIdentifier];
}

#pragma mark - ImageTaskObserver

- (SMRImageTaskObserver *)taskObserverWithBondingImage:(UIImage *)image {
    SMRImageTask *task = [self taskWithBondingImage:image];
    SMRImageTaskObserver *observer = [self taskObserverWithTaskIdentifier:task.identifier];
    return observer;
}

- (SMRImageTaskObserver *)taskObserverWithTaskIdentifier:(NSString *)taskIdentifier {
    SMRImageTaskObserver *Observer = [SMRImageTaskObserver observerWithTaskIdentifier:taskIdentifier];
    return Observer;
}

#pragma mark - ImageCache

- (void)saveImageCacheWithTaskIdentifier:(NSString *)taskIdentifier image:(UIImage *)image {
    if (self.cacheSaveBlock) {
        self.cacheSaveBlock(self, image, taskIdentifier);
    } else {
        self.imageCache[taskIdentifier] = image;
    }
}

- (UIImage *)imageCacheWithTaskIdentifier:(NSString *)taskIdentifier {
    if (self.cacheGetBlock) {
        return self.cacheGetBlock(self, taskIdentifier);
    } else {
        return self.imageCache[taskIdentifier];
    }
}

- (void)removeImageCacheWithTaskIdentifier:(NSString *)taskIdentifier {
    if (self.cacheRemoveBlock) {
        self.cacheRemoveBlock(self, taskIdentifier);
    } else {
        [self.imageCache removeObjectForKey:taskIdentifier];
    }
}

- (void)removeTaskWithIdentifier:(NSString *)taskIdentifier {
    [self removeTaskWithIdentifier:taskIdentifier removeImageCache:NO];
}

- (void)removeTaskWithIdentifier:(NSString *)taskIdentifier removeImageCache:(BOOL)removeImageCache {
    if (!taskIdentifier) {
        return;
    }
    self.taskDict[taskIdentifier] = nil;
    [self.taskQueue removeObject:taskIdentifier];
    [self.ingQueue removeObject:taskIdentifier];
    [self.waitingQueue removeObject:taskIdentifier];
    if (removeImageCache) {
        [self removeImageCacheWithTaskIdentifier:taskIdentifier];
    }
}

#pragma mark - SMRImageTaskDelegate

- (void)didResumeImageTask:(SMRImageTask *)imageTask {
    self.taskDict[imageTask.identifier] = imageTask;
    if (![self.taskQueue containsObject:imageTask.identifier]) {
        [self.taskQueue addObject:imageTask.identifier];
    }
    
    // 发送更新信号
    [self postImageUploadTaskChangedNotification];
    
    // 交换任务队列
    [self.waitingQueue addObject:imageTask.identifier];
    // 判断是否开始一个任务
    [self checkNeedsResumeNextTask];
}
- (void)didCancelImageTask:(SMRImageTask *)imageTask {
    if (self.cancelBlock) {
        self.cancelBlock(self, imageTask);
    }
    
    // 发送更新信号
    [self postImageUploadTaskChangedNotification];
    
    // 交换任务队列
    [self.waitingQueue removeObject:imageTask.identifier];
    [self.ingQueue removeObject:imageTask.identifier];
    // 判断是否开始一个任务
    [self checkNeedsResumeNextTask];
}

- (void)imageTask:(SMRImageTask *)imageTask didRecivedProgressWithCompletedBytesCount:(int64_t)completedBytesCount totalBytesCount:(int64_t)totalBytesCount {
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:kSMRImageTaskProgressChangedNotification object:imageTask];
    });
}
- (void)imageTask:(SMRImageTask *)imageTask didRecivedSuccessWithImageURL:(NSString *)imageURL {
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:kSMRImageTaskSuccessNotification object:imageTask];
    });
    [self postImageUploadTaskChangedNotification];
    
    if (imageTask.autoRemove) {
        // 任务完成后则移除当前任务
        [self removeTaskWithIdentifier:imageTask.identifier];
    } else {
        [self.taskQueue removeObject:imageTask.identifier];
        [self.ingQueue removeObject:imageTask.identifier];
        [self.waitingQueue removeObject:imageTask.identifier];
    }
    // 判断是否开始一个任务
    [self checkNeedsResumeNextTask];
}
- (void)imageTask:(SMRImageTask *)imageTask didRecivedFaildWithError:(NSError *)error {
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:kSMRImageTaskFaildNotification object:imageTask];
    });
    [self postImageUploadTaskChangedNotification];
    
    // 交换任务队列
    [self.waitingQueue removeObject:imageTask.identifier];
    [self.ingQueue removeObject:imageTask.identifier];
    // 判断是否开始一个任务
    [self checkNeedsResumeNextTask];
}
- (void)imageTask:(SMRImageTask *)imageTask didRecivedCanceledWithError:(NSError *)error {
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:kSMRImageTaskCanceledNotification object:imageTask];
    });
    [self postImageUploadTaskChangedNotification];
    
    // 交换任务队列
    [self.waitingQueue removeObject:imageTask.identifier];
    [self.ingQueue removeObject:imageTask.identifier];
    [self.taskQueue removeObject:imageTask.identifier];
    // 判断是否开始一个任务
    [self checkNeedsResumeNextTask];
}

#pragma mark - SMRImageTaskObserverDelegate

- (void)didResumeImageTaskObserver:(SMRImageTaskObserver *)observer {
    SMRImageTask *task = [self taskWithIdentifier:observer.taskIdentifier];
    [self didResumeImageTask:task];
}
- (void)didCancelImageTaskObserver:(SMRImageTaskObserver *)observer {
    SMRImageTask *task = [self taskWithIdentifier:observer.taskIdentifier];
    [self didCancelImageTask:task];
}

#pragma mark - Utils

- (void)checkNeedsResumeNextTask {
    if ((self.maxIngCount > 0) && (self.ingQueue.count >= self.maxIngCount)) {
        // 超过最大任务并发数
        return;
    }
    if (self.waitingQueue.count == 0) {
        // 等待队列中没有任务
        return;
    }
    
    NSString *nextIdentifier = self.waitingQueue.firstObject;
    SMRImageTask *imageTask = self.taskDict[nextIdentifier];
    [self.waitingQueue removeObject:nextIdentifier];
    [self.ingQueue addObject:nextIdentifier];
    
    if (self.uploadingBlock) {
        self.uploadingBlock(self, imageTask);
    }
}

- (void)postImageUploadTaskChangedNotification {
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:kImageUploadTaskChangedNotification object:self];
    });
}

#pragma mark - Getters

- (NSInteger)ingCount {
    return self.ingQueue.count;
}

- (NSInteger)watingCount {
    return self.waitingQueue.count;
}

- (NSInteger)loadingCount {
    return self.taskQueue.count;
}

- (NSMutableArray<NSString *> *)taskQueue {
    if (!_taskQueue) {
        _taskQueue = [NSMutableArray array];
    }
    return _taskQueue;
}

- (NSMutableArray<NSString *> *)ingQueue {
    if (!_ingQueue) {
        _ingQueue = [NSMutableArray array];
    }
    return _ingQueue;
}

- (NSMutableArray<NSString *> *)waitingQueue {
    if (!_waitingQueue) {
        _waitingQueue = [NSMutableArray array];
    }
    return _waitingQueue;
}

- (NSMutableDictionary<NSString *,SMRImageTask *> *)taskDict {
    if (!_taskDict) {
        _taskDict = [NSMutableDictionary dictionary];
    }
    return _taskDict;
}

- (NSMutableDictionary<NSString *,UIImage *> *)imageCache {
    if (!_imageCache) {
        _imageCache = [NSMutableDictionary dictionary];
    }
    return _imageCache;
}

@end

#pragma mark - --SMRImageTask

@interface SMRImageTask ()

@property (weak  , nonatomic) id<SMRImageTaskDelegate> delegate;

@end

@implementation SMRImageTask

- (instancetype)initWithIdentifier:(NSString *)identifier delegate:(id<SMRImageTaskDelegate>)delegate {
    self = [super init];
    if (self) {
        _identifier = identifier;
        _delegate = delegate;
        _autoRemove = YES;
    }
    return self;
}

#pragma mark - Utils

- (void)resume {
    if ([self.delegate respondsToSelector:@selector(didResumeImageTask:)]) {
        [self.delegate didResumeImageTask:self];
    }
}

- (void)cancel {
    if ([self.delegate respondsToSelector:@selector(didCancelImageTask:)]) {
        [self.delegate didCancelImageTask:self];
    }
}

- (void)resetStatus {
    _completedBytesCount = 0;
    _totalBytesCount = 0;
    _imageURL = nil;
}

- (void)fillTaskProgressWithCompletedBytesCount:(int64_t)completedBytesCount totalBytesCount:(int64_t)totalBytesCount {
    _completedBytesCount = completedBytesCount;
    _totalBytesCount = totalBytesCount;
    if ([self.delegate respondsToSelector:@selector(imageTask:didRecivedProgressWithCompletedBytesCount:totalBytesCount:)]) {
        [self.delegate imageTask:self didRecivedProgressWithCompletedBytesCount:completedBytesCount totalBytesCount:totalBytesCount];
    }
}

- (void)fillTaskSuccessWithImageURL:(NSString *)imageURL {
    _imageURL = imageURL;
    if ([self.delegate respondsToSelector:@selector(imageTask:didRecivedSuccessWithImageURL:)]) {
        [self.delegate imageTask:self didRecivedSuccessWithImageURL:imageURL];
    }
}

- (void)fillTaskFaildWithError:(NSError *)error {
    _error = error;
    if ([self.delegate respondsToSelector:@selector(imageTask:didRecivedFaildWithError:)]) {
        [self.delegate imageTask:self didRecivedFaildWithError:error];
    }
}

- (void)fillTaskCanceledWithError:(NSError *)error {
    _error = error;
    if ([self.delegate respondsToSelector:@selector(imageTask:didRecivedCanceledWithError:)]) {
        [self.delegate imageTask:self didRecivedCanceledWithError:error];
    }
}

@end

#pragma mark - --SMRImageTaskObserver

@interface SMRImageTaskObserver ()

@property (weak  , nonatomic) id<SMRImageTaskObserverDelegate> delegate;

@end

@implementation SMRImageTaskObserver

- (instancetype)initWithTaskIdentifier:(NSString *)taskIdentifier {
    self = [super init];
    if (self) {
        _taskIdentifier = taskIdentifier;
        _delegate = [SMRImageUploadService sharedService];
        _task = [[SMRImageUploadService sharedService] taskWithIdentifier:taskIdentifier];
        // 添加监听
        [self initNotifications];
    }
    return self;
}

+ (instancetype)observerWithTaskIdentifier:(NSString *)taskIdentifier {
    SMRImageTaskObserver *observer = [[SMRImageTaskObserver alloc] initWithTaskIdentifier:taskIdentifier];
    return observer;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Notifications

- (void)initNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(progressChanged:)
                                                 name:kSMRImageTaskProgressChangedNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(success:)
                                                 name:kSMRImageTaskSuccessNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(faild:)
                                                 name:kSMRImageTaskFaildNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(canceled:)
                                                 name:kSMRImageTaskCanceledNotification
                                               object:nil];
}

- (void)progressChanged:(NSNotification *)notification {
    SMRImageTask *task = notification.object;
    if (![self.taskIdentifier isEqualToString:task.identifier]) {
        return;
    }
    _task = task;
    UIImage *image = [[SMRImageUploadService sharedService] imageCacheWithTaskIdentifier:task.identifier];
    if (self.progressBlock) {
        self.progressBlock(self, image, task.completedBytesCount, task.totalBytesCount);
    }
}

- (void)success:(NSNotification *)notification {
    SMRImageTask *task = notification.object;
    if (![self.taskIdentifier isEqualToString:task.identifier]) {
        return;
    }
    _task = task;
    UIImage *image = [[SMRImageUploadService sharedService] imageCacheWithTaskIdentifier:task.identifier];
    if (self.successBlock) {
        self.successBlock(self, image, task.imageURL);
    }
}

- (void)faild:(NSNotification *)notification {
    SMRImageTask *task = notification.object;
    if (![self.taskIdentifier isEqualToString:task.identifier]) {
        return;
    }
    _task = task;
    UIImage *image = [[SMRImageUploadService sharedService] imageCacheWithTaskIdentifier:task.identifier];
    if (self.faildBlock) {
        self.faildBlock(self, image, task.error);
    }
}

- (void)canceled:(NSNotification *)notification {
    SMRImageTask *task = notification.object;
    if (![self.taskIdentifier isEqualToString:task.identifier]) {
        return;
    }
    _task = task;
    UIImage *image = [[SMRImageUploadService sharedService] imageCacheWithTaskIdentifier:task.identifier];
    if (self.canceledBlock) {
        self.canceledBlock(self, image, task.error);
    }
}

#pragma mark - Utils

- (void)resume {
    if ([self.delegate respondsToSelector:@selector(didResumeImageTaskObserver:)]) {
        [self.delegate didResumeImageTaskObserver:self];
    }
}

- (void)cancel {
    if ([self.delegate respondsToSelector:@selector(didCancelImageTaskObserver:)]) {
        [self.delegate didCancelImageTaskObserver:self];
    }
}

@end
