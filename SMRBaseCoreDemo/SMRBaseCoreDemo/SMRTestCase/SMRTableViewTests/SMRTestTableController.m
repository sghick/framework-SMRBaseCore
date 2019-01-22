//
//  SMRTestTableController.m
//  SMRBaseCoreDemo
//
//  Created by 丁治文 on 2019/1/22.
//  Copyright © 2019 sumrise. All rights reserved.
//

#import "SMRTestTableController.h"
#import "SMRTableAssistant.h"

@interface SMRTestTableController ()<
UITableViewDelegate,
UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;

@end

@implementation SMRTestTableController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
}

#pragma mark - UITableViewDelegate, UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCellStyleDefault"];
    cell.textLabel.text = [NSString stringWithFormat:@"%@", @(indexPath.row)];
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView smr_setSeparatorsWithFormat:@"F1|Cn" cell:cell indexPath:indexPath];
}

#pragma mark - Setters/Getters

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,
                                                                   self.navigationView.bottom,
                                                                   CGRectGetWidth([UIScreen mainScreen].bounds),
                                                                   CGRectGetHeight([UIScreen mainScreen].bounds) - self.navigationView.bottom)];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [_tableView smr_markCustomTableViewSeparators];
    }
    return _tableView;
}

@end
