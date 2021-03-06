//
//  SMRUIKitBundle.h
//  SMRBaseCoreDemo
//
//  Created by 丁治文 on 2019/1/15.
//  Copyright © 2019 sumrise. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SMRUIKitBundle : NSBundle

+ (instancetype)sourceBundle;

+ (UIImage *)imageNamed:(NSString *)name;

@end

NS_ASSUME_NONNULL_END
