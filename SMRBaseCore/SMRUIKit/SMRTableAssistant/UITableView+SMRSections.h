//
//  UITableView+SMRSections.h
//  SMRTableAssistantDemo
//
//  Created by 丁治文 on 2018/11/10.
//  Copyright © 2018年 sumrise.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMRSections.h"

@class UITableView;
@protocol UITableViewSectionsDelegate <NSObject>

/**
 获取数据控制源
 */
- (SMRSections *)sectionsInTableView:(UITableView *)tableView;

@end

@interface UITableView (SMRSections)

/**
 数据控制源
 */
@property (strong, nonatomic, readonly) SMRSections *sections;

/**
 数据控制源的代理
 */
@property (weak  , nonatomic) id<UITableViewSectionsDelegate> sectionsDelegate;

/**
 刷新数据控制源
 */
- (void)smr_reloadSections;

/// 以下方法为调用原生相应方法前,会主动刷新数据控制源
- (void)smr_reloadData;
- (void)smr_reloadSectionIndexTitles;

- (void)smr_insertSections:(NSIndexSet *)sections withRowAnimation:(UITableViewRowAnimation)animation;
- (void)smr_deleteSections:(NSIndexSet *)sections withRowAnimation:(UITableViewRowAnimation)animation;
- (void)smr_reloadSections:(NSIndexSet *)sections withRowAnimation:(UITableViewRowAnimation)animation NS_AVAILABLE_IOS(3_0);
- (void)smr_moveSection:(NSInteger)section toSection:(NSInteger)newSection NS_AVAILABLE_IOS(5_0);

- (void)smr_insertRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation;
- (void)smr_deleteRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation;
- (void)smr_reloadRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation NS_AVAILABLE_IOS(3_0);
- (void)smr_moveRowAtIndexPath:(NSIndexPath *)indexPath toIndexPath:(NSIndexPath *)newIndexPath NS_AVAILABLE_IOS(5_0);

/// 获取数据控制源粒子
- (SMRSection *)sectionWithIndexPathSection:(NSInteger)indexPathSection;
- (SMRRow *)rowWithIndexPath:(NSIndexPath *)indexPath;

@end
