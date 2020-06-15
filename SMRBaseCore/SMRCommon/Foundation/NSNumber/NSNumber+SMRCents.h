//
//  NSNumber+SMRCents.h
//  SMRBaseCoreDemo
//
//  Created by Tinswin on 2020/6/15.
//  Copyright © 2020 sumrise. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSNumber (SMRCents)

/** 以元为单位,有几位小数点就带小数,没有小数则为整数 */
- (NSString *)smr_yuan;

@end

NS_ASSUME_NONNULL_END
