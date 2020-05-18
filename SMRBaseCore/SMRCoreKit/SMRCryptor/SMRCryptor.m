//
//  SMRCryptor.m
//  SMRBaseCoreDemo
//
//  Created by Tinswin on 2020/4/21.
//  Copyright © 2020 sumrise. All rights reserved.
//

#import "SMRCryptor.h"
#import <CommonCrypto/CommonHMAC.h>
#import <CommonCrypto/CommonCryptor.h>

@implementation SMRCryptorResult

- (id)initWithBytes:(unsigned char [])initData length:(NSUInteger)length {
    return [self initWithData:[NSData dataWithBytes:initData length:length]];
}

- (id)initWithData:(NSData *)data {
    self = [super init];
    if (self) {
        _data = data;
    }
    return self;
}

- (NSString *)utf8String {
    return [self.data smr_string];
}

- (NSString *)hex {
    return [self.data smr_stringByHex];
}

- (NSString *)base64 {
    return [self.data smr_stringByBase64];
}

@end

@implementation SMRCryptor

#pragma mark - AES Encrypt

// default AES Encrypt, key -> SHA384(key).sub(0, 32), iv -> SHA384(key).sub(32, 16)
+ (SMRCryptorResult *)aesEncrypt:(NSString *)string key:(NSString *)key {
    SMRCryptorResult *sha = [self sha384:key];
    NSData *aesKey = [sha.data subdataWithRange:NSMakeRange(0, 32)];
    NSData *aesIv = [sha.data subdataWithRange:NSMakeRange(32, 16)];
    
    return [self aesEncrypt:string key:aesKey iv:aesIv];
}

#pragma mark AES Encrypt 128, 192, 256

+ (SMRCryptorResult *)aesEncrypt:(NSString *)string hexKey:(NSString *)key hexIv:(NSString *)iv {
    NSData *aesKey = [key smr_dataByHex];
    NSData *aesIv = [iv smr_dataByHex];
    return [self aesEncrypt:string key:aesKey iv:aesIv];
}
+ (SMRCryptorResult *)aesEncrypt:(NSString *)string key:(NSData *)key iv:(NSData *)iv {
    return [self aesEncryptWithData:[string dataUsingEncoding:NSUTF8StringEncoding] key:key iv:iv];
}
+ (SMRCryptorResult *)aesEncryptWithData:(NSData *)data key:(NSData *)key iv:(NSData *)iv {
    // check length of key and iv
    if (iv.length != 16) {
        NSAssert(nil, @"Length of iv should be 16(128bits)");
        return nil;
    }
    if ((key.length != 16) && (key.length != 24) && (key.length != 32 )) {
        NSAssert(nil, @"Length of key should be 16, 24 or 32(128, 192 or 256bits)");
        return nil;
    }
    
    // setup output buffer
    size_t bufferSize = [data length] + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    
    // do encrypt
    size_t encryptedSize = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt,
                                          kCCAlgorithmAES128,
                                          kCCOptionPKCS7Padding,
                                          [key bytes],     // Key
                                          [key length],    // kCCKeySizeAES
                                          [iv bytes],       // IV
                                          [data bytes],
                                          [data length],
                                          buffer,
                                          bufferSize,
                                          &encryptedSize);
    if (cryptStatus == kCCSuccess) {
        SMRCryptorResult *result = [[SMRCryptorResult alloc] initWithBytes:buffer length:encryptedSize];
        free(buffer);
        return result;
    } else {
        free(buffer);
        NSAssert(nil, @"Encrypt Error!");
        return nil;
    }
}

#pragma mark - AES Decrypt

// default AES Decrypt, key -> SHA384(key).sub(0, 32), iv -> SHA384(key).sub(32, 16)
+ (SMRCryptorResult *)aesDecryptWithBase64:(NSString *)string key:(NSString *)key {
    SMRCryptorResult *sha = [self sha384:key];
    NSData *aesKey = [sha.data subdataWithRange:NSMakeRange(0, 32)];
    NSData *aesIv = [sha.data subdataWithRange:NSMakeRange(32, 16)];
    return [self aesDecryptWithBase64:string key:aesKey iv:aesIv];
}

#pragma mark AES Decrypt 128, 192, 256

