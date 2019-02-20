//
//  SMRPhoneInfo.m
//  SMRBaseCoreDemo
//
//  Created by 丁治文 on 2019/1/21.
//  Copyright © 2019 sumrise. All rights reserved.
//

#import "SMRPhoneInfo.h"
// 可否使用广告标识IDFA
#define IDFA_AVAILABLE  (1)

#import "SMRPhoneInfo.h"
#import "SMRKeyChainManager.h"
#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
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

// private
+ (NSString *)IDFAString {
#if IDFA_AVAILABLE && !TARGET_OS_WATCH
    NSString *uuid = [SMRKeyChainManager readKeyChainValueFromKey:kSMRForIDFAStringInKeyChain];
    if (!uuid && !uuid.length) {
        //生成一个uuid的方法
        uuid = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
        if (!uuid && !uuid.length) {
            uuid = [NSUUID UUID].UUIDString;
        }
        //将该uuid保存到keychain
        [SMRKeyChainManager saveKeyChainValue:uuid key:kSMRForIDFAStringInKeyChain];
    }
    NSLog(@"IDFA:%@", uuid);
    return uuid;
#else
    return @"";
#endif
}

// private
+ (NSString *)IDFVString {
    NSString *uuid = [SMRKeyChainManager readKeyChainValueFromKey:kSMRForIDFVStringInKeyChain];
    if (!uuid || !uuid.length) {
        //生成一个uuid的方法
        uuid = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
        if (!uuid && !uuid.length) {
            uuid = [NSUUID UUID].UUIDString;
        }
        //将该uuid保存到keychain
        [SMRKeyChainManager saveKeyChainValue:uuid key:kSMRForIDFVStringInKeyChain];
    }
    NSLog(@"IDFV:%@", uuid);
    return uuid;
}

+ (NSString *)imeiString {
    return [self IDFAString];
}

+ (NSString *)imsiString {
    return [self IDFVString];
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

+ (NSString *)webUserAgent {
#if !TARGET_OS_WATCH
    NSString *userAgentString = [[[UIWebView alloc] init] stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
    return userAgentString;
#else
    return @"";
#endif
}

@end
