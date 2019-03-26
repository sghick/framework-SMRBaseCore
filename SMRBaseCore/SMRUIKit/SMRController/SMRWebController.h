//
//  SMRWebController.h
//  SMRBaseCoreDemo
//
//  Created by 丁治文 on 2019/3/26.
//  Copyright © 2019 sumrise. All rights reserved.
//

#import "SMRNavFatherController.h"

NS_ASSUME_NONNULL_BEGIN

@interface SMRWebController : SMRNavFatherController

@property (copy, nonatomic) NSString *url;

+ (BOOL)pushWithURL:(NSString *)url title:(nullable NSString *)title;

@end

NS_ASSUME_NONNULL_END
