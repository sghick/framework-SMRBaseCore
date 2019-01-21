//
//  SMRLogSys.m
//  SMRLogSystemDemo
//
//  Created by 丁治文 on 2018/8/15.
//  Copyright © 2018年 tinswin. All rights reserved.
//

#import "SMRLogSys.h"
#import "SMRLogScreen.h"

#ifndef NSLog
#define NSLog(FORMAT, ...) NSLog((@"[%s" ":%d行]" FORMAT), [[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, ##__VA_ARGS__)

#endif

static NSString *const kSMRLogSysDebug = @"kSMRLogSysDebug";
static bool _staticLogSysDebug = NO;

@implementation SMRLogSys

+ (void)load {
    _staticLogSysDebug = [[NSUserDefaults standardUserDefaults] boolForKey:kSMRLogSysDebug];
}

+ (NSString *)logTypeSMRLogDocPath {
    NSString *fileDoc = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"SMRLog"];
    return fileDoc;
}

+ (NSString *)logTypeNSLogDocPath {
    NSString *fileDoc = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"NSLog"];
    return fileDoc;
}

+ (NSDateFormatter *)dateFormatter {
    NSDateFormatter *dateformat = [[NSDateFormatter alloc] init];
    [dateformat setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSSS"];
    return dateformat;
}

#pragma mark - Public
+ (BOOL)debug {
    return _staticLogSysDebug;
}

+ (void)setDebug:(BOOL)debug {
    _staticLogSysDebug = debug;
    [[NSUserDefaults standardUserDefaults] setBool:debug forKey:kSMRLogSysDebug];
}

+ (void)toggleDebug {
    [self setDebug:![self debug]];
}

+ (void)outputSMRLogToFile:(NSString *)log fcName:(NSString *)fcName label:(NSString *)label {
    if (![self debug]) {
        return;
    }
    NSFileManager *defaultManager = [NSFileManager defaultManager];
    NSString *docPath = [self logTypeSMRLogDocPath];
    if (![defaultManager fileExistsAtPath:docPath]) {
        [defaultManager createDirectoryAtPath:docPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    NSDateFormatter *dateformat = [[NSDateFormatter alloc] init];
    [dateformat setDateFormat:@"yyyyMMdd_HH_mm"];
    NSString *fileName = [NSString stringWithFormat:@"SMRLog_%@.txt",[dateformat stringFromDate:[NSDate date]]];
    NSString *logFilePath = [docPath stringByAppendingPathComponent:fileName];
    if (![defaultManager fileExistsAtPath:logFilePath]) {
        [defaultManager createFileAtPath:logFilePath contents:nil attributes:nil];
    }
    
    // 差值:s
    NSTimeInterval rar = 0;
    NSDate *date = [NSDate date];
    if (_beginTime > 0) {
        NSTimeInterval dt = [date timeIntervalSince1970];
        rar = dt - _beginTime;
    }
    NSString *logDate = [[self dateFormatter] stringFromDate:date];
    NSString *content = nil;
    if (rar == 0) {
        content = [NSString stringWithFormat:@"%@ %@ %@\n", logDate, fcName, log];
    } else {
        content = [NSString stringWithFormat:@"%@ %@ %.4lfs %@\n", logDate, fcName, rar, log];
    }
    NSLog(@"%@", content);
    NSData *buffer = [content dataUsingEncoding:NSUTF8StringEncoding];
    NSFileHandle *outFile = [NSFileHandle fileHandleForWritingAtPath:logFilePath];
    if (!outFile) {
        NSLog(@"获取文件句柄失败");
        return;
    }
    [outFile seekToEndOfFile];
    [outFile writeData:buffer];
    [outFile closeFile];
    
    [SMRLogScreen addLine:content linebreak:YES groupLabel:label];
}

+ (void)outputNSlogToFile {
    if (![self debug]) {
        return;
    }
    NSFileManager *defaultManager = [NSFileManager defaultManager];
    NSString *docPath = [self logTypeNSLogDocPath];
    if (![defaultManager fileExistsAtPath:docPath]) {
        [defaultManager createDirectoryAtPath:docPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    NSDateFormatter *dateformat = [[NSDateFormatter alloc] init];
    [dateformat setDateFormat:@"yyyyMMdd_HH_mm"];
    NSString *fileName = [NSString stringWithFormat:@"NSLog_%@.txt",[dateformat stringFromDate:[NSDate date]]];
    NSString *logFilePath = [docPath stringByAppendingPathComponent:fileName];
    
    // 先删除已经存在的文件
    [defaultManager removeItemAtPath:logFilePath error:nil];
    
    // 将log输入到文件
    freopen([logFilePath cStringUsingEncoding:NSASCIIStringEncoding], "a+", stdout);
    
    freopen([logFilePath cStringUsingEncoding:NSASCIIStringEncoding], "a+", stderr);
}

#pragma mark - Others

static NSTimeInterval _beginTime = 0;
+ (void)setBeginTime {
    NSDate *date = [NSDate date];
    _beginTime = [date timeIntervalSince1970];
    NSString *content = [[self dateFormatter] stringFromDate:date];
    NSString *log = [NSString stringWithFormat:@"已设置时间起点:%@", content];
    [self outputSMRLogToFile:log fcName:nil label:nil];
}

+ (void)printFilePath {
    NSLog(@"SMRLogPath:%@", [self logTypeSMRLogDocPath]);
    NSLog(@"NSLogPath:%@", [self logTypeNSLogDocPath]);
}

+ (BOOL)clear {
    NSFileManager *manager = [[NSFileManager alloc] init];
    NSArray<NSString *> *fileDocs = @[[self logTypeSMRLogDocPath], [self logTypeNSLogDocPath]];
    for (NSString *fd in fileDocs) {
        if ([manager fileExistsAtPath:fd]) {
            return [manager removeItemAtPath:fd error:nil];
        }
    }
    return YES;
}

@end
