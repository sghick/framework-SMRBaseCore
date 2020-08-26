//
//  SMRImageTaskTests.m
//  SMRBaseCoreDemo
//
//  Created by Tinswin on 2019/11/6.
//  Copyright © 2019 sumrise. All rights reserved.
//

#import "SMRImageTaskTests.h"

@implementation SMRImageTaskTests

- (id)begin {
    [self configTaskServices];
    
    [self testTaskQuery];
    
    return self;
}

- (void)configTaskServices {
    [SMRImageUploadService sharedService].maxIngCount = 0;
    [SMRImageUploadService sharedService].uploadingBlock = ^(SMRImageUploadService * _Nonnull service, SMRImageTask * _Nonnull uploadingImageTask) {
        dispatch_async(dispatch_queue_create("AAAA", NULL), ^{
            for (int i = 0; i < 30; i++) {
                [NSThread sleepForTimeInterval:0.2];
                if (i < 9) {
                    [uploadingImageTask fillTaskProgressWithCompletedBytesCount:10*(i+1) totalBytesCount:100];
                    continue;
                }
                if (i == 9) {
                    [uploadingImageTask fillTaskSuccessWithImageURL:[NSString stringWithFormat:@"https://testiamge_%@", uploadingImageTask.identifier]];
                    continue;
                }
                if (i < 19) {
                   [uploadingImageTask fillTaskProgressWithCompletedBytesCount:10*(i+1-10) totalBytesCount:100];
                    continue;
                }
                if (i == 19) {
                    NSError *error = [NSError errorWithDomain:@"domain" code:100 userInfo:@{NSLocalizedDescriptionKey:@"上传失败啦"}];
                    [uploadingImageTask fillTaskFaildWithError:error];
                    continue;
                }
                if (i < 29) {
                   [uploadingImageTask fillTaskProgressWithCompletedBytesCount:10*(i+1-20) totalBytesCount:100];
                    continue;
                }
                if (i == 29) {
                    NSError *error = [NSError errorWithDomain:@"domain" code:100 userInfo:@{NSLocalizedDescriptionKey:@"上传取消啦"}];
                    [uploadingImageTask fillTaskFaildWithError:error];
                    continue;
                }
            }
        });
    };
    [SMRImageUploadService sharedService].cancelBlock = ^(SMRImageUploadService * _Nonnull service, SMRImageTask * _Nonnull uploadingImageTask) {
        NSLog(@"收到取消指令,应该去完成取消所做的事");
    };
}

static NSArray<SMRImageTaskObserver *> *_arr = nil;
- (void)testTaskQuery {
    NSMutableArray<SMRImageTaskObserver *> *arr = [NSMutableArray array];
    for (int i = 0; i < 10; i++) {
        UIImage *image = [[UIImage alloc] init];
        SMRImageTaskObserver *observer = [[SMRImageUploadService sharedService] taskObserverWithBondingImage:image];
        [observer resume];
        observer.progressBlock = ^(SMRImageTaskObserver * _Nonnull observer, UIImage * _Nonnull image, int64_t completedBytesCount, int64_t totalBytesCount) {
            NSLog(@"progress:%@:%@/%@", observer.taskIdentifier, @(completedBytesCount), @(totalBytesCount));
        };
        observer.successBlock = ^(SMRImageTaskObserver * _Nonnull observer, UIImage * _Nonnull image, NSString * _Nonnull imageURL) {
            NSLog(@"success:%@:%@", observer.taskIdentifier, imageURL);
        };
        observer.faildBlock = ^(SMRImageTaskObserver * _Nonnull observer, UIImage * _Nonnull image, NSError * _Nonnull error) {
            NSLog(@"error:%@:%@", observer.taskIdentifier, error.localizedDescription);
        };
        observer.canceledBlock = ^(SMRImageTaskObserver * _Nonnull observer, UIImage * _Nonnull image, NSError * _Nonnull error) {
            NSLog(@"cancel:%@:%@", observer.taskIdentifier, error.localizedDescription);
        };
        [arr addObject:observer];
    }
    _arr = arr;
}

@end
