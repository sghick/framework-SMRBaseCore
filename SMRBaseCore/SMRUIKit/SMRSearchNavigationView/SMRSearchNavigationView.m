//
//  SMRSearchNavigationView.m
//  SMRBaseCoreDemo
//
//  Created by Tinswin on 2020/7/8.
//  Copyright © 2020 Tinswin. All rights reserved.
//

#import "SMRSearchNavigationView.h"
#import "SMRSearchBar.h"
#import "SMRAdapter.h"
#import "PureLayout.h"
#import "UIButton+SMR.h"

static NSString * const kTagForSearchBar = @"kTagForSearchBar";

@interface SMRSearchNavigationView ()<
UITextFieldDelegate>

@property (strong, nonatomic) UIButton *cancelBtn;
@property (strong, nonatomic) NSLayoutConstraint *layoutForSearchBarLeft;
@property (strong, nonatomic) NSLayoutConstraint *layoutForSearchBarRight;
@property (strong, nonatomic) NSLayoutConstraint *layoutForCancelBtnWidth;

@end

@implementation SMRSearchNavigationView

@synthesize searchBar = _searchBar;
@synthesize delegate = _delegate;

- (instancetype)init {
    self = [super init];
    if (self) {
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews {
    self.titleLabelHidden = YES;
    
    __weak typeof(self) weakSelf = self;
    [self addSubviews:@[self.searchBar, self.cancelBtn] tag:kTagForSearchBar];
    [self addLayoutConstraints:^{
        [weakSelf.searchBar autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
        weakSelf.layoutForSearchBarLeft =
        [weakSelf.searchBar autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:[weakSelf leftOfSearchBar]];
        weakSelf.layoutForSearchBarRight =
        [weakSelf.searchBar autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:weakSelf.cancelBtn withOffset:[weakSelf rightOfSearchBar]];
        [weakSelf.searchBar autoSetDimension:ALDimensionHeight toSize:35];
        
        [weakSelf.cancelBtn autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
        [weakSelf.cancelBtn autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:[SMRUIAdapter margin]];
        weakSelf.layoutForCancelBtnWidth =
        [weakSelf.cancelBtn autoSetDimension:ALDimensionWidth toSize:[weakSelf widthOfCancelBtn]];
    } tag:kTagForSearchBar];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self endEditing:YES];
}

- (BOOL)becomeFirstResponder {
    return [self.searchBar.searchTextField becomeFirstResponder];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if ([self.delegate respondsToSelector:@selector(searchNavigationView:shouldBeginEditing:)]) {
        return [self.delegate searchNavigationView:self shouldBeginEditing:self.searchBar];
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([self.delegate respondsToSelector:@selector(searchNavigationView:searchButtonClicked:sender:)]) {
        [self.delegate searchNavigationView:self searchButtonClicked:textField.text sender:self.searchBar];
    }
    return YES;
}


#pragma mark - Actions

- (void)cancelBtnAction:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(searchNavigationView:cancelButtonClicked:sender:)]) {
        return [self.delegate searchNavigationView:self cancelButtonClicked:self.searchBar.searchTextField.text sender:sender];
    }
}

#pragma mark - Utils

- (CGFloat)leftOfSearchBar {
    if (self.backBtnHidden) {
        return [SMRUIAdapter margin];
    } else {
        return [SMRUIAdapter value:60];
    }
}

- (CGFloat)rightOfSearchBar {
    if (self.showCancelBtn) {
        return [SMRUIAdapter value:-15];
    } else {
        return 0;
    }
}

- (CGFloat)widthOfCancelBtn {
    if (self.showCancelBtn) {
        return [SMRUIAdapter value:30];
    } else {
        return 0;
    }
}

#pragma mark - Setters

- (void)setBackBtnHidden:(BOOL)backBtnHidden {
    [super setBackBtnHidden:backBtnHidden];
    self.layoutForSearchBarLeft.constant = [self leftOfSearchBar];
    [self setNeedsUpdateConstraints];
}

- (void)setShowCancelBtn:(BOOL)showCancelBtn {
    _showCancelBtn = showCancelBtn;
    self.cancelBtn.hidden = !showCancelBtn;
    self.layoutForSearchBarRight.constant = [self rightOfSearchBar];
    self.layoutForCancelBtnWidth.constant = [self widthOfCancelBtn];
    [self setNeedsUpdateConstraints];
}

#pragma mark - Getters

- (SMRSearchBar *)searchBar {
    if (!_searchBar) {
        _searchBar = [[SMRSearchBar alloc] init];
        _searchBar.searchTextField.delegate = self;
    }
    return _searchBar;
}

- (UIButton *)cancelBtn {
    if (!_cancelBtn) {
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        _cancelBtn.titleLabel.font = [UIFont smr_systemFontOfSize:14];
        [_cancelBtn setTitleColor:[UIColor smr_generalBlackColor] forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:[UIColor smr_darkGrayColor] forState:UIControlStateHighlighted];
        [_cancelBtn addTarget:self action:@selector(cancelBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [_cancelBtn smr_enlargeTapEdge:UIEdgeInsetsMake(20, 20, 20, 20)];
        _cancelBtn.hidden = YES;
    }
    return _cancelBtn;
}

@end
