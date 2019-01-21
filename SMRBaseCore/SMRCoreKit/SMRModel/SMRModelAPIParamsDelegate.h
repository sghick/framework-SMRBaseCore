//
//  SMRModelAPIParamsDelegate.h
//  SMRModelDemo
//
//  Created by 丁治文 on 2018/7/21.
//  Copyright © 2018年 sumrise.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SMRModelAPIParamsDelegate <NSObject>

@optional
- (NSDictionary *)createAPIParams;
+ (NSArray<NSDictionary *> *)createAPIParamsWithModels:(NSArray *)models;

@end
