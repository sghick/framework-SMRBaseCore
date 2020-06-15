//
//  SMRSectionsTests.m
//  SMRBaseCoreDemo
//
//  Created by 丁治文 on 2019/8/19.
//  Copyright © 2019 sumrise. All rights reserved.
//

#import "SMRSectionsTests.h"
#import <SMRDebug/SMRDebuger.h>
#import "SMRCommon.h"

typedef NS_ENUM(NSInteger, kSectionType) {
    kSectionType1,
    kSectionType2,
    kSectionType3,
    kSectionType4,
    kSectionType5,
};

typedef NS_ENUM(NSInteger, kRowType) {
    kRowType11,
    kRowType12,
    kRowType21,
    kRowType31,
    kRowType41,
    kRowType51,
    kRowType52,
    kRowType53,
};

@implementation NSIndexPath (SMRTest)

- (BOOL)isEqualToIndexPath:(NSIndexPath *)indexPath {
    return (self.row == indexPath.row) && (self.section == indexPath.section);
}

@end

@interface SMRSectionsTests ()

@property (strong, nonatomic) SMRSections *sections;

@end

@implementation SMRSectionsTests

- (id)begin {
    [self setup];
    [SMRDebug setDebug:1];
    [SMRLogSys setBeginTime];
    SMRLog0(@"===begin===", @"");
    for (int i = 0; i < 1000000; i++) {
        [self testMethods001];
    }
    SMRLog0(@"===end001===", @"");
    for (int i = 0; i < 1000000; i++) {
        [self testMethods002];
    }
    SMRLog0(@"===end002===", @"");
    for (int i = 0; i < 1000000; i++) {
        [self testMethods003];
    }
    SMRLog0(@"===end003===", @"");
    for (int i = 0; i < 1000000; i++) {
        [self testMethods004];
    }
    SMRLog0(@"===end004===", @"");
    return self;
}

- (void)setup {
    self.sections = [self sectionsForTest];
}

/** 常规 */
- (SMRSections *)sectionsForTest {
    SMRSections *sections = [[SMRSections alloc] init];
    [sections addSectionKey:kSectionType1 rowKey:kRowType11];
    [sections addSectionKey:kSectionType1 rowKey:kRowType12];
    [sections addSectionKey:kSectionType2 rowKey:kRowType21];
    [sections addSectionKey:kSectionType3 rowKey:kRowType31 sectionSamesCount:3];
    [sections addSectionKey:kSectionType4 rowKey:kRowType41 rowSamesCount:4];
    [sections addSectionKey:kSectionType5 rowKey:kRowType51];
    [sections addSectionKey:kSectionType5 rowKey:kRowType52];
    [sections addSectionKey:kSectionType5 rowKey:kRowType53];
    
    NSAssert(sections.sectionSamesCountOfAll == 7, @"");
    NSAssert([sections sectionWithSectionKey:kSectionType1].rowSamesCountOfAll == 2, @"");
    NSAssert([sections sectionWithSectionKey:kSectionType2].rowSamesCountOfAll == 1, @"");
    NSAssert([sections sectionWithSectionKey:kSectionType3].rowSamesCountOfAll == 1, @"");
    NSAssert([sections sectionWithSectionKey:kSectionType4].rowSamesCountOfAll == 4, @"");
    NSAssert([sections sectionWithSectionKey:kSectionType5].rowSamesCountOfAll == 3, @"");
    return sections;
}

