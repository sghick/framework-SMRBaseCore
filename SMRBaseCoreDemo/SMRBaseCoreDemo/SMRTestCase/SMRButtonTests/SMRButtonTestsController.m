//
//  SMRButtonTestsController.m
//  SMRBaseCoreDemo
//
//  Created by 丁治文 on 2019/1/31.
//  Copyright © 2019 sumrise. All rights reserved.
//

#import "SMRButtonTestsController.h"
#import "UIButton+SMR.h"
#import "PureLayout.h"

@interface SMRButtonTestsController ()

@end

@implementation SMRButtonTestsController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationView.title = @"SMRButtonCate测试";
    [self createSubviews];
}

- (void)createSubviews {
    BOOL layout = YES;
    UIButton *button1 = [self createButtonWithTitle:@"图片标题无间距" index:1 layout:layout];
    
    UIButton *button2 = [self createButtonWithTitle:@"图片标题带间距" index:2 layout:layout];
    [button2 smr_makeImageAndTitleWithSpace:50 alignment:SMRContentAlignmentLeft];
    
    UIButton *button3 = [self createButtonWithTitle:@"图片标题无间距" index:3 layout:layout];
    [button3 smr_makeImageToRight];
    
    UIButton *button4 = [self createButtonWithTitle:@"图片标题带间距" index:4 layout:layout];
    [button4 smr_makeImageToRightWithSpace:50 alignment:SMRContentAlignmentLeft];
    
    UIButton *button5 = [self createButtonWithTitle:@"点击范围扩大了" index:5 layout:layout];
    [button5 smr_enlargeTapEdge:UIEdgeInsetsMake(20, 20, 20, 20)];

    
}

- (void)testBtnAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    [sender smr_makeImageRotation:sender.selected?M_PI:0];
    NSLog(@"收到点击事件");
}

- (UIButton *)createButtonWithTitle:(NSString *)title index:(NSInteger)index layout:(BOOL)layout {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.contentMode = UIViewContentModeScaleAspectFill;
    btn.backgroundColor = [UIColor blueColor];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [btn addTarget:self action:@selector(testBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [btn setImage:[UIImage imageNamed:@"fold_trangle_enable"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"fold_trangle_disable"] forState:UIControlStateDisabled];
    [self.view addSubview:btn];
    if (layout) {
        [btn autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:100];
        [btn autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:100 + 60*index];
        [btn autoSetDimensionsToSize:CGSizeMake(200, 50)];
    } else {
        btn.frame = CGRectMake(100, 100 + 60*index, 200, 50);
    }
    return btn;
}

@end
