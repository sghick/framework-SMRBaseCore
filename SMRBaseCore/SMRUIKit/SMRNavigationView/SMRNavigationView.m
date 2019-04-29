//
//  SMRNavigationView.m
//  SMRBaseCoreDemo
//
//  Created by 丁治文 on 2019/1/21.
//  Copyright © 2019 sumrise. All rights reserved.
//

#import "SMRNavigationView.h"
#import "PureLayout.h"
#import "UIButton+SMR.h"
#import "SMRUIKitBundle.h"

@interface SMRNavigationView ()

// 主题更换的block
@property (nonatomic, copy  ) NavigationViewResetToThemeBlock themeAction;
// 记录原来的offset, 初始值为-1
@property (nonatomic, assign) CGFloat oldGradationOffset;

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
    
    self.leftView = self.backBtn;
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
    [self showOrHideBaseAccessories];
}

- (void)showOrHideBaseAccessories {
    // 如果没有左挂件,自动显示返回按钮和关闭按钮
    NSMutableArray *leftarr = [NSMutableArray array];
    // 恢复显示返回按钮
    if (!self.backBtnHidden && ![self.leftViews containsObject:self.backBtn]) {
        [leftarr addObject:self.backBtn];
    }
    // 恢复显示关闭按钮
    if (self.closeBtnShow && ![self.leftViews containsObject:self.closeBtn]) {
        [leftarr addObject:self.closeBtn];
    }
    [super setLeftViews:[leftarr arrayByAddingObjectsFromArray:self.leftViews]];
    
    // 如果没有中间挂件,自动显示标题
    if (!self.centerView) {
        // 恢复显示标题
        if (!self.titleLabelHidden) {
            [super setCenterView:self.titleLabel];
        }
    }
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

#pragma mark - Getters/Setters

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
        UIButton *backBtn = [SMRNavigationView buttonOfOnlyImage:[SMRUIKitBundle imageWithName:@"nav_back@3x"]
                                                          target:self
                                                          action:@selector(backButtonDidTouched:)];
        backBtn.frame = CGRectMake(0, 0, 10, 17);
        [backBtn smr_enlargeTapEdge:UIEdgeInsetsMake(20, 25, 20, 25)];
        _backBtn = backBtn;
    }
    return _backBtn;
}

- (UIButton *)closeBtn {
    if (_closeBtn == nil) {
        UIButton *closeBtn = [SMRNavigationView buttonOfOnlyImage:[SMRUIKitBundle imageWithName:@"nav_close@3x"]
                                                           target:self
                                                           action:@selector(closeButtonDidTouched:)];
        closeBtn.frame = CGRectMake(0, 0, 24, 24);
        [closeBtn smr_enlargeTapEdge:UIEdgeInsetsMake(20, 20, 20, 20)];
        closeBtn.hidden = YES;
        _closeBtn = closeBtn;
    }
    return _closeBtn;
}

- (UIImageView *)shadowView {
    if (_shadowView == nil) {
        UIImage *image = [SMRUIKitBundle imageWithName:@"nav_shadow"];
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

- (void)setBackBtn:(UIButton *)backBtn {
    // 移除默认的
    [self removeViewFromLeftViews:_backBtn];
    _backBtn = backBtn;
    [backBtn addTarget:self action:@selector(backButtonDidTouched:) forControlEvents:UIControlEventTouchUpInside];
    [self setNeedsLayout];
}

- (void)setCloseBtn:(UIButton *)closeBtn {
    // 移除默认的
    [self removeViewFromLeftViews:_closeBtn];
    _closeBtn = closeBtn;
    [closeBtn addTarget:self action:@selector(closeButtonDidTouched:) forControlEvents:UIControlEventTouchUpInside];
    [self setNeedsLayout];
}

- (void)setTitleLabel:(UILabel *)titleLabel {
    _titleLabel = titleLabel;
    UITapGestureRecognizer *titleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(titleTapAction:)];
    [titleLabel addGestureRecognizer:titleTap];
    [self setNeedsLayout];
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
    [self setNeedsLayout];
}

- (void)setTitleLabelHidden:(BOOL)titleLabelHidden {
    _titleLabelHidden = titleLabelHidden;
    self.titleLabel.hidden = titleLabelHidden;
    [self setNeedsLayout];
}

- (void)setCloseBtnShow:(BOOL)closeBtnShow {
    _closeBtnShow = closeBtnShow;
    self.closeBtn.hidden = !closeBtnShow;
    [self setNeedsLayout];
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

- (SMRNavigationTheme *)theme {
    if (!_theme) {
        _theme = [SMRNavigationTheme themeForNormal];
    }
    return _theme;
}

- (void)setLeftViews:(NSArray<UIView *> *)leftViews {
    [super setLeftViews:leftViews];
    [self setNeedsLayout];
}

- (void)setRightViews:(NSArray<UIView *> *)rightViews {
    [super setRightViews:rightViews];
    [self setNeedsLayout];
}

- (void)setCenterView:(UIView *)centerView {
    [super setCenterView:centerView];
    [self setNeedsLayout];
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
