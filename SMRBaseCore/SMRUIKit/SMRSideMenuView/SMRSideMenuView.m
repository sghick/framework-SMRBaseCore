//
//  SMRSideMenuView.m
//  SMRBaseCoreDemo
//
//  Created by Tinswin on 2020/3/31.
//  Copyright © 2020 sumrise. All rights reserved.
//

#import "SMRSideMenuView.h"
#import "SMRAdapter.h"
#import "UITableView+SMRSeparator.h"
#import "SMRUIKitBundle.h"
#import "UIView+SMRShadowView.h"

@interface SMRSideMenuView () <
UITableViewDelegate,
UITableViewDataSource >

@end

@implementation SMRSideMenuView

@synthesize parentView = _parentView;
@synthesize shadowView = _shadowView;
@synthesize contentView = _contentView;
@synthesize trangleView = _trangleView;

@synthesize tableView = _tableView;

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
    _shadowEdgeInsets = UIEdgeInsetsMake(8, 8, 8, 8);
    
    [self addSubview:self.shadowView];
    [self addSubview:self.contentView];
    [self.contentView addSubview:self.trangleView];
    [self.contentView addSubview:self.tableView];
}

#pragma mark - UITableViewDelegate, UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.menuItems.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat itemHeight = 44;
    UIView *view = self.menuItems[indexPath.row];
    if (self.itemHeightBlock) {
        itemHeight = self.itemHeightBlock(self, view, indexPath.row);
    }
    view.frame = CGRectMake(0, 0, self.menuWidth, itemHeight);
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
    if (self.menuTouchedBlock) {
        UIView *view = self.menuItems[indexPath.row];
        self.menuTouchedBlock(self, view, indexPath.row);
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(nonnull UITableViewCell *)cell forRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    [tableView smr_setSeparatorsWithFormat:@"Cn" cell:cell indexPath:indexPath];
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
    if (self.menuWillDismissBlock) {
        self.menuWillDismissBlock(self);
    }
    [self hideAnimations];
}

- (void)showAnimations {
    self.contentView.alpha = 0.0f;
    self.parentView.alpha = 0.0f;
    self.shadowView.alpha = 0.0f;
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.2 animations:^{
        weakSelf.contentView.alpha = 1.0f;
        weakSelf.parentView.alpha = 1.0f;
        weakSelf.shadowView.alpha = 1.0f;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)hideAnimations {
    [self endEditing:YES];
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.2 animations:^{
        weakSelf.parentView.alpha = 0.0f;
        weakSelf.contentView.alpha = 0.0f;
        weakSelf.shadowView.alpha = 0.0f;
    } completion:^(BOOL finished) {
        [weakSelf removeFromSuperview];
        [weakSelf.parentView removeFromSuperview];
    }];
}

#pragma mark - BezierPath

- (CGPathRef)tranglePath {
    UIBezierPath *bpath = [UIBezierPath bezierPath];
    CGFloat sp = 3;
    [bpath moveToPoint:CGPointMake(0, 8 - sp)];
    [bpath addLineToPoint:CGPointMake(5.5, -sp)];
    [bpath addLineToPoint:CGPointMake(11, 8 - sp)];
    
    return bpath.CGPath;
}

#pragma mark - Style - Trangle

- (CGSize)trangleSize {
    switch (self.trangleStyle) {
        case SMRSideMenuTrangleStyleUp:
        case SMRSideMenuTrangleStyleDown: {
            return CGSizeMake(11, 8);
        }
            break;
        case SMRSideMenuTrangleStyleLeft:
        case SMRSideMenuTrangleStyleRight: {
            return CGSizeMake(8, 11);
        }
            break;
        default:
            break;
    }
    return CGSizeZero;
}

- (CGAffineTransform)trangleTransform {
    switch (self.trangleStyle) {
        case SMRSideMenuTrangleStyleUp: {
            return CGAffineTransformMakeRotation(0);
        }
            break;
        case SMRSideMenuTrangleStyleDown: {
            return CGAffineTransformMakeRotation(M_PI);
        }
            break;
        case SMRSideMenuTrangleStyleLeft: {
            return CGAffineTransformMakeRotation(-M_PI_2);
        }
            break;
        case SMRSideMenuTrangleStyleRight: {
            return CGAffineTransformMakeRotation(M_PI_2);
        }
            break;
        default:
            break;
    }
    return CGAffineTransformMakeRotation(0);
}