+ (SMRCryptorResult *)aesDecryptWithBase64:(NSString *)string hexKey:(NSString *)key hexIv:(NSString *)iv {
    NSData *aesKey = [key smr_dataByHex];
    NSData *aesIv = [iv smr_dataByHex];
    return [self aesDecryptWithBase64:string key:aesKey iv:aesIv];
}
+ (SMRCryptorResult *)aesDecryptWithBase64:(NSString *)string key:(NSData *)key iv:(NSData *)iv {
    NSData *base64Data = [string smr_dataByBase64];
    return [self aesDecryptWithData:base64Data key:key iv:iv];
}
+ (SMRCryptorResult *)aesDecryptWithData:(NSData *)data key:(NSData *)key iv:(NSData *)iv {
    // check length of key and iv
    if (iv.length != 16) {
        NSAssert(nil, @"Length of iv should be 16(128bits)");
        return nil;
    }
    if ((key.length != 16) && (key.length != 24) && (key.length != 32 )) {
        NSAssert(nil, @"Length of key should be 16, 24 or 32(128, 192 or 256bits)");
        return nil;
    }
    
    // setup output buffer
    size_t bufferSize = [data length] + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    
    // do encrypt
    size_t encryptedSize = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt,
                                          kCCAlgorithmAES128,
                                          kCCOptionPKCS7Padding,
                                          [key bytes],     // Key
                                          [key length],    // kCCKeySizeAES
                                          [iv bytes],       // IV
                                          [data bytes],
                                          [data length],
                                          buffer,
                                          bufferSize,
                                          &encryptedSize);
    if (cryptStatus == kCCSuccess) {
        SMRCryptorResult *result = [[SMRCryptorResult alloc] initWithBytes:buffer length:encryptedSize];
        free(buffer);
        return result;
    } else {
        free(buffer);
        NSAssert(nil, @"Decrypt Error!");
        return nil;
    }
}

#pragma mark - MD5

+ (SMRCryptorResult *)md5:(NSString *)hashString {
    return [self md5WithData:[hashString dataUsingEncoding:NSUTF8StringEncoding]];
}
+ (SMRCryptorResult *)md5WithData:(NSData *)hashData {
    unsigned char *digest;
    digest = malloc(CC_MD5_DIGEST_LENGTH);
    
    CC_MD5([hashData bytes], (CC_LONG)[hashData length], digest);
    SMRCryptorResult *result = [[SMRCryptorResult alloc] initWithBytes:digest length:CC_MD5_DIGEST_LENGTH];
    free(digest);
    
    return result;
}

#pragma mark - HMAC-MD5

+ (SMRCryptorResult *)hmacMd5:(NSString *)hashString hmacKey:(NSString *)key {
    return [self hmacMd5WithData:[hashString dataUsingEncoding:NSUTF8StringEncoding] hmacKey:key];
}
+ (SMRCryptorResult *)hmacMd5WithData:(NSData *)hashData hmacKey:(NSString *)key {
    unsigned char *digest;
    digest = malloc(CC_MD5_DIGEST_LENGTH);
    const char *cKey = [key cStringUsingEncoding:NSUTF8StringEncoding];
    
    CCHmac(kCCHmacAlgMD5, cKey, strlen(cKey), [hashData bytes], [hashData length], digest);
    SMRCryptorResult *result = [[SMRCryptorResult alloc] initWithBytes:digest length:CC_MD5_DIGEST_LENGTH];
    free(digest);
    cKey = nil;
    
    return result;
}

#pragma mark - SHA1

+ (SMRCryptorResult *)sha1:(NSString *)hashString {
    return [self sha1WithData:[hashString dataUsingEncoding:NSUTF8StringEncoding]];
}
+ (SMRCryptorResult *)sha1WithData:(NSData *)hashData {
    unsigned char *digest;
    digest = malloc(CC_SHA1_DIGEST_LENGTH);
    
    CC_SHA1([hashData bytes], (CC_LONG)[hashData length], digest);
    SMRCryptorResult *result = [[SMRCryptorResult alloc] initWithBytes:digest length:CC_SHA1_DIGEST_LENGTH];
    free(digest);
    
    return result;
}

#pragma mark SHA224

+ (SMRCryptorResult *)sha224:(NSString *)hashString {
    return [self sha224WithData:[hashString dataUsingEncoding:NSUTF8StringEncoding]];
}
+ (SMRCryptorResult *)sha224WithData:(NSData *)hashData {
    unsigned char *digest;
    digest = malloc(CC_SHA224_DIGEST_LENGTH);
    
    CC_SHA224([hashData bytes], (CC_LONG)[hashData length], digest);
    SMRCryptorResult *result = [[SMRCryptorResult alloc] initWithBytes:digest length:CC_SHA224_DIGEST_LENGTH];
    free(digest);
    
    return result;
}

#pragma mark SHA256

+ (SMRCryptorResult *)sha256:(NSString *)hashString {
    return [self sha256WithData:[hashString dataUsingEncoding:NSUTF8StringEncoding]];
}
+ (SMRCryptorResult *)sha256WithData:(NSData *)hashData {
    unsigned char *digest;
    digest = malloc(CC_SHA256_DIGEST_LENGTH);
    
    CC_SHA256([hashData bytes], (CC_LONG)[hashData length], digest);
    SMRCryptorResult *result = [[SMRCryptorResult alloc] initWithBytes:digest length:CC_SHA256_DIGEST_LENGTH];
    free(digest);
    
    return result;
}

