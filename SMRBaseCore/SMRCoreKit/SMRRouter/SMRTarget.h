//
//  SMRTarget.h
//  SMRRouterDemo
//
//  Created by 丁治文 on 2018/10/4.
//  Copyright © 2018年 sumrise.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SMRTarget : NSObject

@end


#pragma mark - SMROpen

extern NSString * const k_perform_open;         ///< "执行打开页面\视图"参数的key,value为SMRTargetOpenType类型
typedef NS_ENUM(NSInteger, SMRTargetOpenType) {
    SMRTargetOpenTypeNone       = 0, ///< 默认为只获取一个对象
    SMRTargetOpenTypeOpen       = 1, ///< 获取一个对象,并且执行打开页面的block
    SMRTargetOpenTypeOpenPath   = 2, ///< 获取一个对象,并且执行打开带路径页面的block
};
@interface SMRTarget (SMROpen)

/**
 支持打开一个可能包含在对应Tab控制器,如果对应Tab中不包含与目标控制器类相同的控制器,则按正常方式进行跳转
 
 @param params              设置:k_perform_open=<SMRTargetOpenType>,将会执行对应的方法方法
 @param toChangeTab         对应要切换的Tab
 @param controller          对应要执行的控制器
 @param openActionBlock     如果k_perform_open=SMRTargetOpenTypeOpen,且对应Tab不存在,将执行此block,并且无默认处理(block==nil时将会默认进行处理)
 @param openPathActionBlock 如果k_perform_open=SMRTargetOpenTypeOpenPath,且对应Tab不存在,将执行此block,并且无默认处理(block==nil时将会默认进行处理)
 */
- (void)supportedActionWithParams:(nullable NSDictionary *)params
                      toChangeTab:(NSInteger)toChangeTab
                 toOpenController:(UIViewController *)controller
                  openActionBlock:(nullable void (^)(UIViewController *controller))openActionBlock
              openPathActionBlock:(nullable void (^)(UIViewController *controller))openPathActionBlock;


/**
 支持打开一个可能在对应Tab控制器,如果对应Tab不存在,则按正常方式进行跳转
 
 @param params              设置:k_perform_open=<SMRTargetOpenType>,将会执行对应的方法方法
 @param toChangeTab         对应要切换的Tab
 @param controller          对应要执行的控制器
 @param openActionBlock     如果k_perform_open=SMRTargetOpenTypeOpen,且对应Tab不存在,将执行此block,并且无默认处理(block==nil时将会默认进行处理)
 @param openPathActionBlock 如果k_perform_open=SMRTargetOpenTypeOpenPath,且对应Tab不存在,将执行此block,并且无默认处理(block==nil时将会默认进行处理)
 */
- (void)supportedMainTabActionWithParams:(nullable NSDictionary *)params
                             toChangeTab:(NSInteger)toChangeTab
                        toOpenController:(UIViewController *)controller
                         openActionBlock:(nullable void (^)(UIViewController *))openActionBlock
                     openPathActionBlock:(nullable void (^)(UIViewController *))openPathActionBlock;


@end


#pragma mark - SMRLastURL

extern NSString * const k_perform_last_url;     ///< "执行前置url"参数的key
@interface SMRTarget (SMRLastURL)

/**
 支持嵌套执行多个url
 
 @param params 设置:k_perform_last_url=<url>,且格式正确时,可以先执行url
 */
- (void)supportedLastURLActionWithParams:(NSDictionary *)params;

@end


#pragma mark - SMRChangeTab

extern NSString * const k_change_tab;       ///< "切换到相应tab"参数中'tab'的key
@interface SMRTarget (SMRChangeTab)

/**
 重置根控制器,并切换到相应tab的方式
 
 @param params 1.tab:可选参数,{change_tab=<tab>},不传change_tab表示无tab切换
 */
- (void)supportedResetRoot:(NSDictionary *)params;

@end

NS_ASSUME_NONNULL_END
