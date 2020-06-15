//
//  SMRUtils+NSDate.m
//  SMRBaseCoreDemo
//
//  Created by 丁治文 on 2019/2/14.
//  Copyright © 2019 sumrise. All rights reserved.
//

#import "SMRUtils+NSDate.h"

@implementation SMRUtils (NSDate)

+ (NSDate *)convertToDateFromDateString:(NSString *)dateString format:(NSString *)format {
    if (!dateString) {
        return nil;
    }
    if (!format) {
        format = @"yyyy-MM-dd HH:mm:ss";
    }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    NSDate *retDate = [dateFormatter dateFromString:dateString];
    return retDate;
}

+ (NSString *)convertToStringFromDate:(NSDate *)date format:(NSString *)format {
    if (!date) {
        return nil;
    }
    if (!format) {
        format = @"yyyy-MM-dd HH:mm:ss";
    }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    NSString *retString = [dateFormatter stringFromDate:date];
    return retString;
}

+ (NSDate *)convertToDateFromTimerInterval:(NSTimeInterval)timeInterval {
    if (timeInterval == 0) {
        return [NSDate date];
    }
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    return  date;
}

+ (NSString *)convertToStringFromTimerInterval:(NSTimeInterval)timeInterval format:(NSString *)format {
    if (!format) {
        format = @"yyyy-MM-dd HH:mm:ss";
    }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    NSDate *date = [self convertToDateFromTimerInterval:timeInterval];
    return  [dateFormatter stringFromDate:date];
}

+ (NSDate *)pureDayWithDate:(NSDate *)date {
    if (date == nil) {
        return nil;
    }
    unsigned int flags = NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond;
    NSDateComponents *parts = [[NSCalendar currentCalendar] components:flags fromDate:date];
    [parts setHour:0];
    [parts setMinute:0];
    [parts setSecond:0];
    return [[NSCalendar currentCalendar] dateFromComponents:parts];
}

+ (NSInteger)numberOfDaysWithFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate {
    if (!fromDate || !toDate) {
        return 0;
    }
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comp = [calendar components:NSCalendarUnitDay fromDate:fromDate toDate:toDate options:NSCalendarWrapComponents];
    return comp.day;
}

+ (NSInteger)numberOfUnitDaysWithFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate {
    if (!fromDate || !toDate) {
        return 0;
    }
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    // 去掉时分秒信息
    NSDate *fromDt = nil;
    NSDate *toDt = nil;
    [calendar rangeOfUnit:NSCalendarUnitDay startDate:&fromDt interval:NULL forDate:fromDate];
    [calendar rangeOfUnit:NSCalendarUnitDay startDate:&toDt interval:NULL forDate:toDate];
    NSDateComponents *comp = [calendar components:NSCalendarUnitDay fromDate:fromDate toDate:toDate options:NSCalendarWrapComponents];
    return comp.day;
}

+ (NSTimeInterval)trimDayFromTimerInterval:(NSTimeInterval)timeInterval {
    NSDate *fromDate = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    NSDate *fromDt = [self trimDayFromDate:fromDate];
    NSTimeInterval rtn = [fromDt timeIntervalSince1970];
    return rtn;
}

+ (NSDate *)trimDayFromDate:(NSDate *)fromDate {
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *fromDt = nil;
    [calendar rangeOfUnit:NSCalendarUnitDay startDate:&fromDt interval:NULL forDate:fromDate];
    return fromDt;
}

@end
