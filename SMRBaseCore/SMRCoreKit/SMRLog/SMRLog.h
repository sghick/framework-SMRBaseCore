//
//  SMRLog.h
//  SMRBaseCoreDemo
//
//  Created by Tinswin on 2020/3/31.
//  Copyright © 2020 sumrise. All rights reserved.
//

#ifndef SMRLog_h
#define SMRLog_h

/**
 日志启用方式:
 Build Settings -> Apple Clang Preprocessing -> Preprocesser Macros -> DEBUG
 定义 BDS_BASE_CORE_LOG=1 即可显示对应类型的日志
 */

// BaseCore 日志
#if SMR_BASE_CORE_LOG
#define smr_base_core_log(...) (NSLog(__VA_ARGS__))
#else
#define smr_base_core_log(...)
#endif

#endif /* SMRLog_h */
