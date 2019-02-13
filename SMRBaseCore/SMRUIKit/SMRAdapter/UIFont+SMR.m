//
//  UIFont+SMR.m
//  SMRBaseCoreDemo
//
//  Created by 丁治文 on 2019/1/21.
//  Copyright © 2019 sumrise. All rights reserved.
//

#import "UIFont+SMR.h"
#import "SMRUIAdapter.h"

@implementation UIFont (SMR)

+ (UIFont *)smr_systemFontOfSize:(CGFloat)fontSize {
    return [UIFont systemFontOfSize:fontSize * [smr_InterfaceAdapter interfaceScale]];
}

+ (UIFont *)smr_boldSystemFontOfSize:(CGFloat)fontSize {
    return [UIFont boldSystemFontOfSize:fontSize * [smr_InterfaceAdapter interfaceScale]];
}

+ (UIFont *)smr_fontWithName:(NSString *)fontName size:(CGFloat)fontSize {
    return [UIFont fontWithName:fontName size:fontSize * [smr_InterfaceAdapter interfaceScale]];
}

@end
