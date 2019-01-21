//
//  SMRSections.m
//  SMRTableAssistantDemo
//
//  Created by 丁治文 on 2018/11/5.
//  Copyright © 2018年 sumrise.com. All rights reserved.
//

#import "SMRSections.h"

@implementation SMRSections

- (instancetype)init {
    self = [super init];
    if (self) {
        _sections = [NSMutableArray array];
    }
    return self;
}

- (SMRRow *)rowWithIndexPath:(NSIndexPath *)indexPath {
    SMRSection *sec = [self sectionWithIndexPathSection:indexPath.section];
    if (sec) {
        SMRRow *row = [sec rowAtIndexPathRow:indexPath.row];
        if (row == nil) {
            row = [[SMRRow alloc] init];
            row.sectionKey = sec.sectionKey;
            row.rowKey = -99999;
        }
        return row;
    }
    return nil;
}

- (SMRSection *)sectionWithIndexPathSection:(NSInteger)section {
    NSInteger index = [self indexOfSectionsWithIndexPathSection:section];
    if (self.sections.count > index) {
        SMRSection *sec = self.sections[index];
        sec.sectionSamesIndex = [self sectionSamesIndexWithIndexPathSection:section];
        return sec;
    }
    return nil;
}

// private
- (NSInteger)indexOfSectionsWithIndexPathSection:(NSInteger)section {
    NSInteger index = 0;
    NSInteger sumSection = 0;
    for (SMRSection *sec in self.sections) {
        sumSection += sec.sectionSamesCount;
        if (sumSection > section) {
            return index;
        }
        index++;
    }
    return -99999;
}

// private
- (NSInteger)sectionSamesIndexWithIndexPathSection:(NSInteger)section {
    NSInteger sectionSamesIndex = 0;
    NSInteger sumSection = 0;
    for (SMRSection *sec in self.sections) {
        sumSection += sec.sectionSamesCount;
        if (sumSection > section) {
            sectionSamesIndex = section - (sumSection - sec.sectionSamesCount);
            return sectionSamesIndex;
        }
    }
    return -99999;
}

- (NSIndexPath *)indexPathWithRowKey:(NSInteger)rowKey {
    for (int s = 0; s < self.sections.count; s++) {
        SMRSection *sec = self.sections[s];
        for (int r = 0; r < sec.rows.count; r++) {
            SMRRow *row = sec.rows[r];
            if (row.rowKey == rowKey) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:r inSection:s];
                return indexPath;
            }
        }
    }
    return nil;
}

- (NSIndexPath *)indexPathWithSectionKey:(NSInteger)sectionKey rowKey:(NSInteger)rowKey {
    for (int s = 0; s < self.sections.count; s++) {
        SMRSection *sec = self.sections[s];
        for (int r = 0; r < sec.rows.count; r++) {
            SMRRow *row = sec.rows[r];
            if ((row.sectionKey == sectionKey) && (row.rowKey == rowKey)) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:r inSection:s];
                return indexPath;
            }
        }
    }
    return nil;
}

- (NSInteger)indexPathSectionWithSectionKey:(NSInteger)sectionKey {
    for (int s = 0; s < self.sections.count; s++) {
        SMRSection *sec = self.sections[s];
        if (sec.sectionKey == sectionKey) {
            return s;
        }
    }
    return -1;
}

- (void)addSection:(SMRSection *)section {
    [self.sections addObject:section];
}

- (void)addSectionKey:(NSInteger)sectionKey rowKey:(NSInteger)rowKey {
    [self addSectionKey:sectionKey rowKey:rowKey sectionSamesCount:1 rowSamesCount:1];
}

- (void)addSectionKey:(NSInteger)sectionKey rowKey:(NSInteger)rowKey sectionSamesCount:(NSInteger)sectionSamesCount {
    [self addSectionKey:sectionKey rowKey:rowKey sectionSamesCount:sectionSamesCount rowSamesCount:1];
}

- (void)addSectionKey:(NSInteger)sectionKey rowKey:(NSInteger)rowKey rowSamesCount:(NSInteger)rowSamesCount {
    [self addSectionKey:sectionKey rowKey:rowKey sectionSamesCount:1 rowSamesCount:rowSamesCount];
}

// private
- (void)addSectionKey:(NSInteger)sectionKey rowKey:(NSInteger)rowKey sectionSamesCount:(NSInteger)sectionSamesCount rowSamesCount:(NSInteger)rowSamesCount {
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
        [self addSection:sec];
    }
}

- (SMRSection *)sectionWithSectionKey:(NSInteger)sectionKey {
    for (SMRSection *sec in self.sections) {
        if (sec.sectionKey == sectionKey) {
            return sec;
        }
    }
    return nil;
}

- (NSInteger)sectionSamesCountOfAll {
    NSInteger sectionCount = 0;
    for (SMRSection *sec in self.sections) {
        sectionCount += sec.sectionSamesCount;
    }
    return sectionCount;
}

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
}

- (SMRRow *)rowAtIndexPathRow:(NSInteger)row {
    NSInteger index = [self indexOfRowsAtIndexPathRow:row];
    if (self.rows.count > index) {
        SMRRow *rw = self.rows[index];
        rw.rowSamesIndex = [self rowSamesIndexAtIndexPathRow:row];
        return rw;
    }
    return nil;
}

// private
- (NSInteger)indexOfRowsAtIndexPathRow:(NSInteger)row {
    NSInteger index = 0;
    NSInteger sumRow = 0;
    for (SMRRow *rw in self.rows) {
        sumRow += rw.rowSamesCount;
        if (sumRow > row) {
            return index;
        }
        index++;
    }
    return -99999;
}

// private
- (NSInteger)rowSamesIndexAtIndexPathRow:(NSInteger)row {
    NSInteger rowSamesIndex = 0;
    NSInteger sumRow = 0;
    for (SMRRow *rw in self.rows) {
        sumRow += rw.rowSamesCount;
        if (sumRow > row) {
            rowSamesIndex = row - (sumRow - rw.rowSamesCount);
            return rowSamesIndex;
        }
    }
    return -99999;
}

- (NSInteger)rowKeyAtIndexPathRow:(NSInteger)row {
    if (self.rows.count > row) {
        return self.rows[row].rowKey;
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

@end

@implementation SMRRow

@end
