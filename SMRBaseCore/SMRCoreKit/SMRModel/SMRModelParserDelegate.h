//
//  SMRModelParserDelegate.h
//  SMRModelDemo
//
//  Created by 丁治文 on 2018/12/18.
//  Copyright © 2018 sumrise. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SMRModelParserDelegate <NSObject>

@optional
+ (NSDictionary *)modelCustomPropertyMapper;///< 起别名 如:{p1:new_p1}
+ (NSDictionary *)modelContainerPropertyGenericClass;

@end
