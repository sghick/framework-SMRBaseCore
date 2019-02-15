//
//  SMRUtils+File.m
//  SMRBaseCoreDemo
//
//  Created by 丁治文 on 2019/2/14.
//  Copyright © 2019 sumrise. All rights reserved.
//

#import "SMRUtils+File.h"

@implementation SMRUtils (File)

+ (double)getFreeDiskspace {
    double totalSpace = 0.0f;
    double totalFreeSpace = 0.0f;
    NSError *error = nil;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSDictionary *dictionary = [[NSFileManager defaultManager] attributesOfFileSystemForPath:[paths lastObject] error: &error];
    
    if (dictionary) {
        NSNumber *fileSystemSizeInBytes = [dictionary objectForKey:NSFileSystemSize];
        NSNumber *freeFileSystemSizeInBytes = [dictionary objectForKey:NSFileSystemFreeSize];
        totalSpace = [fileSystemSizeInBytes doubleValue];
        totalFreeSpace = [freeFileSystemSizeInBytes doubleValue];
        NSLog(@"Memory Capacity of %f MiB with %f MiB Free memory available.", ((totalSpace/1024.0f)/1024.0f), ((totalFreeSpace/1024.0f)/1024.0f));
    } else {
        NSLog(@"Error Obtaining System Memory Info: Domain = %@, Code = %ld", [error domain], (long)[error code]);
    }
    return ((totalFreeSpace/1024.0f)/1024.0f);
}

+ (double)getFilesSize:(NSString *)filePath {
    NSError *error;
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    NSEnumerator *fileNameEnuerator = [[fileManager subpathsAtPath:filePath] objectEnumerator];
    NSString *fileName;
    long long size = 0;
    while ((fileName = [fileNameEnuerator nextObject] )!= nil) {
        NSString *obslutly = [NSString stringWithFormat:@"%@%@",filePath, fileName];
        size += [[fileManager attributesOfItemAtPath:obslutly error:&error] fileSize];
    }
    return size/1024.0;
}

+ (double)getCachesFilesSize:(NSString *)filePath {
    NSError *error;
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    NSEnumerator *fileNameEnuerator = [[fileManager subpathsAtPath:filePath] objectEnumerator];
    NSString *fileName;
    long long size = 0;
    while ((fileName = [fileNameEnuerator nextObject] )!= nil) {
        NSString *obslutly = [NSString stringWithFormat:@"%@/%@",filePath, fileName];
        size += [[fileManager attributesOfItemAtPath:obslutly error:&error] fileSize];
    }
    return size/1024.0;
}

@end
