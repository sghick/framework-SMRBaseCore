//
//  ViewController.m
//  SMRBaseCoreDemo
//
//  Created by 丁治文 on 2019/1/21.
//  Copyright © 2019 sumrise. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (strong, nonatomic) UIButton *testBtn;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self.view addSubview:self.testBtn];
    NSLog(@"启动成功,请点击页面进入测试.");
}

- (void)testBtnAction:(UIButton *)sender {
    NSString *testClass = @"SMRAdapterTests";
    
    Class cls = NSClassFromString(testClass);
    if (cls) {
        NSLog(@"开始测试");
        [[[cls alloc] init] begin];
        NSLog(@"结束");
    } else {
        NSLog(@"未找到测试类");
    }
}

- (UIButton *)testBtn {
    if (!_testBtn) {
        _testBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        _testBtn.frame = CGRectMake(0, 100, [UIScreen mainScreen].bounds.size.width, 300);
        [_testBtn setTitle:@"点我开始测试" forState:UIControlStateNormal];
        [_testBtn addTarget:self action:@selector(testBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _testBtn;
}

@end
