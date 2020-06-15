//
//  SMRUtils+NSDate.h
//  SMRBaseCoreDemo
//
//  Created by 丁治文 on 2019/2/14.
//  Copyright © 2019 sumrise. All rights reserved.
//

#import "SMRUtils.h"

NS_ASSUME_NONNULL_BEGIN

@interface SMRUtils (NSDate)

/** 字符串转日期 */
+ (NSDate *)convertToDateFromDateString:(NSString *)dateString format:(NSString *)format;

/** 日期转字符串 */
+ (NSString *)convertToStringFromDate:(NSDate *)date format:(NSString *)format;

/** 时间缀转日期(单位:s) */
+ (NSDate *)convertToDateFromTimerInterval:(NSTimeInterval)timeInterval;

/** 时间缀转字符串(单位:s) */
+ (NSString *)convertToStringFromTimerInterval:(NSTimeInterval)timeInterval format:(NSString *)format;

/** 某日期的0点 */
+ (NSDate *)pureDayWithDate:(NSDate *)date;

/** 两个日期相差天数(参数日期为nil,返回0) */
+ (NSInteger)numberOfDaysWithFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate;

/** 两个日期相差的天数(如:2018-1-23日 21:00 与 2018-1-24日 08:00, 相差也是一天,返回1)(参数日期为nil,返回0) */
+ (NSInteger)numberOfUnitDaysWithFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate;

/** 去除日期中的时分秒,恢复到当日00:00 */
+ (NSTimeInterval)trimDayFromTimerInterval:(NSTimeInterval)timeInterval;

/** 去除日期中的时分秒,恢复到当日00:00 */
+ (NSDate *)trimDayFromDate:(NSDate *)fromDate;

@end

NS_ASSUME_NONNULL_END
