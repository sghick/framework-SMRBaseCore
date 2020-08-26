//
//  UITableView+SMRSections.m
//  SMRBaseCoreDemo
//
//  Created by 丁治文 on 2018/12/24.
//  Copyright © 2018 sumrise. All rights reserved.
//

#import "UITableView+SMRSections.h"
#import <objc/runtime.h>

@implementation UITableView (SMRSections)

#pragma mark - Getters/Setters
// sections
static const char SMRSectionsPropertyKey = '\0';
- (void)setSections:(SMRSections *)sections {
    if (sections != self.sections) {
        objc_setAssociatedObject(self, &SMRSectionsPropertyKey, sections, OBJC_ASSOCIATION_RETAIN);
    }
}

- (SMRSections *)sections {
    SMRSections *sections = objc_getAssociatedObject(self, &SMRSectionsPropertyKey);
    return sections;
}

// dataDelegate
static const char SMRSectionsDelegateDelegatePropertyKey = '\0';
- (void)setSectionsDelegate:(id<UITableViewSectionsDelegate>)sectionsDelegate {
    if (sectionsDelegate != self.sectionsDelegate) {
        objc_setAssociatedObject(self, &SMRSectionsDelegateDelegatePropertyKey, sectionsDelegate, OBJC_ASSOCIATION_ASSIGN);
    }
}

- (id<UITableViewSectionsDelegate>)sectionsDelegate {
    id<UITableViewSectionsDelegate> delegate = objc_getAssociatedObject(self, &SMRSectionsDelegateDelegatePropertyKey);
    return delegate;
}

// unfoldStatus
static const char SMRUnfoldStatusPropertyKey = '\0';
- (void)setUnfoldStatus:(NSMutableDictionary *)unfoldStatus {
    if (unfoldStatus != self.unfoldStatus) {
        objc_setAssociatedObject(self, &SMRUnfoldStatusPropertyKey, unfoldStatus, OBJC_ASSOCIATION_RETAIN);
    }
}

- (NSMutableDictionary *)unfoldStatus {
    NSMutableDictionary *unfoldStatus = objc_getAssociatedObject(self, &SMRUnfoldStatusPropertyKey);
    return unfoldStatus;
}

#pragma mark - Overide

- (void)smr_reloadSections {
    if ([self.sectionsDelegate respondsToSelector:@selector(sectionsInTableView:)]) {
        self.sections = [self.sectionsDelegate sectionsInTableView:self];
    }
}

- (void)smr_reloadData {
    [self smr_reloadSections];
    [self reloadData];
}
- (void)smr_reloadSectionIndexTitles {
    [self smr_reloadSections];
    [self reloadSectionIndexTitles];
}

- (void)smr_insertSections:(NSIndexSet *)sections withRowAnimation:(UITableViewRowAnimation)animation {
    [self smr_reloadSections];
    [self insertSections:sections withRowAnimation:animation];
}
- (void)smr_deleteSections:(NSIndexSet *)sections withRowAnimation:(UITableViewRowAnimation)animation {
    [self smr_reloadSections];
    [self deleteSections:sections withRowAnimation:animation];
}
- (void)smr_reloadSections:(NSIndexSet *)sections withRowAnimation:(UITableViewRowAnimation)animation {
    [self smr_reloadSections];
    [self reloadSections:sections withRowAnimation:animation];
}
- (void)smr_moveSection:(NSInteger)section toSection:(NSInteger)newSection {
    [self smr_reloadSections];
    [self moveSection:section toSection:newSection];
}

- (void)smr_insertRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation {
    [self smr_reloadSections];
    [self insertRowsAtIndexPaths:indexPaths withRowAnimation:animation];
}
- (void)smr_deleteRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation {
    [self smr_reloadSections];
    [self deleteRowsAtIndexPaths:indexPaths withRowAnimation:animation];
}
- (void)smr_reloadRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation {
    [self smr_reloadSections];
    [self reloadRowsAtIndexPaths:indexPaths withRowAnimation:animation];
}
- (void)smr_moveRowAtIndexPath:(NSIndexPath *)indexPath toIndexPath:(NSIndexPath *)newIndexPath {
    [self smr_reloadSections];
    [self moveRowAtIndexPath:indexPath toIndexPath:newIndexPath];
}

- (void)smr_scrollToTopWithAnimated:(BOOL)animated {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self smr_scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:animated];
}

- (void)smr_scrollToBottomWithAnimated:(BOOL)animated {
    NSInteger lastSection = self.numberOfSections - 1;
    NSInteger lastRow = [self numberOfRowsInSection:lastSection] - 1;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:lastRow inSection:lastSection];
    [self smr_scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:animated];
}

- (void)smr_scrollToRowAtSectionKey:(NSInteger)sectionKey rowKey:(NSInteger)rowKey scrollPosition:(UITableViewScrollPosition)scrollPosition animated:(BOOL)animated {
    NSIndexPath *indexPath = [self.sections indexPathWithSectionKey:sectionKey rowKey:rowKey];
    [self smr_scrollToRowAtIndexPath:indexPath atScrollPosition:scrollPosition animated:animated];
}

- (void)smr_scrollToRowAtIndexPath:(NSIndexPath *)indexPath atScrollPosition:(UITableViewScrollPosition)scrollPosition animated:(BOOL)animated {
    if (!indexPath) {
        return;
    }
    NSInteger lastSection = self.numberOfSections - 1;
    if ((indexPath.section < 0) || (indexPath.section > lastSection)) {
        return;
    }
    NSInteger lastRow = [self numberOfRowsInSection:lastSection] - 1;
    if ((indexPath.row < 0) || (indexPath.row > lastRow)) {
        return;
    }
    
    [self scrollToRowAtIndexPath:indexPath atScrollPosition:scrollPosition animated:animated];
}

#pragma mark - Utils

- (SMRSection *)sectionWithIndexPathSection:(NSInteger)indexPathSection {
    return [self.sections sectionWithIndexPathSection:indexPathSection];
}

- (SMRRow *)rowWithIndexPath:(NSIndexPath *)indexPath {
    return [self.sections rowWithIndexPath:indexPath];
}
- (SMRRow *)rowWithCell:(UITableViewCell *)cell {
    NSIndexPath *indexPath = [self indexPathForCell:cell];
    return [self.sections rowWithIndexPath:indexPath];
}

- (void)smr_setCellUnfoldStatus:(BOOL)unfold key:(NSString *)key {
    NSParameterAssert(key);
    if (!key) {
        return;
    }
    if (!self.unfoldStatus) {
        self.unfoldStatus = [NSMutableDictionary dictionary];
    }
    [self.unfoldStatus setObject:@(unfold) forKey:key];
}

- (BOOL)smr_unfoldStatusWithKey:(NSString *)key {
    NSParameterAssert(key);
    if (!key) {
        return NO;
    }
    return ((NSNumber *)[self.unfoldStatus objectForKey:key]).boolValue;
}

- (void)smr_removeAllUnfoldStatus {
    [self.unfoldStatus removeAllObjects];
    self.unfoldStatus = nil;
}

@end
