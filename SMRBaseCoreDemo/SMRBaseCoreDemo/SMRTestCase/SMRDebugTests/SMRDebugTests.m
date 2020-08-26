//
//  SMRDebugTests.m
//  SMRBaseCoreDemo
//
//  Created by 丁治文 on 2019/4/17.
//  Copyright © 2019 sumrise. All rights reserved.
//

#import "SMRDebugTests.h"

#if SMRDebugRelease

#import "SMRDebug.h"
#import "SMRUtils+NSDate.h"
#import "SMRNetInfo.h"

@implementation SMRDebugTests

- (id)begin {
    [self teskOpen];
//    [self testKey];
    return self;
}

- (void)teskOpen {
    NSString *uk = @"abc";
    NSString *ck = [SMRDebug createCheckCodeWithKey:uk date:[NSDate date]];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"SMR-debug://debug?status=1&uk=%@&ck=%@", uk, ck]];
    [SMRDebug setDebugModelWithURL:url allowScheme:@"SMR-debug" uk:uk];
}

- (void)testKey {
    NSDate *date1 = [SMRUtils convertToDateFromDateString:@"2019-4-17 13:22" format:@"yyyy-MM-dd HH:mm"];
    NSString *str1 = [SMRDebug createCheckCodeWithKey:@"ADCDF" date:date1];
    NSString *str2 = [SMRDebug createCheckCodeWithKey:@"ADCDFG" date:date1];
    
    NSDate *date2 = [date1 dateByAddingTimeInterval:59];
    NSString *str21 = [SMRDebug createCheckCodeWithKey:@"ADCDF" date:date2];
    NSString *str22 = [SMRDebug createCheckCodeWithKey:@"ADCDFG" date:date2];
    
    NSDate *date3 = [date1 dateByAddingTimeInterval:60];
    NSString *str31 = [SMRDebug createCheckCodeWithKey:@"ADCDF" date:date3];
    NSString *str32 = [SMRDebug createCheckCodeWithKey:@"ADCDFG" date:date3];
    
    NSDate *date4 = [date1 dateByAddingTimeInterval:61];
    NSString *str41 = [SMRDebug createCheckCodeWithKey:@"ADCDF" date:date4];
    NSString *str42 = [SMRDebug createCheckCodeWithKey:@"ADCDFG" date:date4];
    
    NSLog(@"str1:%@", str1);
    NSLog(@"str2:%@", str2);
    
    NSLog(@"str21:%@", str21);
    NSLog(@"str22:%@", str22);
    
    NSLog(@"str31:%@", str31);
    NSLog(@"str32:%@", str32);
    
    NSLog(@"str41:%@", str41);
    NSLog(@"str42:%@", str42);
    
    assert(![str1 isEqualToString:str2]);
    assert([str1 isEqualToString:str21]);
    assert(![str1 isEqualToString:str31]);
    assert(![str1 isEqualToString:str41]);
}

@end

#else

@implementation SMRDebugTests

- (id)begin {
    return self;
}

@end

#endif
