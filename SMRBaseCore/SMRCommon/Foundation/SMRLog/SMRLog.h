//
//  SMRLog.h
//  SMRBaseCoreDemo
//
//  Created by Tinswin on 2020/3/31.
//  Copyright © 2020 sumrise. All rights reserved.
//

#ifndef SMRLog_h
#define SMRLog_h
#import "SMRBaseCoreInfoHelper.h"

// BaseCore 日志(低频日志)
#define base_core_log(...) ([SMRBaseCoreInfoHelper baseCoreLog]?NSLog(__VA_ARGS__):NULL)

// BaseCoreDatas 日志(高频日志)
#define base_core_datas_log(...) ([SMRBaseCoreInfoHelper baseCoreDatasLog]?NSLog(__VA_ARGS__):NULL)

// BaseCoreWarning 日志(警告日志)
#define base_core_warning_log(...) ([SMRBaseCoreInfoHelper baseCoreWarningLog]?NSLog(__VA_ARGS__):NULL)

#endif /* SMRLog_h */
