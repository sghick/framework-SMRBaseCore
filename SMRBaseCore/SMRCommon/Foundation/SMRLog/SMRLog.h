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

// BaseCore 日志
#define base_core_log(...) ([SMRBaseCoreInfoHelper baseCoreLog]?NSLog(__VA_ARGS__):NULL)

#endif /* SMRLog_h */
