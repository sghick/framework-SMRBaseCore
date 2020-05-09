//
//  SMRCryptor.h
//  SMRBaseCoreDemo
//
//  Created by Tinswin on 2020/4/21.
//  Copyright © 2020 sumrise. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SMRCryptorResult : NSObject

@property (strong, nonatomic, readonly) NSData *data;
@property (strong, nonatomic, readonly) NSString *utf8String;
@property (strong, nonatomic, readonly) NSString *hex;
@property (strong, nonatomic, readonly) NSString *base64;

- (id)initWithBytes:(unsigned char[_Nullable])initData length:(NSUInteger)length;
- (id)initWithData:(NSData *)data;

@end

/**
 在线工具:http://tool.chacuo.net/cryptaes
 AES加密:https://www.jianshu.com/p/a6fca79eb89c
        https://www.cnblogs.com/Dennis-mi/articles/6639644.html
 因为目前AES使用CBC加密模式更为安全,因些以下仅提供些模式的方法
*/

@interface SMRCryptor : NSObject

#pragma mark - AES Encrypt

+ (SMRCryptorResult *)aesEncrypt:(NSString *)string key:(NSString *)key;
+ (SMRCryptorResult *)aesEncrypt:(NSString *)string hexKey:(NSString *)key hexIv:(NSString *)iv;
+ (SMRCryptorResult *)aesEncrypt:(NSString *)string key:(NSData *)key iv:(NSData *)iv;
+ (SMRCryptorResult *)aesEncryptWithData:(NSData *)data key:(NSData *)key iv:(NSData *)iv;

#pragma mark - AES Decrypt

+ (SMRCryptorResult *)aesDecryptWithBase64:(NSString *)string key:(NSString *)key;
+ (SMRCryptorResult *)aesDecryptWithBase64:(NSString *)string hexKey:(NSString *)key hexIv:(NSString *)iv;
+ (SMRCryptorResult *)aesDecryptWithBase64:(NSString *)string key:(NSData *)key iv:(NSData *)iv;
+ (SMRCryptorResult *)aesDecryptWithData:(NSData *)data key:(NSData *)key iv:(NSData *)iv;

#pragma mark - MD5

+ (SMRCryptorResult *)md5:(NSString *)hashString;
+ (SMRCryptorResult *)md5WithData:(NSData *)hashData;

#pragma mark HMAC-MD5

+ (SMRCryptorResult *)hmacMd5:(NSString *)hashString hmacKey:(NSString *)key;
+ (SMRCryptorResult *)hmacMd5WithData:(NSData *)hashData hmacKey:(NSString *)key;

#pragma mark - SHA

+ (SMRCryptorResult *)sha1:(NSString *)hashString;
+ (SMRCryptorResult *)sha1WithData:(NSData *)hashData;
+ (SMRCryptorResult *)sha224:(NSString *)hashString;
+ (SMRCryptorResult *)sha224WithData:(NSData *)hashData;
+ (SMRCryptorResult *)sha256:(NSString *)hashString;
+ (SMRCryptorResult *)sha256WithData:(NSData *)hashData;
+ (SMRCryptorResult *)sha384:(NSString *)hashString;
+ (SMRCryptorResult *)sha384WithData:(NSData *)hashData;
+ (SMRCryptorResult *)sha512:(NSString *)hashString;
+ (SMRCryptorResult *)sha512WithData:(NSData *)hashData;

#pragma mark HMAC-SHA

+ (SMRCryptorResult *)hmacSha1:(NSString *)hashString hmacKey:(NSString *)key;
+ (SMRCryptorResult *)hmacSha1WithData:(NSData *)hashData hmacKey:(NSString *)key;
+ (SMRCryptorResult *)hmacSha224:(NSString *)hashString hmacKey:(NSString *)key;
+ (SMRCryptorResult *)hmacSha224WithData:(NSData *)hashData hmacKey:(NSString *)key;
+ (SMRCryptorResult *)hmacSha256:(NSString *)hashString hmacKey:(NSString *)key;
+ (SMRCryptorResult *)hmacSha256WithData:(NSData *)hashData hmacKey:(NSString *)key;
+ (SMRCryptorResult *)hmacSha384:(NSString *)hashString hmacKey:(NSString *)key;
+ (SMRCryptorResult *)hmacSha384WithData:(NSData *)hashData hmacKey:(NSString *)key;
+ (SMRCryptorResult *)hmacSha512:(NSString *)hashString hmacKey:(NSString *)key;
+ (SMRCryptorResult *)hmacSha512WithData:(NSData *)hashData hmacKey:(NSString *)key;

@end

@interface NSData (SMRCryptor)

/** UTF8 */
- (NSString *)smr_string;

/** Base64 */
- (NSString *)smr_base64EncodedString;
- (NSString *)smr_base64EncodedStringWithLineLength:(NSUInteger)lineLength;

/** Hex,字母小写 */
- (NSString *)smr_hexString;
- (NSString *)smr_hexStringWithLength:(NSInteger)length;

@end

@interface NSString (SMRCryptor)

/** UTF8 */
- (NSData *)smr_data;

/** Base64 */
- (NSData *)smr_dataFromBase64EncodedString;

/** Hex */
- (NSData *)smr_dataFromHexString;

@end


NS_ASSUME_NONNULL_END
