//
//  UIFont+SMRAdapter.m
//  SMRBaseCoreDemo
//
//  Created by Tinswin on 2018/12/21.
//  Copyright © 2018年 sumrise. All rights reserved.
//

#import "UIFont+SMRAdapter.h"
#import "SMRUIAdapter.h"

@implementation UIFont (SMRAdapter)

+ (UIFont *)smr_systemFontOfSize:(CGFloat)fontSize {
    return [UIFont systemFontOfSize:fontSize*[SMRUIAdapter scale]];
}

+ (UIFont *)smr_boldSystemFontOfSize:(CGFloat)fontSize {
    return [UIFont boldSystemFontOfSize:fontSize*[SMRUIAdapter scale]];
}

+ (UIFont *)smr_fontWithName:(NSString *)fontName size:(CGFloat)fontSize {
    return [UIFont fontWithName:fontName size:fontSize*[SMRUIAdapter scale]];
}
@end
