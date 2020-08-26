//
//  SMRTestDBModels.h
//  SMRBaseCoreDemo
//
//  Created by Tinswin on 2020/6/22.
//  Copyright © 2020 sumrise. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SMRTestDBModels : NSObject

@end

@interface SMRTestDBPerson : NSObject

@property (strong, nonatomic) NSString *identifier;
@property (strong, nonatomic) NSString *name;
@property (assign, nonatomic) int32_t sex;
@property (assign, nonatomic) BOOL age;
//@property (assign, nonatomic) double height;
//@property (assign, nonatomic) double weight;

+ (instancetype)createXiaoMing;
+ (instancetype)createXiaoGang;
+ (instancetype)createXiaoHua;

@end

@interface SMRTestDBPerson1 : NSObject

@property (strong, nonatomic) NSString *identifier;
@property (strong, nonatomic) NSString *name;
@property (assign, nonatomic) int32_t sex;
@property (assign, nonatomic) BOOL age;
@property (assign, nonatomic) double height;
//@property (assign, nonatomic) double weight;

@end

NS_ASSUME_NONNULL_END
