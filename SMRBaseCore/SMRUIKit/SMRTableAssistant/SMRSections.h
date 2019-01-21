//
//  SMRSections.h
//  SMRTableAssistantDemo
//
//  Created by 丁治文 on 2018/11/5.
//  Copyright © 2018年 sumrise.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SMRSection, SMRRow;
@interface SMRSections : NSObject

@property (nonatomic, strong, readonly) NSMutableArray<SMRSection *> *sections;
@property (nonatomic, assign, readonly) NSInteger sectionSamesCountOfAll;

/**
 返回一个row
 @return 未找到:若section存在，返回rowKey = -99999的row对象，否则返回nil
 */
- (SMRRow *)rowWithIndexPath:(NSIndexPath *)indexPath;
/**
 返回一个section
 @return 未找到返回nil
 */
- (SMRSection *)sectionWithIndexPathSection:(NSInteger)section;

/**
 返回对应的indexPath
 如果rowKey没有重复的，推荐用此方法
 @return 未找到返回nil
 */
- (NSIndexPath *)indexPathWithRowKey:(NSInteger)rowKey;
/**
 返回对应的indexPath
 如果rowKey有重复的，推荐用此方法
 @return 未找到返回nil
 */
- (NSIndexPath *)indexPathWithSectionKey:(NSInteger)sectionKey rowKey:(NSInteger)rowKey;

/**
 返回sectionKey对应的indexPath的section
 @return 未找到返回-1
 */
- (NSInteger)indexPathSectionWithSectionKey:(NSInteger)sectionKey;
/**
 返回一个section
 @return 未找到返回nil
 */
- (SMRSection *)sectionWithSectionKey:(NSInteger)sectionKey;

/**
 添加section
 */
- (void)addSection:(SMRSection *)section;
/**
 添加section，推荐使用本方法
 */
- (void)addSectionKey:(NSInteger)sectionKey rowKey:(NSInteger)rowKey;
/**
 添加section，这个section对应多个相同时可用
 */
- (void)addSectionKey:(NSInteger)sectionKey rowKey:(NSInteger)rowKey sectionSamesCount:(NSInteger)sectionSamesCount;
/**
 添加section，这个section-row对应多个相同时可用
 */
- (void)addSectionKey:(NSInteger)sectionKey rowKey:(NSInteger)rowKey rowSamesCount:(NSInteger)rowSamesCount;

@end

@class SMRRow;
@interface SMRSection : NSObject

@property (nonatomic, assign, readonly) NSInteger rowSamesCountOfAll;
@property (nonatomic, assign, readonly) NSInteger sectionKey;
@property (nonatomic, strong, readonly) NSMutableArray<SMRRow *> *rows;
@property (nonatomic, assign) NSInteger sectionSamesIndex;
@property (nonatomic, assign) NSInteger sectionSamesCount;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithSectionKey:(NSInteger)sectionKey;
- (void)addRowKey:(NSInteger)rowKey sectionSamesCount:(NSInteger)sectionSamesCount rowSamesCount:(NSInteger)rowSamesCount;
- (SMRRow *)rowAtIndexPathRow:(NSInteger)row;                /**< 未找到返回nil */
- (NSInteger)rowKeyAtIndexPathRow:(NSInteger)row;           /**< 未找到返回-1 */

@end

@interface SMRRow : NSObject

@property (nonatomic, assign) NSInteger sectionKey;
@property (nonatomic, assign) NSInteger rowKey;
@property (nonatomic, assign) NSInteger rowSamesIndex;
@property (nonatomic, assign) NSInteger rowSamesCount;

@end
