//
//  SMRModelParserDelegate.h
//  SMRModelDemo
//
//  Created by 丁治文 on 2018/7/21.
//  Copyright © 2018年 sumrise.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SMRModelParserDelegate <NSObject>

@optional
+ (NSDictionary *)modelCustomPropertyMapper;///< 起别名 如:{p1:new_p1}
+ (NSDictionary *)modelContainerPropertyGenericClass;

@end
