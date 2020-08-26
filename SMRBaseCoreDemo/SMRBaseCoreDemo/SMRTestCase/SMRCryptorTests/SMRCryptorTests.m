//
//  SMRCryptorTests.m
//  SMRBaseCoreDemo
//
//  Created by Tinswin on 2020/4/21.
//  Copyright © 2020 sumrise. All rights reserved.
//

#import "SMRCryptorTests.h"
#import <CocoaSecurity/Base64.h>
#import <CocoaSecurity/CocoaSecurity.h>

@implementation SMRCryptorTests

- (id)begin {
    [self test_base64EcodingString];
    [self test_hexString];
    [self test_aesSha384];
    [self test_aesCbc];
    [self test_md5];
    return self;
}

- (void)test_base64EcodingString {
    NSString *stringO = @"this is an example";
    NSString *stringB = @"dGhpcyBpcyBhbiBleGFtcGxl";
    
    NSData *dataO = [stringO smr_data];
    NSData *dataB = [stringB smr_dataByBase64];
    NSAssert([dataO isEqualToData:dataB], @"");
    
    NSString *string1 = [dataO smr_stringByBase64];
    NSString *string2 = [dataO base64EncodedString];
    NSAssert([string1 isEqualToString:string2], @"");
    NSAssert([string1 isEqualToString:stringB], @"");
    
    NSString *string3 = [dataO smr_string];
    NSAssert([string3 isEqualToString:stringO], @"");
}

- (void)test_hexString {
    NSString *stringS = @"this is an@";
    NSString *stringO = @"this is an@ example";
    NSString *stringB = @"7468697320697320616e40206578616d706c65";
    
    NSData *dataO = [stringO smr_data];
    NSData *dataB = [stringB smr_dataByHex];
    NSAssert([dataO isEqualToData:dataB], @"");
    
    CocoaSecurityDecoder *decoder = [[CocoaSecurityDecoder alloc] init];
    NSData *data1 = [decoder hex:stringB];
    NSData *data2 = [stringB smr_dataByHex];
    NSData *data3 = [stringB.uppercaseString smr_dataByHex];
    NSAssert([data1 isEqualToData:dataO], @"");
    NSAssert([data2 isEqualToData:dataO], @"");
    NSAssert([data3 isEqualToData:dataO], @"");
    
    CocoaSecurityEncoder *encoder = [[CocoaSecurityEncoder alloc] init];
    NSString *string1 = [encoder hex:dataO useLower:YES];
    NSString *string2 = [dataO smr_stringByHex];
    NSString *string3 = [dataO smr_stringByHexWithLength:stringO.length + 8];
    NSString *string4 = [dataO smr_stringByHexWithLength:stringO.length - 8];
    NSAssert([string1 isEqualToString:stringB], @"");
    NSAssert([string2 isEqualToString:stringB], @"");
    NSAssert([string3 isEqualToString:stringB], @"");
    NSAssert([string4 isEqualToString:[[stringS smr_data] smr_stringByHex]], @"");
}

// 加密模式为CBC, key采用SHA384散列算法加密后,前32位为key,后32位为iv.
- (void)test_aesSha384 {
    NSString *stringO = @"this is an example";
    NSString *stringB = @"bmWMJtW2VHeN+KTds24s/9B+6DMprIJA0zLFxAhKXwA=";
    NSString *stringH = @"6e658c26d5b654778df8a4ddb36e2cffd07ee83329ac8240d332c5c4084a5f00";
    
    SMRCryptorResult *result1 = [SMRCryptor aesEncrypt:stringO key:@"abcdefgh"];
    CocoaSecurityResult *result2 = [CocoaSecurity aesEncrypt:stringO key:@"abcdefgh"];
    NSAssert([result1.data isEqualToData:result2.data], @"");
    NSAssert([result1.hex.lowercaseString isEqualToString:stringH], @"");
    NSAssert([result1.base64 isEqualToString:stringB], @"");
    NSAssert([result2.base64 isEqualToString:stringB], @"");
}

- (void)test_aesCbc {
    NSString *stringO = @"this is an example";
    NSString *stringB = @"PjkKKygtW0KunHs4XH3VM0TZP+8do0i5/XpfUpbij6A=";
    NSString *stringH = @"3e390a2b282d5b42ae9c7b385c7dd53344d93fef1da348b9fd7a5f5296e28fa0";
    NSString *key = @"abcdefghijklmnop";
    NSString *iv = @"abcdefghijklmnop";
    
    SMRCryptorResult *result1 = [SMRCryptor aesEncrypt:stringO key:key.smr_data iv:iv.smr_data];
    CocoaSecurityResult *result2 = [CocoaSecurity aesEncrypt:stringO key:key.smr_data iv:iv.smr_data];
    NSAssert([result1.data isEqualToData:result2.data], @"");
    NSAssert([result1.hex.lowercaseString isEqualToString:stringH], @"");
    NSAssert([result1.base64 isEqualToString:stringB], @"");
    NSAssert([result2.base64 isEqualToString:stringB], @"");
}

- (void)test_md5 {
    NSString *stringO = @"this is an example";
    NSString *stringB = @"kgKBbauq80uxBqEEIbmg0A==";
    NSString *stringH = @"9202816dabaaf34bb106a10421b9a0d0";
    
    SMRCryptorResult *result1 = [SMRCryptor md5:stringO];
    CocoaSecurityResult *result2 = [CocoaSecurity md5:stringO];
    NSAssert([result1.data isEqualToData:result2.data], @"");
    NSAssert([result1.hex.lowercaseString isEqualToString:stringH], @"");
    NSAssert([result1.base64 isEqualToString:stringB], @"");
    NSAssert([result2.base64 isEqualToString:stringB], @"");
    
}

@end
