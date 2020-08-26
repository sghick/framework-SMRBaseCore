//
//  SMRUDManager.h
//  SMRBaseCoreDemo
//
//  Created by Tinswin on 2019/1/2.
//  Copyright © 2019年 sumrise. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SMRUDManager : NSObject

/**
 存储对象到沙盒

 @param obj 要存储的对象
 @param pathName 沙盒中拼接的路径
 */
+ (void)smr_saveValueToUDWithObject:(id)obj PathName:(NSString *)pathName;

/**
 从沙盒中取出对象

 @param pathName 沙盒中拼接的路径
 @return 获取到的对象
 */
+ (id)smr_getValueFromUDWithPathName:(NSString *)pathName;

/**
 删除沙盒中文件

 @param pathName 沙盒中拼接的路径
 */
+ (void)smr_deleteValueFromUDWithPathName:(NSString *)pathName;

@end

NS_ASSUME_NONNULL_END
