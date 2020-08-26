//
//  SMRModelAPIParamsDelegate.h
//  SMRModelDemo
//
//  Created by 丁治文 on 2018/12/18.
//  Copyright © 2018 sumrise. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SMRModelAPIParamsDelegate <NSObject>

@optional
/** 创建API参数,自动忽略值为nil的对象,如果有特殊情况,请重写本方法或者添加新方法,自行处理 */
- (NSDictionary *)createAPIParams;
/** 创建API参数,自动忽略值为nil的对象,如果有特殊情况,请重写本方法或者添加新方法,自行处理 */
+ (NSArray<NSDictionary *> *)createAPIParamsWithModels:(NSArray *)models;

@end
