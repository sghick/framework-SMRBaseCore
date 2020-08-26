//
//  SMRUIKitBundle.m
//  SMRBaseCoreDemo
//
//  Created by 丁治文 on 2019/1/15.
//  Copyright © 2019 sumrise. All rights reserved.
//

#import "SMRUIKitBundle.h"

@implementation SMRUIKitBundle

+ (instancetype)sourceBundle {
    NSString *path = [[NSBundle bundleForClass:[self class]] pathForResource:@"SMRUIKitBundle" ofType:@"bundle"];
    SMRUIKitBundle *bundle = [SMRUIKitBundle bundleWithPath:path];
    return bundle;
}

+ (UIImage *)imageNamed:(NSString *)name {
    NSString *pic_name = [name stringByDeletingPathExtension];
    NSString *path_extension = [name pathExtension].length?[name pathExtension]:@"png";
    NSString *imagePath = [[self sourceBundle] pathForResource:pic_name ofType:path_extension];
    UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
    return image;
}

@end
