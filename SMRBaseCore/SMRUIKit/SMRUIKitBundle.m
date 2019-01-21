//
//  SMRUIKitBundle.m
//  SMRBaseCoreDemo
//
//  Created by 丁治文 on 2019/1/21.
//  Copyright © 2019 sumrise. All rights reserved.
//

#import "SMRUIKitBundle.h"

@implementation SMRUIKitBundle

+ (instancetype)smr_sourceBundle {
    NSString *path = [[NSBundle bundleForClass:[self class]] pathForResource:@"SMRUIKitBundle" ofType:@"bundle"];
    SMRUIKitBundle *bundle = [SMRUIKitBundle bundleWithPath:path];
    return bundle;
}

+ (UIImage *)smr_imageWithName:(NSString *)name {
    NSString *pic_name = [name stringByDeletingPathExtension];
    NSString *path_extension = [name pathExtension].length?[name pathExtension]:@"png";
    NSString *imagePath = [[self smr_sourceBundle] pathForResource:pic_name ofType:path_extension];
    UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
    return image;
}

@end
