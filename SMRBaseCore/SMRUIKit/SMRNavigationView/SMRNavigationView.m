//
//  SMRNavigationView.m
//  SMRBaseCoreDemo
//
//  Created by 丁治文 on 2019/1/7.
//  Copyright © 2019 sumrise. All rights reserved.
//

#import "SMRNavigationView.h"
#import "PureLayout.h"
#import "UIButton+SMR.h"
#import "SMRUIKitBundle.h"
#import "SMRUIAdapter.h"

@interface SMRNavigationView ()

// 主题更换的block
@property (nonatomic, copy  ) NavigationViewResetToThemeBlock themeAction;
// 记录原来的offset, 初始值为-1
@property (nonatomic, assign) CGFloat oldGradationOffset;
// 常驻居左按钮
@property (nonatomic, strong, readonly) NSArray<UIView *> *navLeftViews;

@end

@implementation SMRNavigationView

@synthesize backBtn = _backBtn;
@synthesize closeBtn = _closeBtn;
@synthesize titleLabel = _titleLabel;
@synthesize shadowView = _shadowView;
@synthesize theme = _theme;

static SMRNavigationView *_appearanceNavigationView = nil;
+ (instancetype)appearance {
    static dispatch_once_t _appearanceNavigationViewOnceToken;
    dispatch_once(&_appearanceNavigationViewOnceToken, ^{
        _appearanceNavigationView = [[SMRNavigationView alloc] init];
    });
    return _appearanceNavigationView;
}

+ (instancetype)navigationView {
    SMRNavigationView *navigationView = [[self alloc] init];
    return navigationView;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self baseNavDefaultCreateTypeDefautlViews];
        if (_appearanceNavigationView.appearanceBlock) {
            _appearanceNavigationView.appearanceBlock(self);
        }
    }
    return self;
}

#pragma mark - Default

- (void)baseNavDefaultCreateTypeDefautlViews {
    self.leftViewSize = CGSizeMake(SMRNavigationView.navigationItem.heightOfNavigationContent,
                                   SMRNavigationView.navigationItem.heightOfNavigationContent);
    self.rightViewSize = CGSizeMake(SMRNavigationView.navigationItem.heightOfNavigationContent,
                                    SMRNavigationView.navigationItem.heightOfNavigationContent);
    
    self.leftViews = self.navLeftViews;
    self.centerView = self.titleLabel;
    
    [self.contentView addSubview:self.shadowView];
    
    [self setNeedsUpdateConstraints];
}

- (void)updateConstraints {
    if (self.didLoadLayouts == NO) {
        // shadow
        [self.shadowView autoPinEdgeToSuperviewEdge:ALEdgeLeft];
        [self.shadowView autoPinEdgeToSuperviewEdge:ALEdgeRight];
        [self.shadowView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:-6];
        [self.shadowView autoSetDimension:ALDimensionHeight toSize:6];
    }
    
    [super updateConstraints];
}

- (void)layoutSubviews {
    [self navigationViewNeedResetToTheme:self.theme];
    [super layoutSubviews];
}

- (CGFloat)autoCenterViewMargin {
    CGFloat margin = [SMRUIAdapter value:45];
    if ((self.leftViews.count >= 2) || (self.rightViews.count >= 2)) {
        margin = [SMRUIAdapter value:65];
    }
    return margin;
}

#pragma mark - Theme

- (void)addNavigationThemeAction:(NavigationViewResetToThemeBlock)themeAction {
    _themeAction = themeAction;
    [self setNeedsLayout];
}

- (void)navigationViewNeedResetToTheme:(SMRNavigationTheme *)theme {
    if (theme) {
        self.backgroundColor = theme.backgroudColor;
        self.splitLine.hidden = theme.splitLineHidden;
        self.splitLine.backgroundColor = theme.splitLineColor;
        self.titleLabel.textColor = theme.characterColor;
        [self.backBtn setTintColor:theme.characterColor];
        [self.closeBtn setTintColor:theme.characterColor];
    }
    if (self.themeAction) {
        self.themeAction(theme);
    }
}

#pragma mark - Actions
- (void)backButtonDidTouched:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(navigationView:didBackBtnTouched:)]) {
        [self.delegate navigationView:self didBackBtnTouched:sender];
    }
}

- (void)closeButtonDidTouched:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(navigationView:didCloseBtnTouched:)]) {
        [self.delegate navigationView:self didCloseBtnTouched:sender];
    }
}

- (void)titleTapAction:(UITapGestureRecognizer *)tap {
    if ([self.delegate respondsToSelector:@selector(navigationView:didTitleTouched:)]) {
        [self.delegate navigationView:self didTitleTouched:self.titleLabel];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if ([self.delegate respondsToSelector:@selector(navigationView:didBackgroundTouched:)]) {
        [self.delegate navigationView:self didBackgroundTouched:self];
    }
}

#pragma mark - Getters

- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        UILabel *label = [[UILabel alloc] init];
        label.userInteractionEnabled = YES;
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:18.0];
        
        UITapGestureRecognizer *titleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(titleTapAction:)];
        [label addGestureRecognizer:titleTap];
        
        _titleLabel = label;
    }
    return _titleLabel;
}

- (UIButton *)backBtn {
    if (_backBtn == nil) {
        UIButton *backBtn = [SMRNavigationView buttonOfOnlyImage:[SMRUIKitBundle imageNamed:@"nav_back@3x"]
                                                          target:self
                                                          action:@selector(backButtonDidTouched:)];
        backBtn.frame = CGRectMake(0, 0, 24, 24);
        [backBtn smr_enlargeTapEdge:UIEdgeInsetsMake(20, 20, 20, 0)];
        _backBtn = backBtn;
    }
    return _backBtn;
}

