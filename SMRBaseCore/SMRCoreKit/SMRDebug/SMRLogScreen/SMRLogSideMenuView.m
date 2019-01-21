//
//  SMRLogSideMenuView.m
//  SMRLogScreenDemo
//
//  Created by 丁治文 on 2018/10/1.
//  Copyright © 2018年 sumrise.com. All rights reserved.
//

#import "SMRLogSideMenuView.h"

@interface SMRLogSideMenuView () <
UITableViewDelegate,
UITableViewDataSource >

@property (nonatomic, strong) UIView *parentView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIImageView *trangleView;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation SMRLogSideMenuView

- (instancetype)initWithFrame:(CGRect)frame {
    if (CGRectEqualToRect(frame, CGRectZero)) {
        frame = [UIScreen mainScreen].bounds;
    }
    self = [super initWithFrame:frame];
    if (self) {
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews {
    _scrollEnabled = YES;
    _maxHeightOfContent = self.bounds.size.height;
    
    [self addSubview:self.contentView];
    [self.contentView addSubview:self.trangleView];
    [self.contentView addSubview:self.tableView];
}

#pragma mark - UITableViewDelegate, UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.menuItems.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat itemHeight = 0;
    if ([self.delegate respondsToSelector:@selector(sideMenuView:heightOfItem:atIndex:)]) {
        UIView *view = self.menuItems[indexPath.row];
        itemHeight = [self.delegate sideMenuView:self heightOfItem:view atIndex:indexPath.row];
        view.frame = CGRectMake(0, 0, self.menuWidth, itemHeight);
    }
    return itemHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"identifierOfDefaultCell"];
    if (self.menuItems.count > indexPath.row) {
        UIView *item = self.menuItems[indexPath.row];
        [cell.contentView addSubview:item];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(sideMenuView:didTouchedItem:atIndex:)]) {
        UIView *view = self.menuItems[indexPath.row];
        [self.delegate sideMenuView:self didTouchedItem:view atIndex:indexPath.row];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Actions

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self hide];
}

#pragma mark - Utils

- (void)show {
    [self showInView:[UIApplication sharedApplication].keyWindow];
}

- (void)showInView:(UIView *)view {
    if (!view) {
        return;
    }
    [view addSubview:self.parentView];
    [view addSubview:self];
    
    [self showAnimations];
}

- (void)hide {
    if ([self.delegate respondsToSelector:@selector(sideMenuViewWillDismiss:)]) {
        [self.delegate sideMenuViewWillDismiss:self];
    }
    [self hideAnimations];
}

- (void)showAnimations {
    self.contentView.alpha = 0.0f;
    self.parentView.alpha = 0.0f;
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.2 animations:^{
        weakSelf.contentView.alpha = 1.0f;
        weakSelf.parentView.alpha = 1.0f;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)hideAnimations {
    [self endEditing:YES];
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.2 animations:^{
        weakSelf.parentView.alpha = 0.0f;
        weakSelf.contentView.alpha = 0.0f;
    } completion:^(BOOL finished) {
        [weakSelf removeFromSuperview];
        [weakSelf.parentView removeFromSuperview];
    }];
}

#pragma mark - Setters

- (void)loadMenuWithItems:(NSArray<UIView *> *)menuItems menuWidth:(CGFloat)menuWidth origin:(CGPoint)origin {
    _menuItems = menuItems;
    _menuWidth = menuWidth;
    
    if ([self.delegate respondsToSelector:@selector(sideMenuView:heightOfItem:atIndex:)]) {
        NSInteger index = 0;
        CGFloat height = 0;
        for (UIView *view in menuItems) {
            height += [self.delegate sideMenuView:self heightOfItem:view atIndex:index];
            index++;
        }
        self.trangleView.transform = CGAffineTransformMakeRotation(-M_PI_2);
        self.contentView.frame = CGRectMake(origin.x, origin.y, menuWidth, height);
        self.trangleView.frame = CGRectMake(-10, 7, 10, 14);
        self.tableView.frame = CGRectMake(0, 0, menuWidth, MIN(height, self.maxHeightOfContent));
    }
    
    [self.tableView reloadData];
}

- (void)setScrollEnabled:(BOOL)scrollEnabled {
    _scrollEnabled = scrollEnabled;
    self.tableView.scrollEnabled = scrollEnabled;
}

#pragma mark - Getters

- (UIView *)parentView {
    if (_parentView == nil) {
        UIView *view = [[UIView alloc] initWithFrame:self.bounds];
        view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
        view.userInteractionEnabled = YES;
        _parentView = view;
    }
    return _parentView;
}

- (UIView *)contentView {
    if (_contentView == nil) {
        UIView *view = [[UIView alloc] init];
        _contentView = view;
    }
    return _contentView;
}

- (UIImageView *)trangleView {
    if (_trangleView == nil) {
        UIImageView *view = [[UIImageView alloc] init];
        view.image = [UIImage imageNamed:@"menu_bg_trangle"];
        _trangleView = view;
    }
    return _trangleView;
}

- (UITableView *)tableView {
    if (_tableView == nil) {
        UITableView *tableView = [[UITableView alloc] init];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.scrollEnabled = _scrollEnabled;
        tableView.backgroundColor = [UIColor whiteColor];
        tableView.layer.cornerRadius = 3;
        _tableView = tableView;
    }
    return _tableView;
}

#pragma mark - Factory

+ (NSArray<UIView *> *)menuItemsWithTitles:(NSArray<NSString *> *)titles {
    NSMutableArray *items = [NSMutableArray array];
    [titles enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont systemFontOfSize:12];
        label.textColor = [UIColor blackColor];
        label.text = [@"    " stringByAppendingString:obj];

        [items addObject:label];
    }];
    return items;
}

@end
