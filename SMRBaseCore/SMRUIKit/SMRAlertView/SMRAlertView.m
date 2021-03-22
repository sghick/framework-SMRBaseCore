//
//  SMRAlertView.m
//  SMRBaseCoreDemo
//
//  Created by 丁治文 on 2019/2/14.
//  Copyright © 2019 sumrise. All rights reserved.
//

#import "SMRAlertView.h"
#import "SMRUIAppearance.h"
#import "PureLayout.h"
#import "SMRAdapter.h"
#import "SMRUtilsUIHeader.h"
#import "UITableView+SMRSeparator.h"
#import "UITableView+SMRSections.h"
#import "SMRAlertViewContentTextCell.h"
#import "SMRAlertViewImageCell.h"
#import "SMRLinkLabel.h"

typedef NS_ENUM(NSInteger, kSectionType) {
    kSectionTypeContent,    ///< 内容
};

typedef NS_ENUM(NSInteger, kRowType) {
    kRowTypeContentText,        ///< 文本内容
    kRowTypeContentImage,       ///< 图片内容
    kRowTypeContentTextField,   ///< 输入框内容
};

static NSString * const identifierOfAlertViewContentTextCell = @"identifierOfAlertViewContentTextCell";
static NSString * const identifierOfAlertViewImageCell = @"identifierOfAlertViewImageCell";
static NSString * const identifierOfAlertViewTextFieldCell = @"identifierOfAlertViewTextFieldCell";

@interface SMRAlertView ()<
UITableViewSectionsDelegate,
SMRAlertViewContentTextCellDelegate>

@property (strong, nonatomic) NSMutableDictionary<NSString *,NSURL *> *linkSymbols;

@end

@implementation SMRAlertView

@synthesize textField = _textField;

+ (void)smr_beforeAppearance:(SMRAlertView *)obj {
    obj.contentTextAlignment = NSTextAlignmentCenter;
    obj.titleColor = [UIColor smr_colorWithHexRGB:@"#333333"];
    obj.enabledTextCheckingTypes = NSTextCheckingTypeLink|NSTextCheckingTypePhoneNumber;
    obj.linkAttributes = @{NSForegroundColorAttributeName:[UIColor blueColor],
                            NSUnderlineStyleAttributeName:@(NSUnderlineStyleSingle)};
}

- (instancetype)initWithFrame:(CGRect)frame contentAlignment:(SMRContentMaskViewContentAlignment)contentAlignment {
    self = [super initWithFrame:frame contentAlignment:contentAlignment];
    if (self) {
        // 使用config配置的样式
        _contentTextAlignment = self.smr_appearance.contentTextAlignment;
        _titleColor = self.smr_appearance.titleColor;
        _enabledTextCheckingTypes = self.smr_appearance.enabledTextCheckingTypes;
        _linkAttributes = self.smr_appearance.linkAttributes;
        
        __weak typeof(self) weakSelf = self;
        self.contentViewTouchedBlock = ^(id  _Nonnull maskView) {
            [weakSelf endEditing:YES];
        };
        self.backgroundTouchedBlock = ^(id  _Nonnull maskView) {
            [weakSelf endEditing:YES];
        };
        
        [self.tableView registerClass:SMRAlertViewContentTextCell.class forCellReuseIdentifier:identifierOfAlertViewContentTextCell];
        [self.tableView registerClass:SMRAlertViewImageCell.class forCellReuseIdentifier:identifierOfAlertViewImageCell];
        [self.tableView registerClass:UITableViewCell.class forCellReuseIdentifier:identifierOfAlertViewTextFieldCell];
        self.tableView.sectionsDelegate = self;
        [self.tableView smr_markCustomTableViewSeparators];
    }
    return self;
}

- (CGFloat)widthOfContentView {
    if (self.contentAlignment == SMRContentMaskViewContentAlignmentCenter) {
        return CGRectGetWidth([UIScreen mainScreen].bounds) - 2*[SMRUIAdapter value:43.0];
    }
    return [super widthOfContentView];
}

#pragma mark - Utils

- (void)addLinkToURL:(NSURL *)url withRange:(NSRange)range {
    if (url) {
        self.linkSymbols[NSStringFromRange(range)] = url;
    }
}

- (void)addImage:(UIImage *)image size:(CGSize)size space:(CGFloat)space {
    _image = image;
    _imageSize = size;
    _imageSpace = space;
    [self smr_setNeedsReloadView];
}

