//
//  SMRSideMenuItem.h
//  SMRBaseCoreDemo
//
//  Created by Tinswin on 2020/4/27.
//  Copyright © 2020 sumrise. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SMRSideMenuItemParams : NSObject

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *url;
@property (strong, nonatomic) NSString *icon;
@property (strong, nonatomic) NSString *badge;

@end

@interface SMRSideMenuItem : UIView

@property (strong, nonatomic) UIFont *titleFont;
@property (strong, nonatomic) UIColor *titleColor;

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *icon;
@property (strong, nonatomic) NSString *badge;

+ (NSArray<UIView *> *)menuItemsWithParams:(NSArray<SMRSideMenuItemParams *> *)params;

@end

NS_ASSUME_NONNULL_END
