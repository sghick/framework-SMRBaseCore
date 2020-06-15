//
//  SMRUtils+File.h
//  SMRBaseCoreDemo
//
//  Created by 丁治文 on 2019/2/14.
//  Copyright © 2019 sumrise. All rights reserved.
//

#import "SMRUtils.h"

NS_ASSUME_NONNULL_BEGIN

@interface SMRUtils (File)

/** 获取磁盘剩余空间(单位:MB) */
+ (double)getFreeDiskspace;

/** 获取文件大小(单位:KB) */
+ (double)getFilesSize:(NSString *)filePath;

/** 获取缓存文件大小(单位:KB) */
+ (double)getCachesFilesSize:(NSString *)filePath;

@end

NS_ASSUME_NONNULL_END