#pragma mark SHA384

+ (SMRCryptorResult *)sha384:(NSString *)hashString {
    return [self sha384WithData:[hashString dataUsingEncoding:NSUTF8StringEncoding]];
}
+ (SMRCryptorResult *)sha384WithData:(NSData *)hashData {
    unsigned char *digest;
    digest = malloc(CC_SHA384_DIGEST_LENGTH);
    
    CC_SHA384([hashData bytes], (CC_LONG)[hashData length], digest);
    SMRCryptorResult *result = [[SMRCryptorResult alloc] initWithBytes:digest length:CC_SHA384_DIGEST_LENGTH];
    free(digest);
    
    return result;
}

#pragma mark SHA512

+ (SMRCryptorResult *)sha512:(NSString *)hashString {
    return [self sha512WithData:[hashString dataUsingEncoding:NSUTF8StringEncoding]];
}
+ (SMRCryptorResult *)sha512WithData:(NSData *)hashData {
    unsigned char *digest;
    digest = malloc(CC_SHA512_DIGEST_LENGTH);
    
    CC_SHA512([hashData bytes], (CC_LONG)[hashData length], digest);
    SMRCryptorResult *result = [[SMRCryptorResult alloc] initWithBytes:digest length:CC_SHA512_DIGEST_LENGTH];
    free(digest);
    
    return result;
}

#pragma mark - HMAC-SHA1

+ (SMRCryptorResult *)hmacSha1:(NSString *)hashString hmacKey:(NSString *)key {
    return [self hmacSha1WithData:[hashString dataUsingEncoding:NSUTF8StringEncoding] hmacKey:key];
}
+ (SMRCryptorResult *)hmacSha1WithData:(NSData *)hashData hmacKey:(NSString *)key {
    unsigned char *digest;
    digest = malloc(CC_SHA1_DIGEST_LENGTH);
    const char *cKey = [key cStringUsingEncoding:NSUTF8StringEncoding];
    
    CCHmac(kCCHmacAlgSHA1, cKey, strlen(cKey), [hashData bytes], [hashData length], digest);
    SMRCryptorResult *result = [[SMRCryptorResult alloc] initWithBytes:digest length:CC_SHA1_DIGEST_LENGTH];
    free(digest);
    cKey = nil;
    
    return result;
}

#pragma mark HMAC-SHA224

+ (SMRCryptorResult *)hmacSha224:(NSString *)hashString hmacKey:(NSString *)key {
   return [self hmacSha224WithData:[hashString dataUsingEncoding:NSUTF8StringEncoding] hmacKey:key];
}
+ (SMRCryptorResult *)hmacSha224WithData:(NSData *)hashData hmacKey:(NSString *)key {
    unsigned char *digest;
    digest = malloc(CC_SHA224_DIGEST_LENGTH);
    const char *cKey = [key cStringUsingEncoding:NSUTF8StringEncoding];
    
    CCHmac(kCCHmacAlgSHA224, cKey, strlen(cKey), [hashData bytes], [hashData length], digest);
    SMRCryptorResult *result = [[SMRCryptorResult alloc] initWithBytes:digest length:CC_SHA224_DIGEST_LENGTH];
    free(digest);
    cKey = nil;
    
    return result;
}

#pragma mark HMAC-SHA256

+ (SMRCryptorResult *)hmacSha256:(NSString *)hashString hmacKey:(NSString *)key {
    return [self hmacSha256WithData:[hashString dataUsingEncoding:NSUTF8StringEncoding] hmacKey:key];
}
+ (SMRCryptorResult *)hmacSha256WithData:(NSData *)hashData hmacKey:(NSString *)key {
    unsigned char *digest;
    digest = malloc(CC_SHA256_DIGEST_LENGTH);
    const char *cKey = [key cStringUsingEncoding:NSUTF8StringEncoding];
    
    CCHmac(kCCHmacAlgSHA256, cKey, strlen(cKey), [hashData bytes], [hashData length], digest);
    SMRCryptorResult *result = [[SMRCryptorResult alloc] initWithBytes:digest length:CC_SHA256_DIGEST_LENGTH];
    free(digest);
    cKey = nil;
    
    return result;
}

#pragma mark HMAC-SHA384

+ (SMRCryptorResult *)hmacSha384:(NSString *)hashString hmacKey:(NSString *)key {
    return [self hmacSha384WithData:[hashString dataUsingEncoding:NSUTF8StringEncoding] hmacKey:key];
}
+ (SMRCryptorResult *)hmacSha384WithData:(NSData *)hashData hmacKey:(NSString *)key {
    unsigned char *digest;
    digest = malloc(CC_SHA384_DIGEST_LENGTH);
    const char *cKey = [key cStringUsingEncoding:NSUTF8StringEncoding];
    
    CCHmac(kCCHmacAlgSHA384, cKey, strlen(cKey), [hashData bytes], [hashData length], digest);
    SMRCryptorResult *result = [[SMRCryptorResult alloc] initWithBytes:digest length:CC_SHA384_DIGEST_LENGTH];
    free(digest);
    cKey = nil;
    
    return result;
}

