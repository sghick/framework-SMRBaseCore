//
//  SMRTestPersonModels.h
//  SMRBaseCoreDemo
//
//  Created by 丁治文 on 2019/3/4.
//  Copyright © 2019 sumrise. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SMRTestPersonModels : NSObject

@end

@interface SMRPerson : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *sex;
@property (assign, nonatomic) NSInteger age;

@end
