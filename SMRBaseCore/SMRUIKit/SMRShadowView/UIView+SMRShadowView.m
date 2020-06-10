//
//  UIView+SMRShadowView.m
//  SMRBaseCoreDemo
//
//  Created by Tinswin on 2020/6/10.
//  Copyright © 2020 sumrise. All rights reserved.
//

#import "UIView+SMRShadowView.h"

@implementation SMRShadowItem

@end

@implementation UIView (SMRShadowView)

- (void)setShadowWithItem:(SMRShadowItem *)shadowItem {
    [self setShadowWithItem:shadowItem shadowPath:NULL];
}

- (void)setShadowWithItem:(SMRShadowItem *)shadowItem shadowPath:(CGPathRef)shadowPath {
    self.layer.shadowColor = shadowItem.shadowColor.CGColor;
    self.layer.shadowOpacity = shadowItem.shadowOpacity;
    self.layer.shadowOffset = shadowItem.shadowOffset;
    self.layer.cornerRadius = shadowItem.cornerRadius;
    self.layer.shadowRadius = shadowItem.shadowRadius;
    self.layer.shadowPath = shadowPath;
}

@end
