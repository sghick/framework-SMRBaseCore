//
//  SMRAlertView.m
//  SMRBaseCoreDemo
//
//  Created by 丁治文 on 2019/2/13.
//  Copyright © 2019 sumrise. All rights reserved.
//

#import "SMRAlertView.h"
#import "SMRBaseCoreConfig.h"
#import "PureLayout.h"
#import "SMRAdapter.h"
#import "UITableView+Separator.h"
#import "UITableView+SMRSections.h"
#import "SMRAlertViewContentTextCell.h"
#import "SMRAlertViewImageCell.h"
#import "SMRAlertViewButton.h"

typedef NS_ENUM(NSInteger, kSectionType) {
    kSectionTypeContent,    ///< 内容
};

typedef NS_ENUM(NSInteger, kRowType) {
    kRowTypeContentText,    ///< 文本内容
    kRowTypeContentImage,   ///< 图片内容
};

static NSString * const identifierOfAlertViewContentTextCell = @"identifierOfAlertViewContentTextCell";
static NSString * const identifierOfAlertViewImageCell = @"identifierOfAlertViewImageCell";

@interface SMRAlertView ()<
UITableViewSectionsDelegate,
SMRAlertViewContentTextCellDelegate>

@property (assign, nonatomic) SMRAlertViewStyle alertViewStyle;
@property (strong, nonatomic) NSMutableDictionary<NSString *,NSURL *> *linkSymbols;

@property (copy  , nonatomic) NSString *imageURL;
@property (strong, nonatomic) UIImage *image;
@property (assign, nonatomic) CGSize imageSize;
@property (assign, nonatomic) CGFloat imageSpace;

@end

@implementation SMRAlertView

