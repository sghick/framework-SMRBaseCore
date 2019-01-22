//
//  ViewController.m
//  SMRBaseCoreDemo
//
//  Created by 丁治文 on 2019/1/21.
//  Copyright © 2019 sumrise. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSLog(@"启动成功,请点击页面进入测试.");
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSString *testClass = @"SMRTableViewTests";
    
    Class cls = NSClassFromString(testClass);
    if (cls) {
        [[[cls alloc] init] begin];
    } else {
        NSLog(@"未找到测试类");
    }
}

@end
