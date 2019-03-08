//
//  SMRNetInfo.m
//  SMRBaseCoreDemo
//
//  Created by 丁治文 on 2019/1/21.
//  Copyright © 2019 sumrise. All rights reserved.
//

#import "SMRNetInfo.h"
#import <time.h>
#import <xlocale.h>
#import "SMRNetManager.h"
#import "SMRNetConfig.h"

@implementation SMRNetInfo

+ (void)syncNetInfoWithResponse:(NSHTTPURLResponse *)response {
    if (![response isKindOfClass:[NSHTTPURLResponse class]]) {
        NSLog(@"请求失败或收接到非 NSHTTPURLResponse 对象,无法同步NetInfo.");
        return;
    }
    NSString *rfcDateString = response.allHeaderFields[@"Date"];
    NSString *cookieString = response.allHeaderFields[@"Set-Cookie"];
    
    if(rfcDateString) {
        NSDate *serverDate = [SMRNetInfo dateFromRFC1123:rfcDateString];
        [SMRNetInfo syncDateWithServerDate:serverDate];
    }
    
    if(cookieString) {
        [SMRNetInfo setCookie:cookieString];
        NSString *sid = [SMRNetInfo parseSIDFromCookie];
        if (sid) {
            [SMRNetInfo setSession:sid];
        }
    }
}

#pragma mark - Date

+ (void)syncDateWithServerDate:(NSDate *)serverDate {
    double delta = [serverDate timeIntervalSince1970] - [[NSDate date] timeIntervalSince1970];
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:[NSNumber numberWithDouble:delta] forKey:@"serverSyncDate"];
}

+ (NSDate *)syncedDate {
    NSDate *now = [NSDate date];
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    if([ud objectForKey:@"serverSyncDate"]) {
        double synced = [now timeIntervalSince1970] + [[ud objectForKey:@"serverSyncDate"] doubleValue];
        NSDate *syncedDate = [NSDate dateWithTimeIntervalSince1970:synced];
        return syncedDate;
    }
    return now;
}

#pragma mark - UserDefaults

static NSUserDefaults *_ud = nil;
+ (NSUserDefaults *)netUserDefaults {
    if (!_ud) {
        _ud = [[NSUserDefaults alloc] initWithSuiteName:[SMRNetManager sharedManager].config.infoGroupID];
    }
    return _ud;
}

#pragma mark- Cookie And Session

+ (NSString *)parseSIDFromCookie {
    NSString *cookieString = [self getCookie];
    NSString *sid = nil;
    if (cookieString) {
        NSArray *cookieItem = [cookieString componentsSeparatedByString:@";"];
        for (NSString *item in cookieItem) {
            NSRange itemRange = [item rangeOfString:@"sid="];
            if (itemRange.location != NSNotFound) {
                sid = [[item componentsSeparatedByString:@"="] objectAtIndex:1];
                break;
            }
        }
    }
    return sid;
}

static NSString *_cookie = nil;
+ (NSString *)getCookie {
    if (![self isNullOrEmptyString:_cookie]) {
        return _cookie;
    }
    else {
        NSString *str = [[self netUserDefaults] objectForKey:@"cookie"];
        if (![self isNullOrEmptyString:str]) {
            _cookie = str;
            return _cookie;
        } else {
            return @"";
        }
    }
}

+ (void)setCookie:(NSString *)cookie {
    _cookie = cookie;
    [[self netUserDefaults] setObject:cookie forKey:@"cookie"];
}

static NSString *_session = nil;
+ (NSString *)getSession {
    if (![self isNullOrEmptyString:_session]) {
        return _session;
    }
    else {
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        NSString *str = [ud objectForKey:@"session"];
        if (![self isNullOrEmptyString:str]) {
            _session = str;
            return _session;
        } else {
            return @"";
        }
    }
}

+ (void)setSession:(NSString *)session {
    _session = session;
    [[self netUserDefaults] setObject:session forKey:@"session"];
}

#pragma mark - RFC1123

+ (NSDate *)dateFromRFC1123:(NSString *)value {
    return _SMRDateFromRFC1123(value);
}

+ (NSString *)rfc1123StringWithDate:(NSDate *)date {
    return _SMRRfc1123StringWithDate(date);
}

static NSDate *_SMRDateFromRFC1123(NSString *value_) {
    if(value_ == nil)
        return nil;
    
    const char *str = [value_ UTF8String];
    const char *fmt;
    NSDate *retDate;
    char *ret;
    
    fmt = "%a, %d %b %Y %H:%M:%S %Z";
    struct tm rfc1123timeinfo;
    memset(&rfc1123timeinfo, 0, sizeof(rfc1123timeinfo));
    ret = strptime_l(str, fmt, &rfc1123timeinfo, NULL);
    if (ret) {
        time_t rfc1123time = mktime(&rfc1123timeinfo);
        retDate = [NSDate dateWithTimeIntervalSince1970:rfc1123time];
        if (retDate != nil)
            return retDate;
    }
    
    
    fmt = "%A, %d-%b-%y %H:%M:%S %Z";
    struct tm rfc850timeinfo;
    memset(&rfc850timeinfo, 0, sizeof(rfc850timeinfo));
    ret = strptime_l(str, fmt, &rfc850timeinfo, NULL);
    if (ret) {
        time_t rfc850time = mktime(&rfc850timeinfo);
        retDate = [NSDate dateWithTimeIntervalSince1970:rfc850time];
        if (retDate != nil)
            return retDate;
    }
    
    fmt = "%a %b %e %H:%M:%S %Y";
    struct tm asctimeinfo;
    memset(&asctimeinfo, 0, sizeof(asctimeinfo));
    ret = strptime_l(str, fmt, &asctimeinfo, NULL);
    if (ret) {
        time_t asctime = mktime(&asctimeinfo);
        return [NSDate dateWithTimeIntervalSince1970:asctime];
    }
    
    return nil;
}

static NSString *_SMRRfc1123StringWithDate(NSDate *date) {
    time_t t = (time_t)[date timeIntervalSince1970];
    struct tm timeinfo;
    gmtime_r(&t, &timeinfo);
    char buffer[32];
    size_t ret = strftime_l(buffer, sizeof(buffer), "%a, %d %b %Y %H:%M:%S GMT", &timeinfo, NULL);
    if (ret) {
        return @(buffer);
    } else {
        return nil;
    }
}

#pragma mark - Utils

+ (BOOL)isNullOrEmptyString:(NSString *)str {
    if (str && [str isKindOfClass:[NSString class]] && str.length > 0) {
        return NO;
    }
    else {
        return YES;
    }
}

@end