- (void)addImageURL:(NSString *)imageURL size:(CGSize)size space:(CGFloat)space {
    _imageURL = imageURL;
    _imageSize = size;
    _imageSpace = space;
    [self smr_setNeedsReloadView];
}

+ (instancetype)alertView {
    SMRAlertView *alertView = [[self alloc] init];
    [alertView smr_setNeedsReloadView];
    return alertView;
}

+ (instancetype)alertViewWithContent:(NSString *)content
                        buttonTitles:(NSArray<NSString *> *)buttonTitles
                       deepColorType:(SMRAlertViewButtonDeepColorType)deepColorType {
    SMRAlertView *alertView = [[self alloc] init];
    alertView.content = content;
    alertView.attributeContent = [[NSAttributedString alloc] initWithString:content];
    alertView.buttonTitles = buttonTitles;
    alertView.deepColorType = deepColorType;
    return alertView;
}

+ (instancetype)alertViewWithTitle:(NSString *)title
                           content:(NSString *)content
                      buttonTitles:(NSArray<NSString *> *)buttonTitles
                     deepColorType:(SMRAlertViewButtonDeepColorType)deepColorType {
    SMRAlertView *alertView = [[self alloc] init];
    alertView.title = title;
    alertView.content = content;
    alertView.attributeContent = [[NSAttributedString alloc] initWithString:content];
    alertView.buttonTitles = buttonTitles;
    alertView.deepColorType = deepColorType;
    return alertView;
}

+ (instancetype)alertViewWithAttributeContent:(NSAttributedString *)attributeContent
                                 buttonTitles:(NSArray<NSString *> *)buttonTitles
                                deepColorType:(SMRAlertViewButtonDeepColorType)deepColorType {
    SMRAlertView *alertView = [[self alloc] init];
    alertView.content = attributeContent.string;
    alertView.attributeContent = attributeContent;
    alertView.buttonTitles = buttonTitles;
    alertView.deepColorType = deepColorType;
    return alertView;
}

+ (instancetype)alertViewWithTitle:(NSString *)title
                  attributeContent:(NSAttributedString *)attributeContent
                      buttonTitles:(NSArray<NSString *> *)buttonTitles
                     deepColorType:(SMRAlertViewButtonDeepColorType)deepColorType {
    SMRAlertView *alertView = [[self alloc] init];
    alertView.title = title;
    alertView.content = attributeContent.string;
    alertView.attributeContent = attributeContent;
    alertView.buttonTitles = buttonTitles;
    alertView.deepColorType = deepColorType;
    return alertView;
}

+ (instancetype)alertViewWithTextFieldAndButtonTitles:(NSArray<NSString *> *)buttonTitles
                                        deepColorType:(SMRAlertViewButtonDeepColorType)deepColorType
                                          configStyle:(UITextField * _Nonnull (^)(UITextField * _Nonnull))configStyle {
    SMRAlertView *alertView = [[self alloc] init];
    alertView.useTextField = YES;
    alertView.buttonTitles = buttonTitles;
    alertView.deepColorType = deepColorType;
    if (configStyle) {
        alertView.textField = configStyle(alertView.textField);
    }
    return alertView;
}

#pragma mark - UITableViewSectionsDelegate

- (SMRSections *)sectionsInTableView:(UITableView *)tableView {
    SMRSections *sections = [[SMRSections alloc] init];
    // 如果要交换位置,可在这里进行修改
    if (self.content.length) {
        [sections addSectionKey:kSectionTypeContent rowKey:kRowTypeContentText];
    }
    if ([self p_shouldShowImage]) {
        [sections addSectionKey:kSectionTypeContent rowKey:kRowTypeContentImage];
    }
    if (self.useTextField) {
        [sections addSectionKey:kSectionTypeContent rowKey:kRowTypeContentTextField];
    }
    return sections;
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
        titleLabel.textColor = self.titleColor;
        titleLabel.text = self.title;
        
        [titleView addSubview:titleLabel];
        [titleLabel autoPinEdgeToSuperviewEdge:ALEdgeTop];
        [titleLabel autoAlignAxisToSuperviewAxis:ALAxisVertical];
        
        return titleView;
    }
    return nil;
}

- (CGFloat)smr_marginOfTableView {
    return [SMRUIAdapter value:20];
}

