//
//  SMRAlertView.m
//  SMRBaseCoreDemo
//
//  Created by 丁治文 on 2019/2/13.
//  Copyright © 2019 sumrise. All rights reserved.
//

#import "SMRAlertView.h"
#import "SMRBaseCoreConfig.h"
#import "SMRUIKitBundle.h"
#import "PureLayout.h"
#import "SMRAdapter.h"
#import "UITableView+Separator.h"
#import "UITableView+SMRSections.h"
#import "SMRAlertViewContentTextCell.h"
#import "SMRAlertViewButton.h"

typedef NS_ENUM(NSInteger, kSectionType) {
    kSectionTypeContent,    ///< 内容
};

typedef NS_ENUM(NSInteger, kRowType) {
    kRowTypeContentText,    ///< 文本内容
    kRowTypeContentImage,   ///< 图片内容
};

static NSString * const identifierOfAlertViewContentTextCell = @"identifierOfAlertViewContentTextCell";

@interface SMRAlertView ()<
UITableViewSectionsDelegate>

@property (assign, nonatomic) SMRAlertViewStyle alertViewStyle;

@end

@implementation SMRAlertView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        if ([SMRBaseCoreConfig sharedInstance].alertViewStyle != SMRAlertViewStyleConfig) {
            // 使用config配置的样式
            _alertViewStyle = [SMRBaseCoreConfig sharedInstance].alertViewStyle;
        } else {
            // 默认使用此样式
            _alertViewStyle = SMRAlertViewStyleWhite;
        }
        
        [self.tableView registerClass:[SMRAlertViewContentTextCell class] forCellReuseIdentifier:identifierOfAlertViewContentTextCell];
        self.tableView.sectionsDelegate = self;
        [self.tableView smr_markCustomTableViewSeparators];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self makeCornerWithStyle:self.alertViewStyle];
}

#pragma mark - Utils

+ (instancetype)alertViewWithContent:(NSString *)content
                        buttonTitles:(NSArray<NSString *> *)buttonTitles
                       deepColorType:(SMRAlertViewButtonDeepColorType)deepColorType {
    SMRAlertView *alertView = [[self alloc] init];
    alertView.content = content;
    alertView.buttonTitles = buttonTitles;
    alertView.deepColorType = deepColorType;
    [alertView smr_reloadData];
    return alertView;
}

+ (instancetype)alertViewWithTitle:(NSString *)title
                           content:(NSString *)content
                      buttonTitles:(NSArray<NSString *> *)buttonTitles
                     deepColorType:(SMRAlertViewButtonDeepColorType)deepColorType {
    SMRAlertView *alertView = [[self alloc] init];
    alertView.title = title;
    alertView.content = content;
    alertView.buttonTitles = buttonTitles;
    alertView.deepColorType = deepColorType;
    [alertView smr_reloadData];
    return alertView;
}

#pragma mark - UITableViewSectionsDelegate

- (SMRSections *)sectionsInTableView:(UITableView *)tableView {
    SMRSections *sections = [[SMRSections alloc] init];
    // 如果要交换位置,可在这里进行修改
    if (self.content.length) {
        [sections addSectionKey:kSectionTypeContent rowKey:kRowTypeContentText];
    }
    if (self.imageURL.length) {
        [sections addSectionKey:kSectionTypeContent rowKey:kRowTypeContentImage];
    }
    return sections;
}

#pragma mark - SMRContentMaskViewProtocol

- (UIEdgeInsets)contentInsetsOfBackgroundImageView {
    return [self contentInsetsOfBackgroundImageViewWithStyle:self.alertViewStyle];
}

#pragma mark - SMRTableAlertViewProtocol

- (UIEdgeInsets)smr_insetsOfContent {
    if (!self.title.length) {
        // 无标题时
        return [SMRUIAdapter insets:UIEdgeInsetsMake(56, 0, 0, 0)];
    } else {
        // 有标题时
        return [SMRUIAdapter insets:UIEdgeInsetsMake(30, 0, 0, 0)];
    }
    
}

- (CGFloat)smr_marginOfTitleBar {
    return [SMRUIAdapter value:20];
}