- (UIButton *)closeBtn {
    if (_closeBtn == nil) {
        UIButton *closeBtn = [SMRNavigationView buttonOfOnlyImage:[SMRUIKitBundle imageNamed:@"nav_close@3x"]
                                                           target:self
                                                           action:@selector(closeButtonDidTouched:)];
        closeBtn.frame = CGRectMake(0, 0, 16, 16);
        closeBtn.nav_accessories_space = 5;
        [closeBtn smr_enlargeTapEdge:UIEdgeInsetsMake(20, 5, 20, 20)];
        closeBtn.hidden = YES;
        _closeBtn = closeBtn;
    }
    return _closeBtn;
}

- (UIImageView *)shadowView {
    if (_shadowView == nil) {
        UIImage *image = [SMRUIKitBundle imageNamed:@"nav_shadow"];
        image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(0, 4, 0, 4) resizingMode:UIImageResizingModeStretch];
        UIImageView *view = [[UIImageView alloc] init];
        view.image = image;
        view.hidden = YES;
        _shadowView = view;
    }
    return _shadowView;
}

- (CGFloat)bottom {
    return self.frame.origin.y + self.frame.size.height;
}

- (SMRNavigationTheme *)theme {
    if (!_theme) {
        _theme = [SMRNavigationTheme themeForNormal];
    }
    return _theme;
}

- (NSArray<UIView *> *)navLeftViews {
    return @[self.backBtn, self.closeBtn];
}

#pragma mark - Setters

- (void)setBackBtn:(UIButton *)backBtn {
    [self replaceLeftView:_backBtn withView:backBtn];
    _backBtn = backBtn;
    [backBtn addTarget:self action:@selector(backButtonDidTouched:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setCloseBtn:(UIButton *)closeBtn {
    [self replaceLeftView:_closeBtn withView:closeBtn];
    _closeBtn = closeBtn;
    [closeBtn addTarget:self action:@selector(closeButtonDidTouched:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setTitleLabel:(UILabel *)titleLabel {
    self.centerView = titleLabel;
    _titleLabel = titleLabel;
    UITapGestureRecognizer *titleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(titleTapAction:)];
    [titleLabel addGestureRecognizer:titleTap];
}

- (void)setShadowView:(UIImageView *)shadowView {
    _shadowView = shadowView;
    [self setNeedsLayout];
}

- (void)setTitle:(NSString *)title {
    _title = title;
    self.titleLabel.text = title;
}

- (void)setBackBtnHidden:(BOOL)backBtnHidden {
    _backBtnHidden = backBtnHidden;
    self.backBtn.hidden = backBtnHidden;
    [self setNeedsLayoutLeftViews];
}

- (void)setTitleLabelHidden:(BOOL)titleLabelHidden {
    _titleLabelHidden = titleLabelHidden;
    self.titleLabel.hidden = titleLabelHidden;
    [self setNeedsLayoutCenterViews];
}

- (void)setCloseBtnShow:(BOOL)closeBtnShow {
    _closeBtnShow = closeBtnShow;
    self.closeBtn.hidden = !closeBtnShow;
    [self setNeedsLayoutLeftViews];
}

- (void)setShadowViewShow:(BOOL)shadowViewShow {
    _shadowViewShow = shadowViewShow;
    self.shadowView.hidden = !shadowViewShow;
}

- (void)setGradationOffset:(CGFloat)gradationOffset {
    _gradationOffset = gradationOffset;
    if (self.gradationBlock) {
        self.gradationBlock(self, gradationOffset, self.oldGradationOffset);
    }
    self.oldGradationOffset = gradationOffset;
}

- (void)setTheme:(SMRNavigationTheme *)theme {
    _theme = theme;
    [self setNeedsLayout];
}

- (void)setLeftViews:(NSArray<UIView *> *)leftViews {
    NSMutableArray *lefts = [leftViews mutableCopy];
    [lefts removeObjectsInArray:self.navLeftViews];
    NSMutableArray<UIView *> *arr = [self.navLeftViews mutableCopy];
    [arr addObjectsFromArray:lefts];
    [super setLeftViews:arr];
}

#pragma mark - Utils

// 仅是一个文案的按钮
+ (UIButton *)buttonOfOnlyTextWithText:(NSString *)text target:(id)target action:(SEL)action {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.exclusiveTouch = YES;
    button.adjustsImageWhenHighlighted = NO;
    [button setTitle:text forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    button.titleLabel.font = [UIFont systemFontOfSize:14.0];
    return button;
}

// 一个文案和一个选中文案的按钮
+ (UIButton *)buttonOfOnlyTextWithText:(NSString *)text selectedText:(NSString *)selectedText target:(id)target action:(SEL)action {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.exclusiveTouch = YES;
    button.adjustsImageWhenHighlighted = NO;
    [button setTitle:text forState:UIControlStateNormal];
    [button setTitle:selectedText forState:UIControlStateSelected];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    button.titleLabel.font = [UIFont systemFontOfSize:14.0];
    return button;
}

// 仅是一个图片的按钮
+ (UIButton *)buttonOfOnlyImage:(UIImage *)image target:(id)target action:(SEL)action {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.exclusiveTouch = YES;
    button.adjustsImageWhenHighlighted = NO;
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [button setImage:image forState:UIControlStateNormal];
    return button;
}

// 一个文案和一个图片的按钮
+ (UIButton *)buttonOfTextWithText:(NSString *)text image:(UIImage *)image target:(id)target action:(SEL)action {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.exclusiveTouch = YES;
    button.adjustsImageWhenHighlighted = NO;
    [button setTitle:text forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    button.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [button setImage:image forState:UIControlStateNormal];
    return button;
}

@end
