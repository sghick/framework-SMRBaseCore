//
//  SMRTableAlertView.m
//  SMRBaseCoreDemo
//
//  Created by 丁治文 on 2019/2/13.
//  Copyright © 2019 sumrise. All rights reserved.
//

#import "SMRTableAlertView.h"
#import "SMRAdapter.h"

@interface SMRTableAlertView ()<
UITableViewDataSource,
UITableViewDelegate>

@property (strong, nonatomic) UIView *titleBar;
@property (strong, nonatomic) UIView *bottomBar;

@end

@implementation SMRTableAlertView
@synthesize tableView = _tableView;

- (void)removeOldNeedsRemoveSubviews {
    [self.titleBar removeFromSuperview];
    [self.bottomBar removeFromSuperview];
}

- (void)createTableAlertSubviews {
    // 获取内容的边框
    UIEdgeInsets insets = [self smr_insetsOfContent];
    // 获取titleBar的高
    CGFloat marginOfTitleBar = [self smr_marginOfTitleBar];
    CGFloat heightOfTitleBar = 0;
    if ([self respondsToSelector:@selector(smr_heightOfTitleBar)]) {
        heightOfTitleBar = [self smr_heightOfTitleBar];
    }
    // 获取tableView的高
    BOOL overflow = NO;
    CGFloat marginOfTableView = [self smr_marginOfTableView];
    CGFloat heightOfTableView = [self p_caculateheightOfTableViewAndOverflow:&overflow];
    // 获取bottomBar的高
    CGFloat marginOfBottomBar = [self smr_marginOfBottomBar];
    CGFloat heightOfBottomBar = 0;
    if ([self respondsToSelector:@selector(smr_heightOfBottomBar)]) {
        heightOfBottomBar = [self smr_heightOfBottomBar];
    }
    // 计算contentView的高
    CGFloat heightOfContentView = heightOfTitleBar + heightOfTableView + heightOfBottomBar + insets.top + insets.bottom;
    // 设置contentView的高
    [self updateHeightOfContentView:heightOfContentView];
    
    // 添加titleBar
    if ((heightOfTitleBar > 0) && [self respondsToSelector:@selector(smr_titleBarOfTableAlertView)]) {
        _titleBar = [self smr_titleBarOfTableAlertView];
        if (_titleBar) {
            [self.contentView addSubview:_titleBar];
            _titleBar.frame = CGRectMake(insets.left + marginOfTitleBar,
                                         insets.top,
                                         [self widthOfContentView] - insets.left - insets.right - 2*marginOfTitleBar,
                                         heightOfTitleBar);
        }
    }
    // 添加tableView
    [self.contentView addSubview:self.tableView];
    self.tableView.frame = CGRectMake(insets.left + marginOfTableView,
                                      insets.top + heightOfTitleBar,
                                      [self widthOfContentView] - insets.left - insets.right - 2*marginOfTableView,
                                      heightOfTableView);
    // 添加bottomBar
    if ((heightOfBottomBar > 0) && [self respondsToSelector:@selector(smr_bottomBarOfTableAlertView)]) {
        _bottomBar = [self smr_bottomBarOfTableAlertView];
        if (_bottomBar) {
            [self.contentView addSubview:_bottomBar];
            _bottomBar.frame = CGRectMake(insets.left + marginOfBottomBar,
                                          insets.top + heightOfTitleBar + heightOfTableView,
                                          [self widthOfContentView] - insets.left - insets.right - 2*marginOfBottomBar,
                                          heightOfBottomBar);
        }
    }
}

#pragma mark - Privates

/** tableView高度超出最大值,overflow=YES */
- (CGFloat)p_caculateheightOfTableViewAndOverflow:(BOOL *)overflow {
    CGFloat heightOfTableView = 0;
    if ([self respondsToSelector:@selector(smr_heightOfTableView:)]) {
        heightOfTableView = [self smr_heightOfTableView:self.tableView];
    }
    CGFloat maxHeight = CGRectGetHeight(self.bounds);
    if (heightOfTableView > maxHeight) {
        heightOfTableView = maxHeight;
        self.tableView.scrollEnabled = YES;
        *overflow = YES;
    } else {
        *overflow = NO;
    }
    return heightOfTableView;
}

#pragma mark - UITableViewDataSource, UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if ([self respondsToSelector:@selector(smr_numberOfSectionsInTableView:)]) {
        return [self smr_numberOfSectionsInTableView:tableView];
    } else {
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self smr_tableView:tableView numberOfRowsInSection:section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self respondsToSelector:@selector(smr_tableView:heightForRowAtIndexPath:)]) {
        return [self smr_tableView:tableView heightForRowAtIndexPath:indexPath];
    } else {
        return 44.0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self smr_tableView:tableView cellForRowAtIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self respondsToSelector:@selector(smr_tableView:willDisplayCell:forRowAtIndexPath:)]) {
        [self smr_tableView:tableView willDisplayCell:cell forRowAtIndexPath:indexPath];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self respondsToSelector:@selector(smr_tableView:didSelectRowAtIndexPath:)]) {
        [self smr_tableView:tableView didSelectRowAtIndexPath:indexPath];
    }
}

#pragma mark - SMRTableAlertViewProtocol

- (UIEdgeInsets)smr_insetsOfContent {
    return UIEdgeInsetsZero;
}

- (CGFloat)smr_marginOfTitleBar {
    return 0;
}
- (CGFloat)smr_heightOfTitleBar {
    return 0;
}
- (UIView *)smr_titleBarOfTableAlertView {
    return nil;
}

- (CGFloat)smr_marginOfBottomBar {
    return 0;
}
- (CGFloat)smr_heightOfBottomBar {
    return 0;
}
- (UIView *)smr_bottomBarOfTableAlertView {
    return nil;
}

- (CGFloat)smr_marginOfTableView {
    return 0;
}
- (CGFloat)smr_heightOfTableView:(UITableView *)tableView {
    return self.contentView.bounds.size.height;
}
- (NSInteger)smr_numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (CGFloat)smr_tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 0;
}

- (NSInteger)smr_tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSAssert(NO, @"子类必须重写此方法");
    return 0;
}
- (UITableViewCell *)smr_tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSAssert(NO, @"子类必须重写此方法");
    return [[UITableViewCell alloc] init];
}

- (void)smr_tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
}
- (void)smr_tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (void)smr_reloadData {
    [self removeOldNeedsRemoveSubviews];
    [self createTableAlertSubviews];
    [self.tableView reloadData];
}

#pragma mark - Setters

- (void)setTableView:(UITableView *)tableView {
    if (_tableView != tableView) {
        [_tableView removeFromSuperview];
    }
    _tableView = tableView;
    
}

#pragma mark - Getters

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
    }
    return _tableView;
}

@end
