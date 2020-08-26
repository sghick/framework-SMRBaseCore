//
//  SMRPhoneInfo.m
//  SMRBaseCoreDemo
//
//  Created by 丁治文 on 2019/1/2.
//  Copyright © 2019 sumrise. All rights reserved.
//

// 可否使用广告标识IDFA
#define IDFA_AVAILABLE  (1)

#import "SMRPhoneInfo.h"
#import "SMRKeyChainManager.h"
#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <WebKit/WebKit.h>
#import "SMRLog.h"
#if IDFA_AVAILABLE
#import <AdSupport/AdSupport.h>
#endif
#import <UIKit/UIKit.h>
#import "sys/utsname.h"

#if IDFA_AVAILABLE
static NSString *const kSMRForIDFAStringInKeyChain = @"kSMRForIDFAStringInKeyChain";
#endif
static NSString *const kSMRForIDFVStringInKeyChain = @"kSMRForIDFVStringInKeyChain";

@implementation SMRPhoneInfo

+ (NSString *)originalUUID {
    return [SMRKeyChainManager uniqueStaticString];
}

+ (NSString *)IDFAString {
#if IDFA_AVAILABLE && !TARGET_OS_WATCH
    NSString *uuid = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    base_core_log(@"IDFA:%@", uuid);
    return uuid;
#else
    return @"";
#endif
}

+ (NSString *)IDFVString {
    NSString *uuid = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    base_core_log(@"IDFV:%@", uuid);
    return uuid ?: @"";
}

+ (NSString *)imeiString {
    return [self IDFAString];
}

+ (NSString *)imsiString {
    NSString *uuid = [SMRKeyChainManager readKeyChainValueFromKey:kSMRForIDFVStringInKeyChain];
    if (!uuid || !uuid.length) {
        //生成一个uuid的方法
        uuid = [self IDFVString] ?: @"";
        if(!uuid.length) {
            uuid = [self originalUUID] ?: @"";
        }
        //将该uuid保存到keychain
        [SMRKeyChainManager saveKeyChainValue:uuid key:kSMRForIDFVStringInKeyChain];
    }
    return uuid;
}

+ (NSString *)systemName {
    return [NSString stringWithFormat:@"%@", [[UIDevice currentDevice] systemName]];
}

+ (NSString *)systemVersionString {
#if !TARGET_OS_WATCH
    return [NSString stringWithFormat:@"%@", [[UIDevice currentDevice] systemVersion]];
#else
    return @"";
#endif
}

+ (NSString *)machineString {
    // 需要#import "sys/utsname.h"
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    return deviceString;
}

+ (NSString *)phoneBrand {
    return @"Apple";
}

+ (NSString *)netOperator {
#if !TARGET_OS_WATCH
    CTTelephonyNetworkInfo *info = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = info.subscriberCellularProvider;
    return [NSString stringWithFormat:@"%@%@", carrier.mobileCountryCode, carrier.mobileNetworkCode];
#else
    return @"";
#endif
}

+ (void)webUserAgentForWK:(void (^)(NSString * _Nonnull))completion {
#if !TARGET_OS_WATCH
    __block WKWebView *web = [[WKWebView alloc] init];
    [web evaluateJavaScript:@"navigator.userAgent" completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        if (completion) {
            completion(result ?: @"");
        }
        web = nil;
    }];
#else
    if (completion) {
        completion(@"");
    }
#endif
}

+ (NSString *)appUserAgent {
    NSString *userAgent = nil;
#if TARGET_OS_IOS
    // User-Agent Header; see http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.43
    userAgent = [NSString stringWithFormat:@"%@/%@ (%@; iOS %@; Scale/%0.2f)", [[NSBundle mainBundle] infoDictionary][(__bridge NSString *)kCFBundleExecutableKey] ?: [[NSBundle mainBundle] infoDictionary][(__bridge NSString *)kCFBundleIdentifierKey], [[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"] ?: [[NSBundle mainBundle] infoDictionary][(__bridge NSString *)kCFBundleVersionKey], [[UIDevice currentDevice] model], [[UIDevice currentDevice] systemVersion], [[UIScreen mainScreen] scale]];
#elif TARGET_OS_WATCH
    // User-Agent Header; see http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.43
    userAgent = [NSString stringWithFormat:@"%@/%@ (%@; watchOS %@; Scale/%0.2f)", [[NSBundle mainBundle] infoDictionary][(__bridge NSString *)kCFBundleExecutableKey] ?: [[NSBundle mainBundle] infoDictionary][(__bridge NSString *)kCFBundleIdentifierKey], [[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"] ?: [[NSBundle mainBundle] infoDictionary][(__bridge NSString *)kCFBundleVersionKey], [[WKInterfaceDevice currentDevice] model], [[WKInterfaceDevice currentDevice] systemVersion], [[WKInterfaceDevice currentDevice] screenScale]];
#elif defined(__MAC_OS_X_VERSION_MIN_REQUIRED)
    userAgent = [NSString stringWithFormat:@"%@/%@ (Mac OS X %@)", [[NSBundle mainBundle] infoDictionary][(__bridge NSString *)kCFBundleExecutableKey] ?: [[NSBundle mainBundle] infoDictionary][(__bridge NSString *)kCFBundleIdentifierKey], [[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"] ?: [[NSBundle mainBundle] infoDictionary][(__bridge NSString *)kCFBundleVersionKey], [[NSProcessInfo processInfo] operatingSystemVersionString]];
#endif
    if (userAgent) {
        if (![userAgent canBeConvertedToEncoding:NSASCIIStringEncoding]) {
            NSMutableString *mutableUserAgent = [userAgent mutableCopy];
            if (CFStringTransform((__bridge CFMutableStringRef)(mutableUserAgent), NULL, (__bridge CFStringRef)@"Any-Latin; Latin-ASCII; [:^ASCII:] Remove", false)) {
                userAgent = mutableUserAgent;
            }
        }
    }
    return userAgent;
}

@end
