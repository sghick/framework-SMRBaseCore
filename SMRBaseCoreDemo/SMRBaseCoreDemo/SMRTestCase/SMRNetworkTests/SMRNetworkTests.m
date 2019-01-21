//
//  SMRNetworkTests.m
//  SMRBaseCoreDemo
//
//  Created by 丁治文 on 2019/1/21.
//  Copyright © 2019 sumrise. All rights reserved.
//

#import "SMRNetworkTests.h"
#import "SMRNetwork.h"

@implementation SMRNetworkTests

- (id)begin {
    [self test_SMRNetwork001];
    [self test_SMRNetwork002];
    [self test_SMRNetwork003];
    return self;
}

- (void)test_SMRNetwork001 {
    SMRNetAPI *api = [SMRNetAPI apiWithIdentifier:NSStringFromSelector(_cmd)
                                           method:SMRReqeustMethodPOST
                                             host:@"http://api.apiopen.top"
                                              url:@"/one"
                                           params:nil
                                         useCache:YES];
    
    api.callback = [SMRAPICallback callbackForPOSTWithCacheBlock:^(SMRNetAPI *api, id response) {
        NSLog(@"=======cache========");
    } successBlock:^(SMRNetAPI *api, id response) {
        NSLog(@"=======success========");
    } faildBlock:^(SMRNetAPI *api, id response, SMRNetError *error) {
        NSLog(@"=======faild========");
    } uploadProgress:^(SMRNetAPI *api, NSProgress *downloadProgress) {
        NSLog(@"=======progress========");
    }];
    [[SMRNetManager sharedManager] query:api];
}

- (void)test_SMRNetwork002 {
    SMRNetAPI *api = [SMRNetAPI apiWithIdentifier:NSStringFromSelector(_cmd)
                                           method:SMRReqeustMethodGET
                                             host:@"http://api.apiopen.top"
                                              url:@"/singlePoetry"
                                           params:nil
                                         useCache:YES];
    api.callback = [SMRAPICallback callbackForPOSTWithCacheBlock:^(SMRNetAPI *api, id response) {
        NSLog(@"=======cache========");
    } successBlock:^(SMRNetAPI *api, id response) {
        NSLog(@"=======success========");
    } faildBlock:^(SMRNetAPI *api, id response, SMRNetError *error) {
        NSLog(@"=======faild========");
    } uploadProgress:^(SMRNetAPI *api, NSProgress *downloadProgress) {
        NSLog(@"=======progress========");
    }];
    [[SMRNetManager sharedManager] query:api];
}

- (void)test_SMRNetwork003 {
    SMRNetAPI *api = [SMRNetAPI apiWithIdentifier:NSStringFromSelector(_cmd)
                                           method:SMRReqeustMethodGET
                                             host:@"https://api.apiopen.top"
                                              url:@"/three"
                                           params:nil
                                         useCache:YES];
    api.callback = [SMRAPICallback callbackForPOSTWithCacheBlock:^(SMRNetAPI *api, id response) {
        NSLog(@"=======cache========");
    } successBlock:^(SMRNetAPI *api, id response) {
        NSLog(@"=======success========");
    } faildBlock:^(SMRNetAPI *api, id response, SMRNetError *error) {
        NSLog(@"=======faild========");
    } uploadProgress:^(SMRNetAPI *api, NSProgress *downloadProgress) {
        NSLog(@"=======progress========");
    }];
    [[SMRNetManager sharedManager] query:api];
}

@end