- (void)testMethods001 {
    NSIndexPath *indexPath11 = [NSIndexPath indexPathForRow:0 inSection:0];
    NSIndexPath *indexPath12 = [NSIndexPath indexPathForRow:1 inSection:0];
    NSIndexPath *indexPath21 = [NSIndexPath indexPathForRow:0 inSection:1];
    NSIndexPath *indexPath31 = [NSIndexPath indexPathForRow:0 inSection:2];
    NSIndexPath *indexPath41 = [NSIndexPath indexPathForRow:0 inSection:5];
    NSIndexPath *indexPath51 = [NSIndexPath indexPathForRow:0 inSection:6];
    NSIndexPath *indexPath52 = [NSIndexPath indexPathForRow:1 inSection:6];
    NSIndexPath *indexPath53 = [NSIndexPath indexPathForRow:2 inSection:6];
    
    NSIndexPath *indexPath54 = [NSIndexPath indexPathForRow:3 inSection:6];
    NSIndexPath *indexPath61 = [NSIndexPath indexPathForRow:0 inSection:7];
    NSIndexPath *indexPath62 = [NSIndexPath indexPathForRow:1 inSection:7];
    
    SMRSections *sections = self.sections;
    // 有
    NSArray *indexPaths = @[indexPath11, indexPath12,
                            indexPath21,
                            indexPath31,
                            indexPath41,
                            indexPath51, indexPath52, indexPath53];
    for (NSIndexPath *indexPath in indexPaths) {
        SMRRow *row = [sections rowWithIndexPath:indexPath];
        NSAssert(row, @"");
        SMRSection *sec = [sections sectionWithIndexPathSection:indexPath.section];
        NSAssert(sec, @"");
    }
    // 有section 无row
    SMRRow *row54 = [sections rowWithIndexPath:indexPath54];
    NSAssert(row54 && (row54.rowKey == -1), @"");
    // 无
    NSArray *indexPathsHasNo = @[indexPath61, indexPath62];
    for (NSIndexPath *indexPath in indexPathsHasNo) {
        SMRRow *row = [sections rowWithIndexPath:indexPath];
        NSAssert(!row, @"");
        SMRSection *sec = [sections sectionWithIndexPathSection:indexPath.section];
        NSAssert(!sec, @"");
    }
}

- (void)testMethods002 {
    SMRSections *sections = self.sections;
    SMRRow *row11 = [sections rowWithSectionKey:kSectionType1 rowKey:kRowType11];
    SMRRow *row12 = [sections rowWithSectionKey:kSectionType1 rowKey:kRowType12];
    SMRRow *row21 = [sections rowWithSectionKey:kSectionType2 rowKey:kRowType21];
    SMRRow *row31 = [sections rowWithSectionKey:kSectionType3 rowKey:kRowType31];
    SMRRow *row41 = [sections rowWithSectionKey:kSectionType4 rowKey:kRowType41];
    SMRRow *row51 = [sections rowWithSectionKey:kSectionType5 rowKey:kRowType51];
    SMRRow *row52 = [sections rowWithSectionKey:kSectionType5 rowKey:kRowType52];
    SMRRow *row53 = [sections rowWithSectionKey:kSectionType5 rowKey:kRowType53];
    
    SMRRow *row54 = [sections rowWithSectionKey:kSectionType5 rowKey:kRowType53 + 1];
    SMRRow *row61 = [sections rowWithSectionKey:kSectionType5 + 1 rowKey:kRowType53 + 2];
    SMRRow *row62 = [sections rowWithSectionKey:kSectionType5 + 1 rowKey:kRowType53 + 3];
    
    // 有
    NSArray *rows = @[row11, row12,
                      row21,
                      row31,
                      row41,
                      row51, row52, row53];
    for (SMRRow *row in rows) {
        NSAssert(row, @"");
    }
    // 无
    NSAssert(!row54, @"");
    NSAssert(!row61, @"");
    NSAssert(!row62, @"");
}

- (void)testMethods003 {
    SMRSections *sections = self.sections;
    SMRSection *sec1 = [sections sectionWithSectionKey:kSectionType1];
    SMRSection *sec2 = [sections sectionWithSectionKey:kSectionType2];
    SMRSection *sec3 = [sections sectionWithSectionKey:kSectionType3];
    SMRSection *sec4 = [sections sectionWithSectionKey:kSectionType4];
    SMRSection *sec5 = [sections sectionWithSectionKey:kSectionType5];
    SMRSection *sec6 = [sections sectionWithSectionKey:kSectionType5 + 1];
    
    // 有
    NSArray *secs = @[sec1, sec2, sec3, sec4, sec5];
    for (SMRSection *sec in secs) {
        NSAssert(sec, @"");
    }
    // 无
    NSAssert(!sec6, @"");
}

