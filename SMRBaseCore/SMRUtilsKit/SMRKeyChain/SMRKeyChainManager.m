//
//  SMRKeyChainManager.m
//  SMRBaseCoreDemo
//
//  Created by 丁治文 on 2019/1/21.
//  Copyright © 2019 sumrise. All rights reserved.
//

#import "SMRKeyChainManager.h"

static NSString *const kSMRForUUIDStringInKeyChain = @"kSMRForUUIDStringInKeyChain";

@implementation SMRKeyChainManager

+ (NSString *)UUIDString {
    NSString * uuid = [self readKeyChainValueFromKey:kSMRForUUIDStringInKeyChain];
    if (!uuid && uuid.length) {
        //生成一个uuid的方法
        CFUUIDRef uuidRef = CFUUIDCreate(kCFAllocatorDefault);
        uuid = (NSString *)CFBridgingRelease(CFUUIDCreateString (kCFAllocatorDefault,uuidRef));
        //将该uuid保存到keychain
        [self saveKeyChainValue:uuid key:kSMRForUUIDStringInKeyChain];
    }
    return uuid;
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
