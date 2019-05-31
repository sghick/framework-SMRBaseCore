//
//  UIImage+SMRGif.m
//  SMRBaseCoreDemo
//
//  Created by 丁治文 on 2019/5/31.
//  Copyright © 2019 sumrise. All rights reserved.
//

#import "UIImage+SMRGif.h"

@implementation UIImage (SMRGif)

- (NSArray<UIImage *> *)smr_gifImages {
    if (self.images.count) {
        return self.images;
    }
    return @[self];
}

@end