#pragma mark HMAC-SHA512

+ (SMRCryptorResult *)hmacSha512:(NSString *)hashString hmacKey:(NSString *)key {
    return [self hmacSha512WithData:[hashString dataUsingEncoding:NSUTF8StringEncoding] hmacKey:key];
}
+ (SMRCryptorResult *)hmacSha512WithData:(NSData *)hashData hmacKey:(NSString *)key {
    unsigned char *digest;
    digest = malloc(CC_SHA512_DIGEST_LENGTH);
    const char *cKey = [key cStringUsingEncoding:NSUTF8StringEncoding];
    
    CCHmac(kCCHmacAlgSHA512, cKey, strlen(cKey), [hashData bytes], [hashData length], digest);
    SMRCryptorResult *result = [[SMRCryptorResult alloc] initWithBytes:digest length:CC_SHA512_DIGEST_LENGTH];
    free(digest);
    cKey = nil;
    
    return result;
}

@end

@implementation NSData (SMRCryptor)

/** UTF8 */
- (NSString *)smr_string {
    if (!self.length) {
        return nil;
    }
    NSString *string = [[NSString alloc] initWithData:self encoding:NSUTF8StringEncoding];
    return string;
}

/** Base64 */
- (NSString *)smr_stringByBase64 {
    return [self smr_stringByBase64WithLineLength:0];
}

- (NSString *)smr_stringByBase64WithLineLength:(NSUInteger)lineLength {
    if (!self.length) {
        return nil;
    }
    NSString *string = nil;
    switch (lineLength) {
        case 64: {
            return [self base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
        }
        case 76: {
            return [self base64EncodedStringWithOptions:NSDataBase64Encoding76CharacterLineLength];
        }
        default: {
            string = [self base64EncodedStringWithOptions:(NSDataBase64EncodingOptions)0];
        }
    }
    
    if (!lineLength || lineLength >= string.length) {
        return string;
    }
    
    lineLength = (lineLength/4)*4;
    NSMutableString *result = [NSMutableString string];
    for (NSUInteger i = 0; i < string.length; i += lineLength) {
        if (i + lineLength >= string.length) {
            [result appendString:[string substringFromIndex:i]];
            break;
        }
        [result appendString:[string substringWithRange:NSMakeRange(i, lineLength)]];
        [result appendString:@"\r\n"];
    }
    return result;
}

/** Hex */
- (NSString *)smr_stringByHex {
    return [self smr_stringByHexWithLength:self.length];
}
- (NSString *)smr_stringByHexWithLength:(NSInteger)length {
    if (!self.length) {
        return nil;
    }

    unsigned char *bytes = ((unsigned char *)self.bytes);
    NSMutableString *result = [NSMutableString string];
    NSInteger minLength = MIN(length, self.length);
    for (int i = 0; i < minLength; i++) {
        [result appendFormat:@"%02x", bytes[i]];
    }
    return [result copy];
}

@end

@implementation NSString (SMRCryptor)

/** UTF8 */
- (NSData *)smr_data {
    if (!self.length) {
        return nil;
    }
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    return data;
}

/** Base64 */
- (NSData *)smr_dataByBase64 {
    if (!self.length) {
        return nil;
    }
    NSData *data =
    [[NSData alloc] initWithBase64EncodedString:self
                                        options:NSDataBase64DecodingIgnoreUnknownCharacters];
    return data.length ? data : nil;
}

/** Hex */
- (NSData *)smr_dataByHex {
    if (!self.length) {
        return nil;
    }
    
    static const unsigned char HexDecodeChars[] = {
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 1,       //49
        2, 3, 4, 5, 6, 7, 8, 9, 0, 0,       //59
        0, 0, 0, 0, 0, 10, 11, 12, 13, 14,
        15, 0, 0, 0, 0, 0, 0, 0, 0, 0,      //79
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 10, 11, 12,    //99
        13, 14, 15
    };
    
    // convert data(NSString) to CString
    const char *source = [self cStringUsingEncoding:NSUTF8StringEncoding];
    // malloc buffer
    unsigned char *buffer;
    NSUInteger length = strlen(source) / 2;
    buffer = malloc(length);
    for (NSUInteger index = 0; index < length; index++) {
        buffer[index] = (HexDecodeChars[source[index * 2]] << 4) + (HexDecodeChars[source[index * 2 + 1]]);
    }
    // init result NSData
    NSData *result = [NSData dataWithBytes:buffer length:length];
    free(buffer);
    source = nil;
    return  result;
}

@end
