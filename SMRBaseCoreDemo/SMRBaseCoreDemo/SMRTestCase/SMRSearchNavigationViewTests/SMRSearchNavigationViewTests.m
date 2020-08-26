//
//  SMRSearchNavigationViewTests.m
//  SMRBaseCoreDemo
//
//  Created by Tinswin on 2020/8/7.
//  Copyright © 2020 sumrise. All rights reserved.
//

#import "SMRSearchNavigationViewTests.h"
#import "SMRSearchBar.h"
#import "SMRSearchNavigationView.h"

@interface SMRSearchNavigationViewTests ()<
SMRSearchNavigationViewDelegate>

@end

@implementation SMRSearchNavigationViewTests

- (id)begin {
    [self testSearchNavigationView];
    
    return self;
}

- (void)testSearchNavigationView {
    SMRSearchNavigationView *nav = [[SMRSearchNavigationView alloc] init];
    nav.searchBar.searchTextField.text = @"这是昵称";
    nav.searchBar.searchTextField.placeholder = @"搜索内容";
    nav.delegate = self;
    [[UIApplication sharedApplication].delegate.window addSubview:nav];
}

#pragma mark - SMRSearchNavigationViewDelegate

- (BOOL)searchNavigationView:(SMRSearchNavigationView *)navigationView shouldBeginEditing:(id)sender {
    [SMRUtils toast:@"shouldBeginEditing"];
    return YES;
}

- (void)searchNavigationView:(SMRSearchNavigationView *)navigationView cancelButtonClicked:(NSString *)text sender:(id)sender {
    [SMRUtils toast:@"cancelButtonClicked"];
}

- (void)searchNavigationView:(SMRSearchNavigationView *)navigationView searchButtonClicked:(NSString *)text sender:(id)sender {
    [SMRUtils toast:@"searchButtonClicked"];
    navigationView.showCancelBtn = !navigationView.showCancelBtn;
}

@end
