//
//  SMRUtils+MBProgressHUD.h
//  SMRBaseCoreDemo
//
//  Created by 丁治文 on 2019/3/5.
//  Copyright © 2019 sumrise. All rights reserved.
//

#import "SMRUtils.h"

NS_ASSUME_NONNULL_BEGIN

@interface SMRUtils (MBProgressHUD)

/** toast */
- (void)toast:(NSString *)toast;

/** 展示HUD */
- (void)showHUD;

/** 隐藏HUD */
- (void)hideHUD;

@end

NS_ASSUME_NONNULL_END
