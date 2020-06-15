//
//  SMRBaseCoreInfoHelper.h
//  SMRBaseCoreDemo
//
//  Created by 丁治文 on 2019/9/19.
//  Copyright © 2019 sumrise. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 || +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ ||
 || +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ ||
 info.plist 配置表
 配置表的key:Base Core Config,以下所有值请在这个配置下写,如:
 Base Core Config:{
                    Base Core Log:YES,
                    Adapter Margin:20*scale,
                    TableViewSeperator Left Margin:20*scale,
                    TableViewSeperator Right Margin:20*scale
                    }
 
 | key | value |
 | ------ | ------ |
 | Base Core Log | YES |
 | Adapter Margin | 20*scale |
 | TableViewSeperator Left Margin | 20*scale |
 | TableViewSeperator Right Margin | 20*scale |
 
 || +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ ||
 || +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ ||
 **/

NS_ASSUME_NONNULL_BEGIN

@interface SMRBaseCoreInfoHelper : NSObject

/** 读取BaseCoreConfig内容 */
+ (nullable id)configWithKey:(NSString *)key;

/** 获取log开头 */
+ (BOOL)baseCoreLog;

/** 获取margin值 */
+ (CGFloat)marginWithScale:(CGFloat)scale;

/** 设置TableViewSeperator的margin */
+ (CGFloat)tableViewSeperatorLeftMarginWithScale:(CGFloat)scale;
+ (CGFloat)tableViewSeperatorRightMarginWithScale:(CGFloat)scale;

@end

NS_ASSUME_NONNULL_END
