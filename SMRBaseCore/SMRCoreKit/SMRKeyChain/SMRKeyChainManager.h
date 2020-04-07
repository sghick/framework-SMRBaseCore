//
//  SMRKeyChainManager.h
//  SMRBaseCoreDemo
//
//  Created by 丁治文 on 2019/1/21.
//  Copyright © 2019 sumrise. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SMRKeyChainManager : NSObject

/**
 获取KeyChain中的 唯一的UUID
 */
+ (NSString *)UUIDString;

#pragma mark - KeyChainGeneral

/**
 *  储存字符串到钥匙串
 *
 *  @param value 对应的Value
 *  @param key   对应的Key
 */
+ (void)saveKeyChainValue:(NSString *)value key:(NSString *)key;

/**
 *  从钥匙串获取字符串
 *
 *  @param key 对应的Key
 *
 *  @return 返回储存的Value
 */
+ (NSString *)readKeyChainValueFromKey:(NSString *)key;

/**
 *  从钥匙串删除字符串
 *
 *  @param key 对应的Key
 */
+ (void)deleteKeyChainValueFromKey:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