- (CGFloat)smr_heightOfTitleBar {
    // 有标题时
    if (self.title.length) {
        return [SMRUIAdapter value:26 + 20];
    }
    return 0.0;
}

- (UIView *)smr_titleBarOfTableAlertView {
    if (self.title.length) {
        UIView *titleView = [[UIView alloc] init];
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = [UIFont smr_boldSystemFontOfSize:17];
        titleLabel.textColor = [UIColor smr_colorWithHexRGB:@"#333333"];
        titleLabel.text = self.title;
        
        [titleView addSubview:titleLabel];
        [titleLabel autoPinEdgeToSuperviewEdge:ALEdgeTop];
        [titleLabel autoAlignAxisToSuperviewAxis:ALAxisVertical];
        
        return titleView;
    }
    return nil;
}

- (CGFloat)smr_heightOfBottomBar {
    // 有按钮时
    if (self.buttonTitles.count) {
        return [SMRUIAdapter value:45] + [self heightOfButtonForStyle:self.alertViewStyle];
    }
    return 0;
}

- (UIView *)smr_bottomBarOfTableAlertView {
    // 有按钮时
    if (self.buttonTitles.count) {
        NSArray<UIButton *> *buttons = nil;
        if (self.buttonTitles.count == 1) {
            // 1个按钮时,sure
            UIButton *sureBtn = [self buttonForStyle:self.alertViewStyle
                                               title:self.buttonTitles[0]
                                              target:self
                                              action:@selector(sureBtnAction:)
                                           deepColor:(self.deepColorType&SMRAlertViewButtonDeepColorTypeSure)];
            buttons = @[sureBtn];
        } else if (self.buttonTitles.count == 2) {
            // 2个按钮时,cancel+sure
            UIButton *cancelBtn = [self buttonForStyle:self.alertViewStyle
                                                 title:self.buttonTitles[0]
                                                target:self
                                                action:@selector(cancelBtnAction:)
                                             deepColor:(self.deepColorType&SMRAlertViewButtonDeepColorTypeCancel)];
            UIButton *sureBtn = [self buttonForStyle:self.alertViewStyle
                                               title:self.buttonTitles[1]
                                              target:self
                                              action:@selector(sureBtnAction:)
                                           deepColor:(self.deepColorType&SMRAlertViewButtonDeepColorTypeSure)];
            buttons = @[cancelBtn, sureBtn];
        }
        
        CGFloat height = [self heightOfButtonForStyle:self.alertViewStyle];
        CGFloat onepix = 1/[UIScreen mainScreen].scale;
        UIView *bottomView = [[UIView alloc] init];
        SMRAlertViewButton *btn = [[SMRAlertViewButton alloc] initWithButtons:buttons height:height space:-onepix];
        [bottomView addSubview:btn];
        [btn autoPinEdgeToSuperviewEdge:ALEdgeLeft];
        [btn autoPinEdgeToSuperviewEdge:ALEdgeRight];
        [btn autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:-onepix];
        [btn autoSetDimension:ALDimensionHeight toSize:height];
        
        return bottomView;
    }
    return nil;
}

- (CGFloat)smr_marginOfTableView {
    return [SMRUIAdapter value:20];
}

- (CGFloat)smr_heightOfTableView:(UITableView *)tableView {
    CGFloat heightOfTableView = 0;
    NSIndexPath *indexPathForContentText = [tableView.sections indexPathWithRowKey:kRowTypeContentText];
    CGFloat heightOfContentText = indexPathForContentText ? [self smr_tableView:tableView heightForRowAtIndexPath:indexPathForContentText] : 0;
    
    NSIndexPath *indexPathForContentImage = [tableView.sections indexPathWithRowKey:kRowTypeContentImage];
    CGFloat heightOfContentImage = indexPathForContentImage ? [self smr_tableView:tableView heightForRowAtIndexPath:indexPathForContentImage] : 0;
    
    heightOfTableView = heightOfContentText + heightOfContentImage;
    return heightOfTableView;
}

