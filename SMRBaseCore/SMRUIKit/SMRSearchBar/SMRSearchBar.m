//
//  SMRSearchBar.m
//  SMRBaseCoreDemo
//
//  Created by Tinswin on 2020/8/7.
//  Copyright © 2020 sumrise. All rights reserved.
//

#import "SMRSearchBar.h"
#import "SMRUIKitBundle.h"
#import "SMRAdapter.h"
#import "PureLayout.h"

@interface SMRSearchBar ()

@property (assign, nonatomic) BOOL didLoadLayout;

@property (strong, nonatomic) NSArray<NSLayoutConstraint *> *layoutsForIconSize;
@property (strong, nonatomic) NSArray<NSLayoutConstraint *> *layoutsForTextField;

@end

@implementation SMRSearchBar

@synthesize iconImageView = _iconImageView;
@synthesize searchTextField = _searchTextField;

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews {
    self.layer.cornerRadius = 6;
    self.layer.borderColor = [UIColor smr_lineGrayColor].CGColor;
    self.layer.borderWidth = LINE_HEIGHT;
    _contentInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    _iconImageSize = CGSizeMake(14, 14);
    _space = 10;
    [self addSubview:self.iconImageView];
    [self addSubview:self.searchTextField];
}

- (void)updateConstraints {
    if (!self.didLoadLayout) {
        self.didLoadLayout = YES;
        
        if (_iconImageView) {
            [self.iconImageView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:self.contentInsets.left];
            [self.iconImageView autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
            [self.iconImageView autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:self.searchTextField withOffset:-self.space];
            [self.layoutsForIconSize autoRemoveConstraints];
            self.layoutsForIconSize =
            [self.iconImageView autoSetDimensionsToSize:self.iconImageSize];
            
            [self.layoutsForTextField autoRemoveConstraints];
            self.layoutsForTextField =
            [self.searchTextField autoPinEdgesToSuperviewEdgesWithInsets:self.contentInsets excludingEdge:ALEdgeLeft];
        } else {
            [self.layoutsForTextField autoRemoveConstraints];
            self.layoutsForTextField =
            [self.searchTextField autoPinEdgesToSuperviewEdgesWithInsets:self.contentInsets];
        }
    }
    [super updateConstraints];
}

#pragma mark - Setters

- (void)setContentInsets:(UIEdgeInsets)contentInsets {
    _contentInsets = contentInsets;
    self.didLoadLayout = NO;
    [self setNeedsUpdateConstraints];
}

- (void)setIconImageView:(UIImageView *)iconImageView {
    _iconImageView = iconImageView;
    self.didLoadLayout = NO;
    [self setNeedsUpdateConstraints];
}

- (void)setIconImageSize:(CGSize)iconImageSize {
    _iconImageSize = iconImageSize;
    self.didLoadLayout = NO;
    [self setNeedsUpdateConstraints];
}

- (void)setSpace:(CGFloat)space {
    _space = space;
    self.didLoadLayout = NO;
    [self setNeedsUpdateConstraints];
}

- (void)setSearchTextField:(UITextField *)searchTextField {
    if (_searchTextField != searchTextField) {
        [self.layoutsForTextField autoRemoveConstraints];
        [_searchTextField removeFromSuperview];
    }
    _searchTextField = searchTextField;
    self.didLoadLayout = NO;
    [self setNeedsUpdateConstraints];
}

#pragma mark - Getters

- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
        _iconImageView.image = [SMRUIKitBundle imageNamed:@"search_bar_icon@3x"];
    }
    return _iconImageView;
}

- (UITextField *)searchTextField {
    if (!_searchTextField) {
        _searchTextField = [[UITextField alloc] init];
        _searchTextField.clearButtonMode = UITextFieldViewModeAlways;
        _searchTextField.textColor = [UIColor smr_generalBlackColor];
        _searchTextField.font = [UIFont systemFontOfSize:13];
        _searchTextField.returnKeyType = UIReturnKeySearch;
    }
    return _searchTextField;
}

@end
