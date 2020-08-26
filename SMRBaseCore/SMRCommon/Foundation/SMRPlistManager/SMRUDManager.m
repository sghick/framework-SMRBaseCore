//
//  SMRUDManager.m
//  SMRBaseCoreDemo
//
//  Created by Tinswin on 2019/1/2.
//  Copyright © 2019年 sumrise. All rights reserved.
//

#import "SMRUDManager.h"

@implementation SMRUDManager

+ (NSString *)p_savePathWithPathName:(NSString *)pathName {
    NSString *fileDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *path = [fileDirectory stringByAppendingString:[NSString stringWithFormat:@"/%@.plist", pathName]];
    return path;
}

+ (void)smr_saveValueToUDWithObject:(id)obj PathName:(nonnull NSString *)pathName{
    NSString *path = [self p_savePathWithPathName:pathName];
    [NSKeyedArchiver archiveRootObject:obj toFile:path];
}

+ (id)smr_getValueFromUDWithPathName:(NSString *)pathName {
    NSString *path = [self p_savePathWithPathName:pathName];
    return [NSKeyedUnarchiver unarchiveObjectWithFile:path];
}

+ (void)smr_deleteValueFromUDWithPathName:(NSString *)pathName {
    NSFileManager *fileManager=[NSFileManager defaultManager];
    NSString *path = [self p_savePathWithPathName:pathName];
    if ([fileManager fileExistsAtPath:path]) {
        [fileManager removeItemAtPath:path error:nil];
    }
}

@end
