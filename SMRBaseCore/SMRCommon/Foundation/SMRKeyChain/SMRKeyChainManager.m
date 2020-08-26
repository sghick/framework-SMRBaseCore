//
//  SMRKeyChainManager.m
//  SMRBaseCoreDemo
//
//  Created by Tinswin on 2018/12/27.
//  Copyright © 2018年 sumrise. All rights reserved.
//

#import "SMRKeyChainManager.h"
#import "SMRCryptor.h"

static NSString *const kSMRForUUIDStringInKeyChain = @"kSMRForUUIDStringInKeyChain";

@implementation SMRKeyChainManager

+ (NSString *)uniqueStaticString {
    NSString *uuid = [self readKeyChainValueFromKey:kSMRForUUIDStringInKeyChain];
    if (!uuid.length) {
        //生成一个uuid的方法
        CFUUIDRef uuidRef = CFUUIDCreate(kCFAllocatorDefault);
        uuid = (NSString *)CFBridgingRelease(CFUUIDCreateString (kCFAllocatorDefault,uuidRef));
        if(!uuid.length) {
            uuid = [self serializationString] ?: @"";
        }
        //将该uuid保存到keychain
        [self saveKeyChainValue:uuid key:kSMRForUUIDStringInKeyChain];
    }
    return uuid;
}

+ (NSString *)serializationString {
    NSString *serializationString = [NSString stringWithFormat:@"%04d%04d%010d", arc4random()%1000, arc4random()%1000, (int)[NSDate date].timeIntervalSince1970];
    return serializationString.smr_data.smr_stringByBase64;
}

#pragma mark - KeyChainGeneral

+ (void)saveKeyChainValue:(NSString *)value key:(NSString *)key {
    NSMutableDictionary * keychainQuery = [self getKeyChainQuery:key];
    SecItemDelete((__bridge_retained CFDictionaryRef)keychainQuery);
    [keychainQuery setObject:[NSKeyedArchiver archivedDataWithRootObject:value] forKey:(__bridge_transfer id)kSecValueData];
    SecItemAdd((__bridge_retained CFDictionaryRef)keychainQuery, NULL);
}

+ (NSString *)readKeyChainValueFromKey:(NSString *)key {
    NSString *ret = nil;
    NSMutableDictionary *keychainQuery = [self getKeyChainQuery:key];
    [keychainQuery setObject:(id)kCFBooleanTrue forKey:(__bridge_transfer id)kSecReturnData];
    [keychainQuery setObject:(__bridge_transfer id)kSecMatchLimitOne forKey:(__bridge_transfer id)kSecMatchLimit];
    CFDataRef keyData = NULL;
    if (SecItemCopyMatching((__bridge CFDictionaryRef)keychainQuery, (CFTypeRef *)&keyData) == noErr) {
        @try {
            ret = (NSString *)[NSKeyedUnarchiver unarchiveObjectWithData:(__bridge NSData *)keyData];
        } @catch (NSException *e) {
        } @finally {
        }
    }
    if (keyData)
        CFRelease(keyData);
    return ret;
}

+ (void)deleteKeyChainValueFromKey:(NSString *)key {
    NSMutableDictionary *keychainQuery = [self getKeyChainQuery:key];
    SecItemDelete((__bridge CFDictionaryRef)keychainQuery);
}

+ (NSMutableDictionary *)getKeyChainQuery:(NSString *)key{
    return [NSMutableDictionary dictionaryWithObjectsAndKeys:
            (__bridge_transfer id)kSecClassGenericPassword,
            (__bridge_transfer id)kSecClass,key,
            (__bridge_transfer id)kSecAttrService,key,
            (__bridge_transfer id)kSecAttrAccount,
            (__bridge_transfer id)kSecAttrAccessibleAfterFirstUnlock,
            (__bridge_transfer id)kSecAttrAccessible,
            nil];
}
@end
