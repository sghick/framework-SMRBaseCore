//
//  SMRSections.m
//  SMRBaseCoreDemo
//
//  Created by 丁治文 on 2018/12/24.
//  Copyright © 2018 sumrise. All rights reserved.
//

#import "SMRSections.h"

@interface SMRSections ()

@property (nonatomic, strong) NSMutableDictionary<NSNumber *, SMRSection *> *sectionsDict;

@end

@implementation SMRSections

- (instancetype)init {
    self = [super init];
    if (self) {
        _sections = [NSMutableArray array];
    }
    return self;
}

- (SMRRow *)rowWithIndexPath:(NSIndexPath *)indexPath {
    if (!indexPath) {
        return nil;
    }
    SMRSection *sec = [self sectionWithIndexPathSection:indexPath.section];
    if (sec) {
        SMRRow *row = [sec rowAtIndexPathRow:indexPath.row];
        if (row == nil) {
            row = [[SMRRow alloc] init];
            row.sectionKey = sec.sectionKey;
            row.rowKey = -1;
        }
        return row;
    }
    return nil;
}

- (SMRSection *)sectionWithIndexPathSection:(NSInteger)section {
    NSInteger sumSection = 0;
    for (SMRSection *sec in self.sections) {
        sumSection += sec.sectionSamesCount;
        if (sumSection > section) {
            sec.sectionSamesIndex = section - (sumSection - sec.sectionSamesCount);
            return sec;
        }
    }
    return nil;
}

- (SMRRow *)rowWithSectionKey:(NSInteger)sectionKey rowKey:(NSInteger)rowKey {
    SMRSection *sec = [self sectionWithSectionKey:sectionKey];
    return [sec rowWithRowKey:rowKey];
}

- (SMRSection *)sectionWithSectionKey:(NSInteger)sectionKey {
    return self.sectionsDict[@(sectionKey)];
}

- (NSIndexPath *)indexPathWithRowKey:(NSInteger)rowKey {
    return [self indexPathWithRowKey:rowKey rowSamesIndex:0];
}

- (NSIndexPath *)indexPathWithRowKey:(NSInteger)rowKey rowSamesIndex:(NSInteger)rowSamesIndex {
    for (int s = 0; s < self.sections.count; s++) {
        SMRSection *sec = self.sections[s];
        NSIndexPath *indexPath = [self indexPathWithSectionKey:sec.sectionKey rowKey:rowKey rowSamesIndex:rowSamesIndex];
        if (indexPath) {
            // 找到后立即返回
            return indexPath;
        }
        // 继续遍历
    }
    return nil;
}

- (NSIndexPath *)indexPathWithSectionKey:(NSInteger)sectionKey rowKey:(NSInteger)rowKey {
    return [self indexPathWithSectionKey:sectionKey rowKey:rowKey rowSamesIndex:0];
}

- (NSIndexPath *)indexPathWithSectionKey:(NSInteger)sectionKey rowKey:(NSInteger)rowKey rowSamesIndex:(NSInteger)rowSamesIndex {
    SMRSection *sec = [self sectionWithSectionKey:sectionKey];
    NSInteger s = [self indexPathSectionWithSectionKey:sectionKey];
    NSInteger r = [sec indexPathRowWithRowKey:rowKey rowSamesIndex:rowSamesIndex];
    if ((s != -1) && (r != -1)) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:r inSection:s];
        return indexPath;
    }
    return nil;
}

- (NSInteger)indexPathSectionWithSectionKey:(NSInteger)sectionKey {
    return [self indexPathSectionWithSectionKey:sectionKey sectionSamesIndex:0];
}

- (NSInteger)indexPathSectionWithSectionKey:(NSInteger)sectionKey sectionSamesIndex:(NSInteger)sectionSamesIndex {
    NSInteger sumSection = 0;
    for (SMRSection *sec in self.sections) {
        if (sec.sectionKey == sectionKey) {
            return sumSection + sectionSamesIndex;
        }
        sumSection += sec.sectionSamesCount;
    }
    return -1;
}

- (void)addSection:(SMRSection *)section {
    [self.sections addObject:section];
    self.sectionsDict[@(section.sectionKey)] = section;
}

- (void)addSectionKey:(NSInteger)sectionKey rowKey:(NSInteger)rowKey {
    [self p_addSectionKey:sectionKey rowKey:rowKey sectionSamesCount:1 rowSamesCount:1];
}

- (void)addSectionKey:(NSInteger)sectionKey rowKey:(NSInteger)rowKey sectionSamesCount:(NSInteger)sectionSamesCount {
    [self p_addSectionKey:sectionKey rowKey:rowKey sectionSamesCount:sectionSamesCount rowSamesCount:1];
}

