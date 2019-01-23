//
//  SMRRankerConfig.m
//  SMRRankerDemo
//
//  Created by 丁治文 on 2018/7/28.
//  Copyright © 2018年 sumrise.com. All rights reserved.
//

#import "SMRRankerConfig.h"
#import "SMRRankerAction.h"

@implementation SMRRankerConfig

+ (instancetype)defaultConfig {
    SMRRankerConfig *config = [[self alloc] init];
    return config;
}

- (SMRRankerAction *)nextExcuteActionFromActions:(NSArray<SMRRankerAction *> *)actions {
    NSParameterAssert(actions);
    
    BOOL needsBreak = NO;
    SMRRankerAction *action = nil;
    for (SMRRankerAction *act in actions) {
        if (act.markDeleted) {
            continue;
        }
        switch (act.status) {
            case SMRRankerActionStatusReady:
            case SMRRankerActionStatusAppear: {
                // 还有未开始的
                // 还有未未完成的
                needsBreak = YES;
            }
                break;
            case SMRRankerActionStatusRegist:
            case SMRRankerActionStatusClose:
            case SMRRankerActionStatusCancel:
            case SMRRankerActionStatusFaild: {
                // 继续遍历
            }
                break;
            case SMRRankerActionStatusBegin: {
                action = act;
                needsBreak = YES;
            }
                break;
                
            default:
                break;
        }
        
        if (needsBreak) {
            break;
        }
    }
    return action;
}

- (BOOL)shouldExcuteAction:(SMRRankerAction *)action fromActions:(NSArray<SMRRankerAction *> *)actions {
    BOOL validate = YES;
    for (SMRRankerAction *act in actions) {
        // 检测是否有未关闭的,有则不展示新的
        if (act.status == SMRRankerActionStatusAppear) {
            validate = NO;
            break;
        }
    }
    return validate;
}

- (BOOL)shouldChangeStatusWithAction:(SMRRankerAction *)action toStatus:(SMRRankerActionStatus)toStatus {
    NSArray *accessList = [SMRRankerConfig shouldChangeStatusList][@(action.status)];
    if ((accessList.count > 0) && ![accessList containsObject:@(toStatus)]) {
        return NO;
    }
    return YES;
}

+ (NSDictionary *)shouldChangeStatusList {
    NSDictionary *list = @{@(SMRRankerActionStatusRegist):@[@(SMRRankerActionStatusReady)],
                           @(SMRRankerActionStatusReady):@[@(SMRRankerActionStatusCancel),
                                                           @(SMRRankerActionStatusBegin),
                                                           @(SMRRankerActionStatusFaild),
                                                           @(SMRRankerActionStatusClose)],
                           @(SMRRankerActionStatusCancel):@[],
                           @(SMRRankerActionStatusBegin):@[@(SMRRankerActionStatusAppear),
                                                           @(SMRRankerActionStatusCancel),
                                                           @(SMRRankerActionStatusFaild),
                                                           @(SMRRankerActionStatusClose)],
                           @(SMRRankerActionStatusAppear):@[@(SMRRankerActionStatusClose)],
                           @(SMRRankerActionStatusFaild):@[],
                           @(SMRRankerActionStatusClose):@[]};
    return list;
}

@end
