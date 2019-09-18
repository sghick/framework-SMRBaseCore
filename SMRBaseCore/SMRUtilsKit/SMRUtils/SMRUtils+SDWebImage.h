//
//  SMRUtils+SDWebImage.h
//  SMRBaseCoreDemo
//
//  Created by 丁治文 on 2019/9/18.
//  Copyright © 2019 sumrise. All rights reserved.
//

#import "SMRUtils.h"

NS_ASSUME_NONNULL_BEGIN

@interface SMRUtils (SDWebImage)

+ (void)downloadAndCacheImageWithURL:(nullable NSURL *)url
                           completed:(nullable void(^)(UIImage *))completedBlock;

@end

NS_ASSUME_NONNULL_END