- (CGFloat)smr_heightOfTableView:(UITableView *)tableView {
    CGFloat heightOfTableView = 0;
    NSIndexPath *indexPathForContentText = [tableView.sections indexPathWithSectionKey:kSectionTypeContent rowKey:kRowTypeContentText];
    CGFloat heightOfContentText = indexPathForContentText ? [self smr_tableView:tableView heightForRowAtIndexPath:indexPathForContentText] : 0;
    
    NSIndexPath *indexPathForContentImage = [tableView.sections indexPathWithSectionKey:kSectionTypeContent rowKey:kRowTypeContentImage];
    CGFloat heightOfContentImage = indexPathForContentImage ? [self smr_tableView:tableView heightForRowAtIndexPath:indexPathForContentImage] : 0;
    
    
    NSIndexPath *indexPathForContentTextField = [tableView.sections indexPathWithSectionKey:kSectionTypeContent rowKey:kRowTypeContentTextField];
    CGFloat heightOfContentTextField = indexPathForContentTextField ? [self smr_tableView:tableView heightForRowAtIndexPath:indexPathForContentTextField] : 0;
    
    heightOfTableView = heightOfContentText + heightOfContentImage + heightOfContentTextField;
    return heightOfTableView;
}

- (CGFloat)smr_tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    SMRRow *row = [tableView rowWithIndexPath:indexPath];
    switch (row.rowKey) {
        case kRowTypeContentText: {
            if (self.content.length) {
                NSAttributedString *attr = [SMRAlertViewContentTextCell attributeStringWithAttributedContent:self.attributeContent alignment:self.contentTextAlignment];
                CGFloat height = [SMRAlertViewContentTextCell heightOfCellWithAttributeText:attr
                                                                         fitWidth:[self maxLayoutOfLabelWidth]];
                return height;
            }
            return 0;
        }
            break;
        case kRowTypeContentImage: {
            return self.imageSize.height + self.imageSpace;
        }
            break;
        case kRowTypeContentTextField: {
            return [SMRUIAdapter value:60];
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
            cell.maxLayoutWidth = [self maxLayoutOfLabelWidth];
            NSAttributedString *attr = [SMRAlertViewContentTextCell attributeStringWithAttributedContent:self.attributeContent alignment:self.contentTextAlignment];
            cell.alignment = self.contentTextAlignment;
            cell.contentLabel.enabledTextCheckingTypes = self.enabledTextCheckingTypes;
            cell.contentLabel.linkAttributes = self.linkAttributes;
            cell.attributeText = attr;
            cell.delegate = self;
            
            // 添加额外的URL链接
            [self.linkSymbols enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSURL * _Nonnull obj, BOOL * _Nonnull stop) {
                [cell addLinkToURL:obj withRange:NSRangeFromString(key)];
            }];
            return cell;
        }
            break;
        case kRowTypeContentImage: {
            SMRAlertViewImageCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierOfAlertViewImageCell];
            cell.imageSize = self.imageSize;
            cell.imageViewContentMode = self.imageViewContentMode;
            if (self.image) {
                cell.image = self.image;
            }
            if (self.imageURL.length) {
                cell.imageURL = self.imageURL;
            }
            if (self.imageBackgroundColor) {
                cell.contentView.backgroundColor = self.imageBackgroundColor;
                cell.backgroundColor = self.imageBackgroundColor;
            }
            return cell;
        }
            break;
        case kRowTypeContentTextField: {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierOfAlertViewTextFieldCell];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell.contentView addSubview:self.textField];
            [self.textField autoPinEdgeToSuperviewEdge:ALEdgeTop];
            [self.textField autoPinEdgeToSuperviewEdge:ALEdgeBottom];
            [self.textField autoAlignAxisToSuperviewAxis:ALAxisVertical];
            [self.textField autoSetDimension:ALDimensionWidth toSize:[self maxLayoutOfTextFieldWidth]];
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
    [tableView smr_setSeparatorsWithFormat:SMRSeperatorsFormatNone cell:cell indexPath:indexPath];
}

- (void)smr_reloadData {
    self.tableView.sectionsDelegate = self;
    [self.tableView smr_reloadData];
    [super smr_reloadData];
}

#pragma mark - SMRAlertViewContentTextCellDelegate

- (void)alertTextCell:(SMRAlertViewContentTextCell *)cell didSelectLinkWithPhoneNumber:(NSString *)phoneNumber {
    if (self.phoneLinkTouchedBlock) {
        self.phoneLinkTouchedBlock(self, phoneNumber);
    } else {
        NSString *deviceType = [UIDevice currentDevice].model;
        if ([deviceType isEqualToString:@"iPhone"]) {
            NSURL *url = [NSURL URLWithString:[@"tel://" stringByAppendingString:phoneNumber]];
            [[UIApplication sharedApplication] openURL:url];
        } else {
            [SMRUtils toast:@"该设备不能拨打电话"];
        }
    }
}

