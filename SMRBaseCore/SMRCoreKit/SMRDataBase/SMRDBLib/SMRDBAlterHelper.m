//
//  SMRDBAlterHelper.m
//  SMRBaseCoreDemo
//
//  Created by Tinswin on 2020/6/29.
//  Copyright © 2020 sumrise. All rights reserved.
//

#import "SMRDBAlterHelper.h"

@implementation SMRDBMetaInfo

+ (instancetype)metaInfoWithTableName:(NSString *)tableName
                          classString:(NSString *)classString
                          primaryKeys:(nullable NSArray<NSString *> *)primaryKeys {
    SMRDBMetaInfo *metaInfo = [[SMRDBMetaInfo alloc] init];
    metaInfo.table_name = tableName;
    metaInfo.class_string = classString;
    metaInfo.primary_keys = primaryKeys;
    return metaInfo;
}

+ (instancetype)metaInfoWithDictionary:(NSDictionary *)dictionary {
    if (!dictionary.count) {
        return nil;
    }
    SMRDBMetaInfo *metaInfo = [[SMRDBMetaInfo alloc] init];
    metaInfo.table_name = dictionary[@"table_name"];
    metaInfo.class_string = dictionary[@"class_string"];
    metaInfo.primary_keys = dictionary[@"primary_keys"];
    return metaInfo;
}

- (NSDictionary *)dictionary {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"table_name"] = self.table_name;
    dict[@"primary_keys"] = self.primary_keys;
    dict[@"class_string"] = self.class_string;
    return dict;
}

@end

NSString * const kUDForDBMetaTablePrefix = @"kUDForDBMetaTablePrefix";

@interface SMRDBAlterHelper ()

@property (strong, nonatomic) NSUserDefaults *ud;
@property (strong, nonatomic) NSMutableDictionary *md;

@end

@implementation SMRDBAlterHelper

+ (instancetype)shared {
    static dispatch_once_t onceToken;
    static SMRDBAlterHelper *_shared = nil;
    dispatch_once(&onceToken, ^{
        _shared = [[SMRDBAlterHelper alloc] init];
    });
    return _shared;
}

#pragma mark - Alter

+ (SMRDBMetaInfo *)metaInfoNeedsAlterWithKey:(NSString *)key {
    if (!key.length) {
        return nil;
    }
    return [[SMRDBAlterHelper shared] metaInfoFromMemeryWithKey:key];
}

+ (void)setMetaInfoIfNeedsAlter:(SMRDBMetaInfo *)metaInfo
                         forKey:(NSString *)key {
    if (!metaInfo || !key.length) {
        return;
    }
    
    // 设置更新标识,仅内存中不存在时有效
    SMRDBAlterHelper *helper = [SMRDBAlterHelper shared];
    SMRDBMetaInfo *memery = [helper metaInfoFromMemeryWithKey:key];
    // 未设置或者未更新时,可标记更新和同步内存
    if (!memery || memery.needsAlter) {
        metaInfo.needsAlter = YES;
        [helper setMetaInfoInMemery:metaInfo forKey:key];
    }
}
+ (void)markMetaInfoAlteredWithKey:(NSString *)key {
    if (!key.length) {
        return;
    }
    SMRDBAlterHelper *helper = [SMRDBAlterHelper shared];
    SMRDBMetaInfo *memery = [helper metaInfoFromMemeryWithKey:key];
    if (memery.needsAlter) {
        memery.needsAlter = NO;
    }
}

#pragma mark - Memery And Disk

- (SMRDBMetaInfo *)metaInfoWithKey:(NSString *)key {
    SMRDBMetaInfo *metaInfo = [self metaInfoFromMemeryWithKey:key];
    if (!metaInfo) {
        metaInfo = [self metaInfoFromDiskWithKey:key];
        [self setMetaInfoInMemery:metaInfo forKey:key];
    }
    return metaInfo;
}
- (void)setMetaInfo:(SMRDBMetaInfo *)metaInfo forKey:(NSString *)key {
    [self setMetaInfoInMemery:metaInfo forKey:key];
    [self setMetaInfoInDisk:metaInfo forKey:key];
}
- (void)removeMetaInfoWithKey:(NSString *)key {
    [self removeMetaInfoFromMemeryWithKey:key];
    [self removeMetaInfoFromDiskWithKey:key];
}

#pragma mark - Memery

- (SMRDBMetaInfo *)metaInfoFromMemeryWithKey:(NSString *)key {
    if (!key.length) {
        return nil;
    }
    return self.md[key];
}
- (void)setMetaInfoInMemery:(SMRDBMetaInfo *)metaInfo forKey:(NSString *)key {
    if (!key.length) {
        return;
    }
    self.md[key] = metaInfo;
}
- (void)removeMetaInfoFromMemeryWithKey:(NSString *)key {
    if (!key.length) {
        return;
    }
    self.md[key] = nil;
}

#pragma mark - Disk

- (SMRDBMetaInfo *)metaInfoFromDiskWithKey:(NSString *)key {
    if (!key.length) {
        return nil;
    }
    id mt = [self.ud objectForKey:[self uniquekeyWithKey:key]];
    return [SMRDBMetaInfo metaInfoWithDictionary:mt];
}
- (void)setMetaInfoInDisk:(SMRDBMetaInfo *)metaInfo forKey:(NSString *)key {
    if (!key.length) {
        return;
    }
    NSDictionary *dict = [metaInfo dictionary];
    [self.ud setObject:dict forKey:[self uniquekeyWithKey:key]];
}
- (void)removeMetaInfoFromDiskWithKey:(NSString *)key {
    if (!key.length) {
        return;
    }
    [self.ud removeObjectForKey:[self uniquekeyWithKey:key]];
}

#pragma mark - Utils

- (NSString *)uniquekeyWithKey:(NSString *)key {
    if (!key.length) {
        return nil;
    }
    return [NSString stringWithFormat:@"%@%@", kUDForDBMetaTablePrefix, key];
}

#pragma mark - Getters

- (NSUserDefaults *)ud {
    if (!_ud) {
        _ud = [[NSUserDefaults alloc] initWithSuiteName:nil];
    }
    return _ud;
}

- (NSMutableDictionary *)md {
    if (!_md) {
        _md = [NSMutableDictionary dictionary];
    }
    return _md;
}

@end