- (CGFloat)smr_tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    SMRRow *row = [tableView rowWithIndexPath:indexPath];
    switch (row.rowKey) {
        case kRowTypeContentText: {
            if (self.content.length) {
                UIEdgeInsets insets = [self smr_insetsOfContent];
                return [SMRAlertViewContentTextCell heightOfCellWithAttributeText:[SMRAlertViewContentTextCell defaultAttributeText:self.content]
                                                                         fitWidth:([self widthOfContentView] - insets.left - insets.right)];
            }
            return 0;
        }
            break;
        case kRowTypeContentImage: {
            if (self.imageURL.length) {
                return [SMRUIAdapter value:100.0];
            }
            return 0;
        }
            break;
        default:
            break;
    }
    return 0;
}

- (NSInteger)smr_tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    SMRSection *sec = [tableView sectionWithIndexPathSection:section];
    return sec.rowSamesCountOfAll;
}

- (UITableViewCell *)smr_tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SMRRow *row = [tableView rowWithIndexPath:indexPath];
    switch (row.rowKey) {
        case kRowTypeContentText: {
            SMRAlertViewContentTextCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierOfAlertViewContentTextCell];
            cell.attributeText = [SMRAlertViewContentTextCell defaultAttributeText:self.content];
            return cell;
        }
            break;
            
        default:
            break;
    }
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    return cell;
}

- (void)smr_tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView smr_setSeparatorsWithFormat:SMRSeperatorsFormatAllNone cell:cell indexPath:indexPath];
}

- (void)smr_reloadData {
    self.tableView.sectionsDelegate = self;
    [self.tableView smr_reloadData];
    [super smr_reloadData];
}

#pragma mark - Style

- (CGFloat)heightOfButtonForStyle:(SMRAlertViewStyle)style {
    switch (style) {
        case SMRAlertViewStyleOrange: {
            return [SMRUIAdapter value:45];
        }
            break;
        default:
            break;
    }
    return [SMRUIAdapter value:55];
}

- (UIButton *)buttonForStyle:(SMRAlertViewStyle)style title:(NSString *)title target:(id)target action:(SEL)action deepColor:(BOOL)deepColor {
    switch (style) {
        case SMRAlertViewStyleOrange: {
            return [SMRAlertViewButton orangeButtonWithTitle:title target:target action:action deepColor:deepColor];
        }
            break;
        default:
            break;
    }
    return [SMRAlertViewButton whiteButtonWithTitle:title target:target action:action deepColor:deepColor];
}

- (UIEdgeInsets)contentInsetsOfBackgroundImageViewWithStyle:(SMRAlertViewStyle)style {
    switch (self.alertViewStyle) {
        case SMRAlertViewStyleOrange: {
            return [SMRUIAdapter insets:UIEdgeInsetsMake(5, 5, 5, 5)];
        }
            break;
            
        default:
            break;
    }
    return UIEdgeInsetsZero;
}

- (void)makeCornerWithStyle:(SMRAlertViewStyle)style {
    switch (style) {
        case SMRAlertViewStyleOrange: {
            self.backgroundImageView.image = [SMRUIKitBundle imageWithName:@"alert_bg@3x"];
            self.contentView.clipsToBounds = YES;
            self.contentView.layer.cornerRadius = 5;
            self.backgroundColor = [UIColor clearColor];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - Actions

- (void)sureBtnAction:(UIButton *)sender {
    if (self.sureButtonTouchedBlock) {
        self.sureButtonTouchedBlock(self);
    } else {
        [self hide];
    }
}

- (void)cancelBtnAction:(UIButton *)sender {
    if (self.cancelButtonTouchedBlock) {
        self.cancelButtonTouchedBlock(self);
    } else {
        [self hide];
    }
}

#pragma mark - Setters

- (void)setButtonTitles:(NSArray<NSString *> * _Nonnull)buttonTitles {
    _buttonTitles = buttonTitles;
}

- (void)setTitle:(NSString * _Nonnull)title {
    _title = title;
}

- (void)setContent:(NSString * _Nonnull)content {
    _content = content;
}

- (void)setDeepColorType:(SMRAlertViewButtonDeepColorType)deepColorType {
    _deepColorType = deepColorType;
}

@end
