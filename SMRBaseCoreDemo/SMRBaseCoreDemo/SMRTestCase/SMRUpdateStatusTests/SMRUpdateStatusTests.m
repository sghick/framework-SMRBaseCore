//
//  SMRUpdateStatusTests.m
//  SMRBaseCoreDemo
//
//  Created by 丁治文 on 2019/6/20.
//  Copyright © 2019 sumrise. All rights reserved.
//

#import "SMRUpdateStatusTests.h"
#import <SMRDebug/SMRDebuger.h>

@interface SMRUpdateStatusConfig : NSObject<SMRUpdateStatusManagerConfig>

@end

@implementation SMRUpdateStatusConfig

- (NSString *)userName {
    return @"LoginIng";
}

//- (BOOL)shouldAutoReadWithStatus:(SMRUpdateStatus *)status {
//    if ([SMRLifecycle shareInstance].isFirstLaunchForInstall && !status.isNotEmpty && [status.key isEqualToString:@"cuaaaaAuto"]) {
//        return YES;
//    }
//    return NO;
//}

@end

@implementation SMRUpdateStatusTests

- (id)begin {
    [SMRUtils jumpToAnyURL:@"https://www.75txt.org/1/1300/27514007_2.html"];
    return self;
    
    [SMRDebug setDebug:2];
    NSString *aaa = @"";
    SMRLog0(@"aaaa", @[aaa][0]);
    SMRLog1(@"bbb%@", @"111", @[aaa][0]);
    SMRLog2(@"cccc%@%@", @"111", @"222", @[aaa][0]);
    SMRLog3(@"dddd%@%@%@", @"111", @"222", @"333", @[aaa][0]);
    SMRLog4(@"eee%@%@%@%@", @"111", @"222", @"333", @"444", @[aaa][0]);
    SMRLog5(@"eee%@%@%@%@%@", @"111", @"222", @"333", @"444", @"555", @[aaa][0]);
    
    [self testNoConfig];
    SMRUpdateStatusConfig *config = [[SMRUpdateStatusConfig alloc] init];
    [[SMRUpdateStatusManager sharedManager] startWithConfig:config];
    [self testHasUpdate];
    [self testDiscrimination];
    [self testRead];
    [self testAutoRead];
    return self;
}

- (void)testNoConfig {
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
    NSString *key = NSStringFromSelector(_cmd);
    [SMRUpdateStatusManager updateStatusWithKey:key updateTime:time discriminationByUser:YES];
    SMRUpdateStatus *status001 = [SMRUpdateStatusManager getUpdateStatusWithKey:key];
    NSAssert((status001.main_has_new && status001.has_new), @"");
}

- (void)testHasUpdate {
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
    NSString *key = @"cuaaaa";
    [SMRUpdateStatusManager updateStatusWithKey:key updateTime:time discriminationByUser:NO];
    SMRUpdateStatus *status001 = [SMRUpdateStatusManager getUpdateStatusWithKey:key];
    NSAssert((status001.main_has_new && status001.has_new), @"");
}

- (void)testDiscrimination {
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
    NSString *key = @"cuaaaa";
    [SMRUpdateStatusManager updateStatusWithKey:key updateTime:time discriminationByUser:YES];
    SMRUpdateStatus *status001 = [SMRUpdateStatusManager getUpdateStatusWithKey:key];
    NSAssert((status001.main_has_new && status001.has_new), @"");
}

- (void)testRead {
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
    NSString *key = @"cuaaaa";
    [SMRUpdateStatusManager updateStatusWithKey:key updateTime:time discriminationByUser:YES];
    SMRUpdateStatus *status001 = [SMRUpdateStatusManager getUpdateStatusWithKey:key];
    NSAssert((status001.main_has_new && status001.has_new), @"");
    [SMRUpdateStatusManager makeStateReadWithKey:key];
    SMRUpdateStatus *status002 = [SMRUpdateStatusManager getUpdateStatusWithKey:key];
    NSAssert(!(status002.main_has_new && status002.has_new), @"");
}

- (void)testAutoRead {
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
    NSString *key = @"cuaaaaAuto";
    [SMRUpdateStatusManager updateStatusWithKey:key updateTime:time discriminationByUser:YES];
    SMRUpdateStatus *status001 = [SMRUpdateStatusManager getUpdateStatusWithKey:key];
//    NSAssert(!(status001.main_has_new && status001.has_new), @"");
}

@end
