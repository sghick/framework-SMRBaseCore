//
//  SMRLayoutTestController.m
//  SMRBaseCoreDemo
//
//  Created by 丁治文 on 2019/1/29.
//  Copyright © 2019 sumrise. All rights reserved.
//

#import "SMRLayoutTestController.h"
#import "SMRLayout.h"
#import "SMRUtilsHeader.h"

@interface SMRLayoutTestController ()

@end

@implementation SMRLayoutTestController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationView.backBtn = [self backBtn];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"item" ofType:@"plist"];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:path];
    [SMRLayoutCenter addSubviews:dict atView:self.view];
}

- (UIButton *)backBtn {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.exclusiveTouch = YES;
    button.adjustsImageWhenHighlighted = NO;
    [button setImage:[SMRUtils createImageWithColor:[UIColor redColor] rect:CGRectMake(0, 0, 50, 50)] forState:UIControlStateNormal];
    return button;
}

@end