- (void)addSectionKey:(NSInteger)sectionKey rowKey:(NSInteger)rowKey rowSamesCount:(NSInteger)rowSamesCount {
    [self p_addSectionKey:sectionKey rowKey:rowKey sectionSamesCount:1 rowSamesCount:rowSamesCount];
}

- (void)addSectionKey:(NSInteger)sectionKey rowKey:(NSInteger)rowKey sectionSamesCount:(NSInteger)sectionSamesCount rowSamesCount:(NSInteger)rowSamesCount {
    [self p_addSectionKey:sectionKey rowKey:rowKey sectionSamesCount:sectionSamesCount rowSamesCount:rowSamesCount];
}

// private
- (void)p_addSectionKey:(NSInteger)sectionKey rowKey:(NSInteger)rowKey sectionSamesCount:(NSInteger)sectionSamesCount rowSamesCount:(NSInteger)rowSamesCount {
    if (sectionSamesCount == 0) {
        return;
    }
    if (rowSamesCount == 0) {
        return;
    }
    SMRSection *sec = [self sectionWithSectionKey:sectionKey];
    if (sec) {
        [sec addRowKey:rowKey sectionSamesCount:sectionSamesCount rowSamesCount:rowSamesCount];
    } else {
        sec = [[SMRSection alloc] initWithSectionKey:sectionKey];
        [sec addRowKey:rowKey sectionSamesCount:sectionSamesCount rowSamesCount:rowSamesCount];
        [self.sections addObject:sec];
        self.sectionsDict[@(sectionKey)] = sec;
    }
}

- (NSInteger)sectionSamesCountOfAll {
    NSInteger sectionCount = 0;
    for (SMRSection *sec in self.sections) {
        sectionCount += sec.sectionSamesCount;
    }
    return sectionCount;
}

- (NSMutableDictionary<NSNumber *,SMRSection *> *)sectionsDict {
    if (!_sectionsDict) {
        _sectionsDict = [NSMutableDictionary dictionary];
    }
    return _sectionsDict;
}

@end

@interface SMRSection ()

@property (nonatomic, strong) NSMutableDictionary<NSNumber *, SMRRow *> *rowsDict;

@end

@implementation SMRSection

- (instancetype)initWithSectionKey:(NSInteger)sectionKey {
    self = [super init];
    if (self) {
        _sectionKey = sectionKey;
        _rows = [NSMutableArray array];
    }
    return self;
}

- (void)addRowKey:(NSInteger)rowKey sectionSamesCount:(NSInteger)sectionSamesCount rowSamesCount:(NSInteger)rowSamesCount {
    self.sectionSamesCount = sectionSamesCount;
    SMRRow *row = [[SMRRow alloc] init];
    row.rowSamesCount = rowSamesCount;
    row.sectionKey = self.sectionKey;
    row.rowKey = rowKey;
    [self.rows addObject:row];
    self.rowsDict[@(rowKey)] = row;
}

- (SMRRow *)rowAtIndexPathRow:(NSInteger)row {
    NSInteger index = 0;
    NSInteger sumRow = 0;
    for (SMRRow *rw in self.rows) {
        sumRow += rw.rowSamesCount;
        if (sumRow > row) {
            rw.rowSamesIndex = row - (sumRow - rw.rowSamesCount);
            return rw;
        }
        index++;
    }
    return nil;
}

- (SMRRow *)rowWithRowKey:(NSInteger)rowKey {
    return self.rowsDict[@(rowKey)];
}

- (NSInteger)indexPathRowWithRowKey:(NSInteger)rowKey {
    return [self indexPathRowWithRowKey:rowKey rowSamesIndex:0];
}

- (NSInteger)indexPathRowWithRowKey:(NSInteger)rowKey rowSamesIndex:(NSInteger)rowSamesIndex {
    NSInteger sumRow = 0;
    for (SMRRow *row in self.rows) {
        if (row.rowKey == rowKey) {
            return sumRow + rowSamesIndex;
        }
        sumRow += row.rowSamesCount;
    }
    return -1;
}

- (NSInteger)rowSamesCountOfAll {
    NSInteger rowCount = 0;
    for (SMRRow *row in self.rows) {
        rowCount += row.rowSamesCount;
    }
    return rowCount;
}

- (NSString *)identifier {
    return [NSString stringWithFormat:@"sk%@si%@", @(self.sectionKey), @(self.sectionSamesIndex)];
}

- (NSMutableDictionary<NSNumber *,SMRRow *> *)rowsDict {
    if (!_rowsDict) {
        _rowsDict = [NSMutableDictionary dictionary];
    }
    return _rowsDict;
}

@end

@implementation SMRRow

- (NSString *)identifier {
    return [NSString stringWithFormat:@"sk%@rk%@ri%@", @(self.sectionKey), @(self.rowKey), @(self.rowSamesIndex)];
}

@end