- (void)testMethods004 {
    NSIndexPath *indexPath11 = [NSIndexPath indexPathForRow:0 inSection:0];
    NSIndexPath *indexPath12 = [NSIndexPath indexPathForRow:1 inSection:0];
    NSIndexPath *indexPath21 = [NSIndexPath indexPathForRow:0 inSection:1];
    NSIndexPath *indexPath31 = [NSIndexPath indexPathForRow:0 inSection:2];
    NSIndexPath *indexPath41 = [NSIndexPath indexPathForRow:0 inSection:5];
    NSIndexPath *indexPath51 = [NSIndexPath indexPathForRow:0 inSection:6];
    NSIndexPath *indexPath52 = [NSIndexPath indexPathForRow:1 inSection:6];
    NSIndexPath *indexPath53 = [NSIndexPath indexPathForRow:2 inSection:6];
    
    SMRSections *sections = self.sections;
    NSIndexPath *s_indexPath11 = [sections indexPathWithSectionKey:kSectionType1 rowKey:kRowType11];
    NSIndexPath *s_indexPath12 = [sections indexPathWithSectionKey:kSectionType1 rowKey:kRowType12];
    NSIndexPath *s_indexPath21 = [sections indexPathWithSectionKey:kSectionType2 rowKey:kRowType21];
    NSIndexPath *s_indexPath31 = [sections indexPathWithSectionKey:kSectionType3 rowKey:kRowType31];
    NSIndexPath *s_indexPath41 = [sections indexPathWithSectionKey:kSectionType4 rowKey:kRowType41];
    NSIndexPath *s_indexPath51 = [sections indexPathWithSectionKey:kSectionType5 rowKey:kRowType51];
    NSIndexPath *s_indexPath52 = [sections indexPathWithSectionKey:kSectionType5 rowKey:kRowType52];
    NSIndexPath *s_indexPath53 = [sections indexPathWithSectionKey:kSectionType5 rowKey:kRowType53];
    
    NSIndexPath *s_indexPath54 = [sections indexPathWithSectionKey:kSectionType5 rowKey:kRowType53 + 1];
    NSIndexPath *s_indexPath61 = [sections indexPathWithSectionKey:kSectionType5 + 1 rowKey:kRowType53 + 2];
    NSIndexPath *s_indexPath62 = [sections indexPathWithSectionKey:kSectionType5 + 1 rowKey:kRowType53 + 3];
    
    NSAssert([indexPath11 isEqualToIndexPath:s_indexPath11], @"");
    NSAssert([indexPath12 isEqualToIndexPath:s_indexPath12], @"");
    NSAssert([indexPath21 isEqualToIndexPath:s_indexPath21], @"");
    NSAssert([indexPath31 isEqualToIndexPath:s_indexPath31], @"");
    NSAssert([indexPath41 isEqualToIndexPath:s_indexPath41], @"");
    NSAssert([indexPath51 isEqualToIndexPath:s_indexPath51], @"");
    NSAssert([indexPath52 isEqualToIndexPath:s_indexPath52], @"");
    NSAssert([indexPath53 isEqualToIndexPath:s_indexPath53], @"");
    
    NSAssert(!s_indexPath54, @"");
    NSAssert(!s_indexPath61, @"");
    NSAssert(!s_indexPath62, @"");
    
    for (int i = 0; i < 4; i++) {
        NSIndexPath *indexPath = [sections indexPathWithSectionKey:kSectionType4 rowKey:kRowType41 rowSamesIndex:i];
        NSAssert((indexPath.section == 5) && (indexPath.row == i), @"");
    }
    
    NSInteger indexPathSection1 = [sections indexPathSectionWithSectionKey:kSectionType1];
    NSInteger indexPathSection2 = [sections indexPathSectionWithSectionKey:kSectionType2];
    NSInteger indexPathSection3 = [sections indexPathSectionWithSectionKey:kSectionType3];
    NSInteger indexPathSection4 = [sections indexPathSectionWithSectionKey:kSectionType4];
    NSInteger indexPathSection5 = [sections indexPathSectionWithSectionKey:kSectionType5];
    NSInteger indexPathSection6 = [sections indexPathSectionWithSectionKey:kSectionType5 + 1];
    NSAssert(indexPathSection1 == 0, @"");
    NSAssert(indexPathSection2 == 1, @"");
    NSAssert(indexPathSection3 == 2, @"");
    NSAssert(indexPathSection4 == 5, @"");
    NSAssert(indexPathSection5 == 6, @"");
    NSAssert(indexPathSection6 == -1, @"");
    
    for (int i = 0; i < 3; i++) {
        NSInteger indexPathSection = [sections indexPathSectionWithSectionKey:kSectionType3 sectionSamesIndex:i];
        NSAssert(indexPathSection == i + 2, @"");
    }
}

@end
