//
//  SMRTableAlertView.h
//  SMRBaseCoreDemo
//
//  Created by 丁治文 on 2019/2/14.
//  Copyright © 2019 sumrise. All rights reserved.
//

#import "SMRContentMaskView.h"

NS_ASSUME_NONNULL_BEGIN

@protocol SMRTableAlertViewProtocol <NSObject>

@optional
/** 规定了内容视频上内容的边框 */
- (UIEdgeInsets)smr_insetsOfContent;

@optional
- (CGFloat)smr_marginOfTitleBar;
- (CGFloat)smr_heightOfTitleBar;
- (nullable UIView *)smr_titleBarOfTableAlertView;

@optional
- (CGFloat)smr_marginOfBottomBar;
- (CGFloat)smr_heightOfBottomBar;
- (nullable UIView *)smr_bottomBarOfTableAlertView;

@optional
- (CGFloat)smr_marginOfTableView;
- (CGFloat)smr_heightOfTableView:(UITableView *)tableView;
- (CGFloat)smr_maxHeightOfTableView:(UITableView *)tableView;
@optional
- (NSInteger)smr_numberOfSectionsInTableView:(UITableView *)tableView;
- (CGFloat)smr_tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
@required
- (NSInteger)smr_tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
- (UITableViewCell *)smr_tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
@optional
- (void)smr_tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)smr_tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
@optional
- (void)smr_reloadData;

@end

@interface SMRTableAlertView : SMRContentMaskView<SMRTableAlertViewProtocol>

@property (strong, nonatomic) UITableView *tableView;

/** 仅标记需要刷新view */
- (void)smr_setNeedsReloadView;
/** 立即刷新view */
- (void)smr_reloadViewIfNeeded;

@end

NS_ASSUME_NONNULL_END
