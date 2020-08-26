//
//  SMRNetworkTests.m
//  SMRBaseCoreDemo
//
//  Created by 丁治文 on 2019/1/18.
//  Copyright © 2019 sumrise. All rights reserved.
//

#import "SMRNetworkTests.h"
#import "SMRBaseCore.h"
#import "SMRBaseCoreConfig.h"
#import <AFNetworking/AFNetworking.h>

@implementation SMRNetworkTests

- (id)begin {
    [self test_SMRNetwork001];
//    [self test_SMRNetwork002];
//    [self test_SMRNetwork003];
//    [self test_SMRNetwork004];
//    [self test_SMRNetwork005];
    
//    [self testAPI];
    return self;
}

- (void)testAPI {
    
//    NSURLSessionConfiguration *config2 = [NSURLSessionConfiguration defaultSessionConfiguration];
//    NSURLSessionConfiguration *config3 = [NSURLSessionConfiguration ephemeralSessionConfiguration];
//    NSURLSessionConfiguration *config4 = [NSURLSessionConfiguration defaultSessionConfiguration];
//    NSURLSessionConfiguration *config5 = [NSURLSessionConfiguration ephemeralSessionConfiguration];
//    NSURLSessionConfiguration *config6 = [NSURLSessionConfiguration defaultSessionConfiguration];
//    NSURLSession *session = [NSURLSession sharedSession];
//    NSURLSession *session2 = [NSURLSession sessionWithConfiguration:config2];
//    NSURLSession *session3 = [NSURLSession sessionWithConfiguration:config3];
//    NSURLSession *session4 = [NSURLSession sessionWithConfiguration:config4];
//    NSURLSession *session5 = [NSURLSession sessionWithConfiguration:config5];
//    NSURLSession *session6 = [NSURLSession sessionWithConfiguration:config6];
//    NSLog(@"session sghick:%@, %@", session, session.configuration);
//    NSLog(@"session2 sghick:%@, %@", session2, session2.configuration);
//    NSLog(@"session3 sghick:%@, %@", session3, session3.configuration);
//    NSLog(@"session4 sghick:%@, %@", session4, session4.configuration);
//    NSLog(@"session5 sghick:%@, %@", session5, session5.configuration);
//    NSLog(@"session6 sghick:%@, %@", session6, session6.configuration);
//
//
//    NSLog(@"begin sghick %@", @"DEBUG");
//    NSURLSessionTask *task = [session dataTaskWithURL:[NSURL URLWithString:@"https://apitest.aishepin8.com/v1/cities"] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//        NSLog(@"end sghick %@", @"DEBUG");
//    }];
//    [task resume];
//
//    NSLog(@"begin sghick %@", @"DEBUG2");
//    NSURLSessionTask *task2 = [session2 dataTaskWithURL:[NSURL URLWithString:@"https://apitest.aishepin8.com/v1/cities"] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//        NSLog(@"end sghick %@", @"DEBUG2");
//    }];
//    [task2 resume];
//
//    NSLog(@"begin sghick %@", @"DEBUG3");
//    NSURLSessionTask *task3 = [session3 dataTaskWithURL:[NSURL URLWithString:@"https://apitest.aishepin8.com/v1/cities"] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//        NSLog(@"end sghick %@", @"DEBUG3");
//    }];
//    [task3 resume];
//
//    NSLog(@"begin sghick %@", @"DEBUG4");
//    NSURLSessionTask *task4 = [session4 dataTaskWithURL:[NSURL URLWithString:@"https://apitest.aishepin8.com/v1/cities"] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//        NSLog(@"end sghick %@", @"DEBUG4");
//    }];
//    [task4 resume];
//
//    NSLog(@"begin sghick %@", @"DEBUG5");
//    NSURLSessionTask *task5 = [session5 dataTaskWithURL:[NSURL URLWithString:@"https://apitest.aishepin8.com/v1/cities"] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//        NSLog(@"end sghick %@", @"DEBUG5");
//    }];
//    [task5 resume];
//
//    NSLog(@"begin sghick %@", @"DEBUG6");
//    NSURLSessionTask *task6 = [session6 dataTaskWithURL:[NSURL URLWithString:@"https://apitest.aishepin8.com/v1/cities"] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//        NSLog(@"end sghick %@", @"DEBUG6");
//    }];
//    [task6 resume];
//
//
//    NSLog(@"begin sghick %@", @"DEBUG13");
//    NSURLSessionTask *task13 = [session dataTaskWithURL:[NSURL URLWithString:@"https://apitest.aishepin8.com/v1/cities"] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//        NSLog(@"end sghick %@", @"DEBUG13");
//    }];
//    [task13 resume];
//
//
//    AFHTTPSessionManager *afnmanager1 = [AFHTTPSessionManager manager];
//    AFHTTPSessionManager *afnmanager2 = [AFHTTPSessionManager manager];
//    NSLog(@"afnmanager sghick:%@", afnmanager1);
//    NSLog(@"afnmanager2 sghick:%@", afnmanager2);
//
//    NSLog(@"begin sghick %@", @"afn");
//    [afnmanager1 GET:@"https://apitest.aishepin8.com/v1/cities" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSLog(@"end sghick %@", @"afn");
//    } failure:nil];
//
//    NSLog(@"begin sghick %@", @"afn2");
//    [afnmanager1 GET:@"https://apitest.aishepin8.com/v1/cities" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSLog(@"end sghick %@", @"afn2");
//    } failure:nil];
//
//
//
//    NSLog(@"begin sghick %@", @"SMR");
//    [[SMRSession manager] GET:@"https://apitest.aishepin8.com/v1/cities" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSLog(@"end sghick %@", @"SMR");
//    } failure:nil];
//
//    NSLog(@"begin sghick %@", @"SMR2");
//    [[SMRSession manager] GET:@"https://apitest.aishepin8.com/v1/cities" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSLog(@"end sghick %@", @"SMR2");
//    } failure:nil];


    NSLog(@"beign sghick citylist");
    SMRNetAPI *api = [SMRNetAPI apiWithIdentifier:@"getcity"
                                           method:SMRReqeustMethodGET
                                             host:@"https://apitest.aishepin8.com"
                                              url:@"/v1/cities"
                                           params:nil
                                         useCache:NO];
    [[SMRNetManager sharedManager] query:api callback:[SMRAPICallback callbackWithSuccessBlock:^(SMRNetAPI *api, id response) {
        NSLog(@"end sghick citylist");
    } faildBlock:nil]];

    NSLog(@"beign sghick api2");
    SMRNetAPI *api2 = [SMRNetAPI apiWithIdentifier:@"getapi"
                                           method:SMRReqeustMethodPOST
                                             host:nil
                                              url:@"https://api.apiopen.top/EmailSearch?number=1012002"
                                           params:nil
                                         useCache:NO];
    [[SMRNetManager sharedManager] query:api2 callback:[SMRAPICallback callbackWithSuccessBlock:^(SMRNetAPI *api, id response) {
        NSLog(@"end sghick api2");
    } faildBlock:nil]];

    NSLog(@"beign sghick api3");
    SMRNetAPI *api3 = [SMRNetAPI apiWithIdentifier:@"getapi"
                                           method:SMRReqeustMethodPOST
                                             host:nil
                                              url:@"https://api.apiopen.top/EmailSearch?number=1012002"
                                           params:nil
                                         useCache:NO];
    [[SMRNetManager sharedManager] query:api3 callback:[SMRAPICallback callbackWithSuccessBlock:^(SMRNetAPI *api, id response) {
        NSLog(@"end sghick api3");
    } faildBlock:nil]];

    NSLog(@"beign sghick api4");
    SMRNetAPI *api4 = [SMRNetAPI apiWithIdentifier:@"getapi"
                                           method:SMRReqeustMethodPOST
                                             host:nil
                                              url:@"https://api.apiopen.top/EmailSearch?number=1012002"
                                           params:nil
                                         useCache:NO];
    [[SMRNetManager sharedManager] query:api4 callback:[SMRAPICallback callbackWithSuccessBlock:^(SMRNetAPI *api, id response) {
        NSLog(@"end sghick api4");
    } faildBlock:nil]];

    NSLog(@"beign sghick api5");
    SMRNetAPI *api5 = [SMRNetAPI apiWithIdentifier:@"getapi"
                                           method:SMRReqeustMethodPOST
                                             host:nil
                                              url:@"https://api.apiopen.top/EmailSearch?number=1012002"
                                           params:nil
                                         useCache:NO];
    [[SMRNetManager sharedManager] query:api5 callback:[SMRAPICallback callbackWithSuccessBlock:^(SMRNetAPI *api, id response) {
        NSLog(@"end sghick api5");
    } faildBlock:nil]];

    NSLog(@"beign sghick api6");
    SMRNetAPI *api6 = [SMRNetAPI apiWithIdentifier:@"getapi"
                                           method:SMRReqeustMethodPOST
                                             host:nil
                                              url:@"https://api.apiopen.top/EmailSearch?number=1012002"
                                           params:nil
                                         useCache:NO];
    [[SMRNetManager sharedManager] query:api6 callback:[SMRAPICallback callbackWithSuccessBlock:^(SMRNetAPI *api, id response) {
        NSLog(@"end sghick api6");
    } faildBlock:nil]];

    NSLog(@"beign sghick api7");
    SMRNetAPI *api7 = [SMRNetAPI apiWithIdentifier:@"getapi"
                                           method:SMRReqeustMethodPOST
                                             host:nil
                                              url:@"https://api.apiopen.top/EmailSearch?number=1012002"
                                           params:nil
                                         useCache:NO];
    [[SMRNetManager sharedManager] query:api7 callback:[SMRAPICallback callbackWithSuccessBlock:^(SMRNetAPI *api, id response) {
        NSLog(@"end sghick api7");
    } faildBlock:nil]];
}

