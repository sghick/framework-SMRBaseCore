//
//  SMRUtils.m
//  SMRBaseCoreDemo
//
//  Created by 丁治文 on 2019/2/14.
//  Copyright © 2019 sumrise. All rights reserved.
//

#import "SMRUtils.h"

@implementation SMRUtils

+ (void)endEditing:(BOOL)edit {
    [[UIApplication sharedApplication].delegate.window endEditing:edit];
}

@end
