//
//  SMRUtils+SDWebImage.m
//  SMRBaseCoreDemo
//
//  Created by 丁治文 on 2019/9/18.
//  Copyright © 2019 sumrise. All rights reserved.
//

#import "SMRUtils+SDWebImage.h"
#import "SDImageCache.h"
#import "SDWebImageDownloader.h"

@implementation SMRUtils (SDWebImage)

+ (void)downloadAndCacheImageWithURL:(nullable NSURL *)url
                           completed:(nullable void(^)(UIImage *))completedBlock {
    UIImage *image = [[SDImageCache sharedImageCache] imageFromCacheForKey:url.absoluteString];
    if (!image) {
        [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:url completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
            [[SDImageCache sharedImageCache] storeImage:image forKey:url.absoluteString completion:nil];
            completedBlock(image);
        }];
    } else {
        completedBlock(image);
    }
}

@end