- (void)test_SMRNetwork001 {
//    SMRBaseCoreConfig *config = [SMRBaseCoreConfig sharedInstance];
//    config.session = [[SMRAFSession alloc] init];
//    [config configInitialization];
    
    // API防抖测试
    for (int i = 0; i < 10; i++) {
        [NSThread sleepForTimeInterval:0.1];
        char str1[30] = { 'L', 'e', 't', '\'', 's',' ', 'g', 'o', i, '\0'};
        dispatch_async(dispatch_queue_create(str1, NULL), ^{
            SMRNetAPI *api = [SMRNetAPI apiWithIdentifier:[NSString stringWithFormat:@"identifier:%@", @(0)]
                                                   method:SMRReqeustMethodGET
                                                     host:nil //@"https://apitest.aishepin8.com"
                                                      url:@"https://api.apiopen.top/EmailSearch"
                                                   params:@{@"number":@(1012002)}
                                                 useCache:YES];
            NSLog(@"发起:%@ inQueue:%@", api.identifier, @(i));
            [api queryWithCallback:[SMRAPICallback callbackWithSuccessBlock:^(SMRNetAPI *api, id response) {
                NSLog(@"成功:%@,%@", api.identifier, response);
            } faildBlock:^(SMRNetAPI *api, id response, NSError *error) {
                NSLog(@"失败:%@", api.identifier);
            }]];
        });
    }
}


