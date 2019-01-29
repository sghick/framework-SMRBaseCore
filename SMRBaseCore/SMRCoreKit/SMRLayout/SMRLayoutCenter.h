//
//  SMRLayoutCenter.h
//  SMRBaseCoreDemo
//
//  Created by 丁治文 on 2019/1/29.
//  Copyright © 2019 sumrise. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SMRLayoutCenter : NSObject

+ (void)addSubviews:(NSDictionary *)dict atView:(UIView *)atView;
+ (void)addSubview:(NSDictionary *)dict name:(NSString *)name clsName:(NSString *)clsName atView:(UIView *)atView;

@end

NS_ASSUME_NONNULL_END
