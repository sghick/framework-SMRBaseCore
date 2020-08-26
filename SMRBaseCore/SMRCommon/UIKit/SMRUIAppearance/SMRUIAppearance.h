//
//  SMRUIAppearance.h
//  SMRBaseCoreDemo
//
//  Created by Tinswin on 2020/7/23.
//  Copyright © 2020 sumrise. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol SMRUIAppearance <NSObject>

/**
 默认返回ClassName,设置仅对当前类有效,子类若要继承设置,需要返回同样的key
 */
+ (NSString *)smr_keyForAppearance;

/**
 获取配置的实例
 不可重写此方法
*/
+ (instancetype)smr_appearance;
- (instancetype)smr_appearance;

/**
 可重写此方法来做配置的初始化
 */
+ (void)smr_beforeAppearance:(id)obj;

@end

@interface NSObject (SMRUIAppearance)<SMRUIAppearance>

@end

NS_ASSUME_NONNULL_END