- (void)test_SMRNetwork002 {
    // API防抖测试
    for (int i = 0; i < 10; i++) {
        [NSThread sleepForTimeInterval:0.1];
        char str1[30] = { 'H', 'U', 't', '\'', 's',' ', 'g', 'o', i, '\0'};
        dispatch_async(dispatch_queue_create(str1, NULL), ^{
            SMRNetAPI *api = [SMRNetAPI apiWithIdentifier:NSStringFromSelector(_cmd)
                                                   method:SMRReqeustMethodPOST
                                                     host:nil //@"https://apitest.aishepin8.com"
                                                      url:@"https://api.apiopen.top/EmailSearch?number=1012002"
                                                   params:nil
                                                 useCache:YES];
            NSLog(@"发起:%@ inQueue:%@", api.identifier, @(i));
            [api queryWithCallback:[SMRAPICallback callbackWithSuccessBlock:^(SMRNetAPI *api, id response) {
                NSLog(@"成功:%@", api.identifier);
            } faildBlock:^(SMRNetAPI *api, id response, NSError *error) {
                NSLog(@"失败:%@", api.identifier);
            }]];
        });
    }
}

- (void)test_SMRNetwork003 {
    // API防抖测试
    for (int i = 0; i < 30; i++) {
        [self test_SMRNetwork002];
    }
}

- (void)test_SMRNetwork004 {
//    [SMRGlobalCache clearAllCaches];
//    int32_t size = [SMRGlobalCache cacheSize];
//    NSLog(@"缓存值:%@B,%.2fMB", @(size), size/1024.0/1024.0);
    
    // API缓存测试
    SMRNetAPI *api = [SMRNetAPI apiWithIdentifier:NSStringFromSelector(_cmd)
                                           method:SMRReqeustMethodPOST
                                             host:nil //@"https://apitest.aishepin8.com"
                                              url:@"https://api.apiopen.top/EmailSearch?number=1012002"
                                           params:nil
                                         useCache:YES];
    NSLog(@"发起:%@", api.identifier);
    [api.cachePolicy appendCacheKeyWithKey:@"test" value:@"testValue"];
    [api queryWithCallback:[SMRAPICallback callbackWithCacheOrSuccessBlock:^(SMRNetAPI *api, id response, BOOL fromCache) {
        if (fromCache) {
            NSLog(@"缓存:%@,%@", api.identifier, response);
        } else {
            NSLog(@"成功:%@,%@", api.identifier, response);
            int32_t size = [SMRGlobalCache cacheSizeForUnnecessary];
            NSLog(@"缓存值:%@B,%.2fMB", @(size), size/1024.0/1024.0);
        }
    } faildBlock:^(SMRNetAPI *api, id response, NSError *error) {
        NSLog(@"失败:%@", api.identifier);
    }]];
}

- (void)test_SMRNetwork005 {
    static int32_t index = 0;
    // API缓存测试
    SMRNetAPI *api = [SMRNetAPI apiWithIdentifier:NSStringFromSelector(_cmd)
                                           method:SMRReqeustMethodPOST
                                             host:nil //@"https://apitest.aishepin8.com"
                                              url:@"https://api.apiopen.top/EmailSearch?number=1012002"
                                           params:nil
                                         useCache:NO];
    
    NSLog(@"发起:%@,%@", api.identifier, @(index));
    [api.cachePolicy appendCacheKeyWithKey:@"test" value:@"testValue"];
    [api queryWithCallback:[SMRAPICallback callbackWithSuccessBlock:^(SMRNetAPI *api, id response) {
        NSLog(@"成功:%@,%@", api.identifier, @(index));
        if (++index < 2) {
            [self test_SMRNetwork005];
        }
    } faildBlock:^(SMRNetAPI *api, id response, NSError *error) {
        NSLog(@"失败:%@", api.identifier);
    }]];
}

- (void)test_ImageCache001 {
    
}

@end
