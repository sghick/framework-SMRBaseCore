//
//  SMRDBAlterHelper.h
//  SMRBaseCoreDemo
//
//  Created by Tinswin on 2020/6/29.
//  Copyright © 2020 sumrise. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SMRDBMetaInfo : NSObject

@property (strong, nonatomic) NSString *table_name;
@property (strong, nonatomic) NSString *class_string;
@property (strong, nonatomic) NSArray<NSString *> *primary_keys;

/** 根据这个值来判断是否需要检查更新表 */
@property (assign, nonatomic) BOOL needsAlter;

+ (instancetype)metaInfoWithTableName:(NSString *)tableName
                          classString:(NSString *)classString
                          primaryKeys:(nullable NSArray<NSString *> *)primaryKeys;
+ (instancetype)metaInfoWithDictionary:(NSDictionary *)dictionary;
- (NSDictionary *)dictionary;

@end

@interface SMRDBAlterHelper : NSObject

#pragma mark - Alter

+ (nullable SMRDBMetaInfo *)metaInfoNeedsAlterWithKey:(NSString *)key;
+ (void)setMetaInfoIfNeedsAlter:(SMRDBMetaInfo *)metaInfo
                         forKey:(NSString *)key;
+ (void)markMetaInfoAlteredWithKey:(NSString *)key;

#pragma mark - Memery And Disk

- (SMRDBMetaInfo *)metaInfoWithKey:(NSString *)key;
- (void)setMetaInfo:(SMRDBMetaInfo *)metaInfo forKey:(NSString *)key;
- (void)removeMetaInfoWithKey:(NSString *)key;

#pragma mark - Memery

- (SMRDBMetaInfo *)metaInfoFromMemeryWithKey:(NSString *)key;
- (void)setMetaInfoInMemery:(SMRDBMetaInfo *)metaInfo forKey:(NSString *)key;
- (void)removeMetaInfoFromMemeryWithKey:(NSString *)key;

#pragma mark - Disk

- (SMRDBMetaInfo *)metaInfoFromDiskWithKey:(NSString *)key;
- (void)setMetaInfoInDisk:(SMRDBMetaInfo *)metaInfo forKey:(NSString *)key;
- (void)removeMetaInfoFromDiskWithKey:(NSString *)key;

#pragma mark - Utils

- (NSString *)uniquekeyWithKey:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