- (CGPoint)trangleOffsetForReal:(CGSize)tbsize tsize:(CGSize)tsize {
    BOOL reverse = self.trangleOffsetReverse;
    CGPoint offset = self.trangleOffset;
    switch (self.trangleStyle) {
        case SMRSideMenuTrangleStyleUp: {
            return CGPointMake((reverse ? (tbsize.width - tsize.width - offset.x) : offset.x),
                               offset.y - tsize.height);
        }
            break;
        case SMRSideMenuTrangleStyleDown: {
            return CGPointMake((reverse ? (tbsize.width - tsize.width - offset.x) : offset.x),
                               offset.y + tbsize.height);
        }
            break;
        case SMRSideMenuTrangleStyleLeft: {
            return CGPointMake(offset.x - tsize.width,
                               reverse ? (tbsize.height - tsize.height - offset.y) : offset.y);
        }
            break;
        case SMRSideMenuTrangleStyleRight: {
            return CGPointMake(offset.x + tbsize.width,
                               reverse ? (tbsize.height - tsize.height - offset.y) : offset.y);
        }
            break;
        default:
            break;
    }
    return CGPointZero;
}

#pragma mark - Setters

- (void)loadMenuWithItems:(NSArray<UIView *> *)menuItems menuWidth:(CGFloat)menuWidth origin:(CGPoint)origin {
    _menuItems = menuItems;
    _menuWidth = menuWidth;

    CGFloat height = 44*menuItems.count;
    if (self.itemHeightBlock) {
        NSInteger index = 0;
        height = 0;
        for (UIView *view in menuItems) {
            height += self.itemHeightBlock(self, view, index);
            index++;
        }
    }
    CGFloat tbh = MAX(self.minHeightOfContent, MIN(height, self.maxHeightOfContent));
    // 计算content
    UIEdgeInsets ins = self.shadowEdgeInsets;
    self.contentView.frame = CGRectMake(origin.x, origin.y, menuWidth, height);
    self.shadowView.frame = CGRectMake(origin.x - ins.left, origin.y - ins.top, menuWidth + ins.left + ins.right, height + ins.top + ins.bottom);
    // tbh - 1 是为了盖住最底下的线
    self.tableView.frame = CGRectMake(0, 0, menuWidth, tbh - 1);
    
    // 计算trangle
    CGSize tsize = [self trangleSize];
    CGAffineTransform ttransform = [self trangleTransform];
    CGPoint toffset = [self trangleOffsetForReal:CGSizeMake(menuWidth, self.tableView.frame.size.height) tsize:tsize];
    self.trangleView.transform = ttransform;
    self.trangleView.frame = CGRectMake(toffset.x, toffset.y, tsize.width, tsize.height);
    
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
        view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
        view.userInteractionEnabled = YES;
        _parentView = view;
    }
    return _parentView;
}

- (UIImageView *)shadowView {
    if (!_shadowView) {
        UIImageView *view = [[UIImageView alloc] init];
        view.image = [SMRUIKitBundle imageNamed:@"menu_alert_shadow@3x"];
        _shadowView = view;
    }
    return _shadowView;
}

- (UIView *)contentView {
    if (!_contentView) {
        UIView *view = [[UIView alloc] init];
        _contentView = view;
    }
    return _contentView;
}

- (UIImageView *)trangleView {
    if (!_trangleView) {
        UIImageView *view = [[UIImageView alloc] init];
        view.image = [SMRUIKitBundle imageNamed:@"menu_alert_trangle@3x"];
        SMRShadowItem *item = [[SMRShadowItem alloc] init];
        item.shadowColor = [UIColor smr_colorWithHexRGB:@"#C0C0C0"];
        item.shadowOpacity = 0.2;
        item.shadowRadius = 1.5;
        [view setShadowWithItem:item shadowPath:[self tranglePath]];
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
        [tableView smr_markCustomTableViewSeparators];
        _tableView = tableView;
    }
    return _tableView;
}

#pragma mark - Factory

+ (NSArray<UIView *> *)menuItemsWithTitles:(NSArray<NSString *> *)titles {
    NSMutableArray *items = [NSMutableArray array];
    for (NSString *obj in titles) {
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont smr_systemFontOfSize:13];
        label.textColor = [UIColor smr_generalBlackColor];
        label.text = [@"     " stringByAppendingString:obj];
        
        [items addObject:label];
    }
    return items;
}

@end
