//
//  SMRLogSys.h
//  SMRLogSystemDemo
//
//  Created by 丁治文 on 2018/8/15.
//  Copyright © 2018年 tinswin. All rights reserved.
//

#import <Foundation/Foundation.h>

#define SMRFunctionName          (SMRToString(@"%s", __PRETTY_FUNCTION__))
#define SMRToString(a...)        ([NSString stringWithFormat:a])

#define SMRLog0(desc, lbl) \
([SMRLogSys outputSMRLogToFile:SMRToString(desc) fcName:SMRFunctionName label:lbl])
#define SMRLog1(desc, arg1, lbl) \
            ([SMRLogSys outputSMRLogToFile:SMRToString(desc, arg1) fcName:SMRFunctionName label:lbl])
#define SMRLog2(desc, arg1, arg2, lbl) \
            ([SMRLogSys outputSMRLogToFile:SMRToString(desc, arg1, arg2) fcName:SMRFunctionName label:lbl])
#define SMRLog3(desc, arg1, arg2, arg3, lbl) \
            ([SMRLogSys outputSMRLogToFile:SMRToString(desc, arg1, arg2, arg3) fcName:SMRFunctionName label:lbl])
#define SMRLog4(desc, arg1, arg2, arg3, arg4, lbl) \
            ([SMRLogSys outputSMRLogToFile:SMRToString(desc, arg1, arg2, arg3, arg4) fcName:SMRFunctionName label:lbl])
#define SMRLog5(desc, arg1, arg2, arg3, arg4, arg5, lbl) \
            ([SMRLogSys outputSMRLogToFile:SMRToString(desc, arg1, arg2, arg3, arg4, arg5) fcName:SMRFunctionName label:lbl])

@interface SMRLogSys : NSObject

/// 默认:NO,无log输出;设置为YES后开启输出,并且此状态会缓存在沙盒
+ (BOOL)debug;
+ (void)setDebug:(BOOL)debug;
+ (void)toggleDebug;

/// 日志同时会显示在控制台上
+ (void)outputSMRLogToFile:(NSString *)log fcName:(NSString *)fcName label:(NSString *)label;
/// 将NSLog的日志备份到文件,设置了这个选项后,控制台将不会显示log了
+ (void)outputNSlogToFile;

/// 设置完此时间后,log可显示相对时间
+ (void)setBeginTime;
/// 清除
+ (BOOL)clear;
/// 打印日志输出的地址
+ (void)printFilePath;

@end
