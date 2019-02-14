//
//  SMRAlertView.m
//  SMRBaseCoreDemo
//
//  Created by 丁治文 on 2019/2/13.
//  Copyright © 2019 sumrise. All rights reserved.
//

#import "SMRAlertView.h"
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

@end

@implementation SMRAlertView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self.tableView registerClass:[SMRAlertViewContentTextCell class] forCellReuseIdentifier:identifierOfAlertViewContentTextCell];
        self.tableView.sectionsDelegate = self;
        [self.tableView smr_markCustomTableViewSeparators];
    }
    return self;
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

#pragma mark - SMRTableAlertViewProtocol

- (UIEdgeInsets)smr_insetsOfContent {
    return [SMRUIAdapter smr_adapterWithInsets:UIEdgeInsetsMake(56, 20, 0, 20)];
}

- (CGFloat)smr_heightOfTitleBar {
    // 有标题时
    return 0.0;
}

- (UIView *)smr_titleBarOfTableAlertView {
    return nil;
}

- (CGFloat)smr_heightOfBottomBar {
    // 有按钮时
    if (self.buttonTitles.count) {
        return [SMRUIAdapter smr_adapterWithValue:40.0 + 2*26.0];
    }
    return 0;
}

- (UIView *)smr_bottomBarOfTableAlertView {
    // 有按钮时
    if (self.buttonTitles.count) {
        NSArray<UIButton *> *buttons = nil;
        if (self.buttonTitles.count == 1) {
            // 1个按钮时,sure
            UIButton *sureBtn = [SMRAlertViewButton buttonWithTitle:self.buttonTitles[0]
                                                             target:self
                                                             action:@selector(sureBtnAction:)
                                                          deepColor:(self.deepColorType&SMRAlertViewButtonDeepColorTypeSure)];
            buttons = @[sureBtn];
        } else if (self.buttonTitles.count == 2) {
            // 2个按钮时,cancel+sure
            UIButton *cancelBtn = [SMRAlertViewButton buttonWithTitle:self.buttonTitles[0]
                                                               target:self
                                                               action:@selector(cancelBtnAction:)
                                                            deepColor:(self.deepColorType&SMRAlertViewButtonDeepColorTypeCancel)];
            UIButton *sureBtn = [SMRAlertViewButton buttonWithTitle:self.buttonTitles[1]
                                                             target:self
                                                             action:@selector(sureBtnAction:)
                                                          deepColor:(self.deepColorType&SMRAlertViewButtonDeepColorTypeSure)];
            buttons = @[cancelBtn, sureBtn];
        }
        
        SMRAlertViewButton *btn = [[SMRAlertViewButton alloc] initWithButtons:buttons space:[SMRUIAdapter smr_adapterWithValue:20.0]];
        return btn;
    }
    return nil;
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
                return [SMRUIAdapter smr_adapterWithValue:100.0];
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

- (void)setContent:(NSString * _Nonnull)content {
    _content = content;
}

- (void)setDeepColorType:(SMRAlertViewButtonDeepColorType)deepColorType {
    _deepColorType = deepColorType;
}

@end
