//
//  SMRLayoutTestController.m
//  SMRBaseCoreDemo
//
//  Created by 丁治文 on 2019/1/29.
//  Copyright © 2019 sumrise. All rights reserved.
//

#import "SMRLayoutTestController.h"
#import "SMRLayout.h"

@interface SMRLayoutTestController ()

@end

@implementation SMRLayoutTestController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"item" ofType:@"plist"];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:path];
    [SMRLayoutCenter addSubviews:dict atView:self.view];
}

@end