- (instancetype)initWithFrame:(CGRect)frame contentAlignment:(SMRContentMaskViewContentAlignment)contentAlignment {
    self = [super initWithFrame:frame contentAlignment:contentAlignment];
    if (self) {
        // 使用config配置的样式
        _alertViewStyle = [SMRBaseCoreConfig sharedInstance].alertViewStyle;
        _contentTextAlignment = NSTextAlignmentCenter;
        
        [self.tableView registerClass:[SMRAlertViewContentTextCell class] forCellReuseIdentifier:identifierOfAlertViewContentTextCell];
        [self.tableView registerClass:[SMRAlertViewImageCell class] forCellReuseIdentifier:identifierOfAlertViewImageCell];
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
    [self smr_reloadData];
}

- (void)addImageURL:(NSString *)imageURL size:(CGSize)size space:(CGFloat)space {
    _imageURL = imageURL;
    _imageSize = size;
    _imageSpace = space;
    [self smr_reloadData];
}

+ (instancetype)alertViewWithContent:(NSString *)content
                        buttonTitles:(NSArray<NSString *> *)buttonTitles
                       deepColorType:(SMRAlertViewButtonDeepColorType)deepColorType {
    SMRAlertView *alertView = [[self alloc] init];
    alertView.content = content;
    alertView.attributeContent = [[NSAttributedString alloc] initWithString:content];
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
    alertView.attributeContent = [[NSAttributedString alloc] initWithString:content];
    alertView.buttonTitles = buttonTitles;
    alertView.deepColorType = deepColorType;
    [alertView smr_reloadData];
    return alertView;
}

+ (instancetype)alertViewWithAttributeContent:(NSAttributedString *)attributeContent
                                 buttonTitles:(NSArray<NSString *> *)buttonTitles
                                deepColorType:(SMRAlertViewButtonDeepColorType)deepColorType {
    SMRAlertView *alertView = [[self alloc] init];
    alertView.attributeContent = attributeContent;
    alertView.content = attributeContent.string;
    alertView.buttonTitles = buttonTitles;
    alertView.deepColorType = deepColorType;
    [alertView smr_reloadData];
    return alertView;
}

+ (instancetype)alertViewWithTitle:(NSString *)title
                  attributeContent:(NSAttributedString *)attributeContent
                      buttonTitles:(NSArray<NSString *> *)buttonTitles
                     deepColorType:(SMRAlertViewButtonDeepColorType)deepColorType {
    SMRAlertView *alertView = [[self alloc] init];
    alertView.title = title;
    alertView.attributeContent = attributeContent;
    alertView.content = attributeContent.string;
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
    if ([self p_shouldShowImage]) {
        [sections addSectionKey:kSectionTypeContent rowKey:kRowTypeContentImage];
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
            // 1个按钮时,sure]
            if (!self.reversCancleAndSureButtonPostion) {
                UIButton *sureBtn = [self buttonForStyle:self.alertViewStyle
                                                   title:self.buttonTitles[0]
                                                  target:self
                                                  action:@selector(sureBtnAction:)
                                               deepColor:YES];
                buttons = @[sureBtn];
            } else {
                UIButton *cancelBtn = [self buttonForStyle:self.alertViewStyle
                                                     title:self.buttonTitles[0]
                                                    target:self
                                                    action:@selector(cancelBtnAction:)
                                                 deepColor:YES];
                
                buttons = @[cancelBtn];
            }
        } else if (self.buttonTitles.count == 2) {
            // 2个按钮时,cancel+sure
            UIButton *cancelBtn = [self buttonForStyle:self.alertViewStyle
                                                 title:self.buttonTitles[0]
                                                target:self
                                                action:@selector(cancelBtnAction:)
                                             deepColor:NO];
            UIButton *sureBtn = [self buttonForStyle:self.alertViewStyle
                                               title:self.buttonTitles[1]
                                              target:self
                                              action:@selector(sureBtnAction:)
                                           deepColor:YES];
            if (!self.reversCancleAndSureButtonPostion) {
                buttons = @[cancelBtn, sureBtn];
            } else {
                buttons = @[sureBtn, cancelBtn];
            }
        }
        
        CGFloat height = [self heightOfButtonForStyle:self.alertViewStyle];
        UIView *bottomView = [[UIView alloc] init];
        SMRAlertViewButton *btn = [[SMRAlertViewButton alloc] initWithButtons:buttons height:height space:0];
        [bottomView addSubview:btn];
        [btn autoPinEdgeToSuperviewEdge:ALEdgeLeft];
        [btn autoPinEdgeToSuperviewEdge:ALEdgeRight];
        [btn autoPinEdgeToSuperviewEdge:ALEdgeBottom];
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
    NSIndexPath *indexPathForContentText = [tableView.sections indexPathWithSectionKey:kSectionTypeContent rowKey:kRowTypeContentText];
    CGFloat heightOfContentText = indexPathForContentText ? [self smr_tableView:tableView heightForRowAtIndexPath:indexPathForContentText] : 0;
    
    NSIndexPath *indexPathForContentImage = [tableView.sections indexPathWithSectionKey:kSectionTypeContent rowKey:kRowTypeContentImage];
    CGFloat heightOfContentImage = indexPathForContentImage ? [self smr_tableView:tableView heightForRowAtIndexPath:indexPathForContentImage] : 0;
    
    heightOfTableView = heightOfContentText + heightOfContentImage;
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
                return height + 2;
            }
            return 0;
        }
            break;
        case kRowTypeContentImage: {
            return self.imageSize.height + self.imageSpace;
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
            if (self.image) {
                cell.image = self.image;
            }
            if (self.imageURL.length) {
                cell.imageURL = self.imageURL;
            }
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

- (CGFloat)heightOfButtonForStyle:(SMRAlertViewStyle)style {
    return [SMRAlertViewButton generalHeightOfButton];
}

- (UIButton *)buttonForStyle:(SMRAlertViewStyle)style title:(NSString *)title target:(id)target action:(SEL)action deepColor:(BOOL)deepColor {
    // 非深色按钮为取消样式
    if (!deepColor) {
        return [SMRAlertViewButton buttonTitle:title target:target action:action style:style function:SMRAlertViewButtonFunctionCancel];
    }
    SMRAlertViewButtonDeepColorType deepColorType = self.deepColorType;
    switch (deepColorType) {
        case SMRAlertViewButtonDeepColorTypeCancel:
            return [SMRAlertViewButton buttonTitle:title target:target action:action style:style function:SMRAlertViewButtonFunctionCancel];
            break;
        
        case SMRAlertViewButtonDeepColorTypeSure:
            return [SMRAlertViewButton buttonTitle:title target:target action:action style:style function:SMRAlertViewButtonFunctionSure];
            break;
        
        case SMRAlertViewButtonDeepColorTypeDelete:
            return [SMRAlertViewButton buttonTitle:title target:target action:action style:style function:SMRAlertViewButtonFunctionDelete];
            break;
        default:
            return [SMRAlertViewButton buttonTitle:title target:target action:action style:style function:SMRAlertViewButtonFunctionCancel];
            break;
    }
    return nil;
}

- (CGFloat)maxLayoutOfLabelWidth {
    UIEdgeInsets insets = [self smr_insetsOfContent];
    CGFloat maxLayoutWidth = [self widthOfContentView] - 2*[self smr_marginOfTableView] - insets.left - insets.right;
    return maxLayoutWidth;
}

#pragma mark - Utils

- (BOOL)p_shouldShowImage {
    return !CGSizeEqualToSize(self.imageSize, CGSizeZero)
            && (self.imageURL.length || self.image);
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

- (void)setAttributeContent:(NSAttributedString * _Nonnull)attributeContent {
    _attributeContent = attributeContent;
}

- (void)setDeepColorType:(SMRAlertViewButtonDeepColorType)deepColorType {
    _deepColorType = deepColorType;
}

- (void)setContentTextAlignment:(NSTextAlignment)contentTextAlignment {
    _contentTextAlignment = contentTextAlignment;
    [self.tableView smr_reloadData];
}

#pragma mark - Getters

- (NSMutableDictionary<NSString *,NSURL *> *)linkSymbols {
    if (!_linkSymbols) {
        _linkSymbols = [NSMutableDictionary dictionary];
    }
    return _linkSymbols;
}

@end