- (void)alertTextCell:(SMRAlertViewContentTextCell *)cell didSelectLinkWithURL:(NSURL *)url {
    if (self.linkTouchedBlock) {
        self.linkTouchedBlock(self, url);
    } else {
        [SMRUtils jumpToAnyURL:url.absoluteString
                  webParameter:nil
                    forceToApp:YES
                   presentOnly:YES];
    }
}

#pragma mark - Style

- (CGFloat)maxLayoutOfLabelWidth {
    UIEdgeInsets insets = [self smr_insetsOfContent];
    CGFloat maxLayoutWidth = [self widthOfContentView] - 2*[self smr_marginOfTableView] - insets.left - insets.right;
    return maxLayoutWidth;
}

- (CGFloat)maxLayoutOfTextFieldWidth {
    UIEdgeInsets insets = [self smr_insetsOfContent];
    CGFloat maxLayoutWidth = [self widthOfContentView] - 2*[self smr_marginOfTableView] - insets.left - insets.right;
    return maxLayoutWidth;
}

#pragma mark - SMRCustomBottomButtonProtocol

- (void)sureBtnAction:(UIButton *)sender {
    [self endEditing:YES];
    [super sureBtnAction:sender];
}

- (void)cancelBtnAction:(UIButton *)sender {
    [self endEditing:YES];
    [super cancelBtnAction:sender];
}

#pragma mark - Utils

- (BOOL)p_shouldShowImage {
    return !CGSizeEqualToSize(self.imageSize, CGSizeZero)
            && (self.imageURL.length || self.image);
}

#pragma mark - Setters

- (void)setTitle:(NSString * _Nonnull)title {
    _title = title;
    [self smr_setNeedsReloadView];
}

- (void)setContent:(NSString * _Nonnull)content {
    _content = content;
    _attributeContent = content ? [[NSAttributedString alloc] initWithString:content] : nil;
    [self smr_setNeedsReloadView];
}

- (void)setAttributeContent:(NSAttributedString * _Nonnull)attributeContent {
    _content = attributeContent.string;
    _attributeContent = attributeContent;
    [self smr_setNeedsReloadView];
}

- (void)setEnabledTextCheckingTypes:(NSTextCheckingTypes)enabledTextCheckingTypes {
    _enabledTextCheckingTypes = enabledTextCheckingTypes;
    [self smr_setNeedsReloadView];
}

- (void)setLinkAttributes:(NSDictionary *)linkAttributes {
    _linkAttributes = linkAttributes;
    [self smr_setNeedsReloadView];
}

- (void)setTitleColor:(UIColor *)titleColor {
    _titleColor = titleColor;
    [self smr_setNeedsReloadView];
}

- (void)setContentTextAlignment:(NSTextAlignment)contentTextAlignment {
    _contentTextAlignment = contentTextAlignment;
    [self smr_setNeedsReloadView];
}

- (void)setImage:(UIImage *)image {
    _image = image;
    [self smr_setNeedsReloadView];
}

- (void)setImageURL:(NSString *)imageURL {
    _imageURL = imageURL;
    [self smr_setNeedsReloadView];
}

- (void)setImageSize:(CGSize)imageSize {
    _imageSize = imageSize;
    [self smr_setNeedsReloadView];
}

- (void)setImageSpace:(CGFloat)imageSpace {
    _imageSpace = imageSpace;
    [self smr_setNeedsReloadView];
}

- (void)setUseTextField:(BOOL)useTextField {
    _useTextField = useTextField;
    [self smr_setNeedsReloadView];
}

- (void)setTextField:(UITextField *)textField {
    if (_textField != textField) {
        [_textField removeFromSuperview];
    }
    _textField = textField;
    [self smr_setNeedsReloadView];
}

#pragma mark - Getters

- (NSMutableDictionary<NSString *,NSURL *> *)linkSymbols {
    if (!_linkSymbols) {
        _linkSymbols = [NSMutableDictionary dictionary];
    }
    return _linkSymbols;
}

- (UITextField *)textField {
    if (!_textField) {
        _textField = [[UITextField alloc] init];
        _textField.font = [UIFont smr_systemFontOfSize:16];
        _textField.textColor = [UIColor smr_generalBlackColor];
        _textField.clearButtonMode = UITextFieldViewModeAlways;
    }
    return _textField;
}

@end
