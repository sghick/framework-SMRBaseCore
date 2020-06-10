//
//  SMRSideMenuView.h
//  SMRBaseCoreDemo
//
//  Created by Tinswin on 2020/3/31.
//  Copyright © 2020 sumrise. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 测试sideMenu
 
static NSInteger idx = 0;
static NSInteger style = 0;
static BOOL reverse = NO;
SMRSideMenuView *sideMenu = [[SMRSideMenuView alloc] initWithFrame:[UIScreen mainScreen].bounds];
sideMenu.maxHeightOfContent = [SMRUIAdapter value:150];
sideMenu.trangleStyle = style;
sideMenu.trangleOffsetReverse = reverse;
if (style == SMRSideMenuTrangleStyleLeft || style == SMRSideMenuTrangleStyleRight) {
    sideMenu.trangleOffset = CGPointMake(0, [SMRUIAdapter value:5]);
} else {
    sideMenu.trangleOffset = CGPointMake([SMRUIAdapter value:5], 0);
}
idx++;
if (idx%2 == 0) {
    style = (style + 1)%5;
}
reverse = !reverse;
 
*/

/// 白色小三角形的朝向, 需要配合trangleOffset使用
typedef NS_ENUM(NSInteger, SMRSideMenuTrangleStyle) {
    SMRSideMenuTrangleStyleNone,    // 无
    SMRSideMenuTrangleStyleUp,      // 向上
    SMRSideMenuTrangleStyleDown,    // 向下
    SMRSideMenuTrangleStyleLeft,    // 向左
    SMRSideMenuTrangleStyleRight,   // 向右
};

@class SMRShadowItem;
@class SMRSideMenuView;
/// 定制调试时的block
typedef CGFloat(^SMRWebSideMenuItemHeightBlock)(SMRSideMenuView *menu, UIView *item, NSInteger index);
/// 点击事件的block
typedef void(^SMRWebSideMenuTouchedBlock)(SMRSideMenuView *menu, UIView *item, NSInteger index);
/// 菜单即将消失时的block
typedef void(^SMRWebSideMenuWillDismissBlock)(SMRSideMenuView *menu);

@interface SMRSideMenuView : UIView

@property (nonatomic, strong, readonly) UIView *parentView;
@property (nonatomic, strong, readonly) UIView *contentView;
@property (nonatomic, strong, readonly) UIImageView *trangleView;

@property (nonatomic, strong, readonly) UIImageView *shadowView;
@property (nonatomic, assign) UIEdgeInsets shadowEdgeInsets;///< {8,8,8,8}

@property (nonatomic, copy  ) SMRWebSideMenuItemHeightBlock itemHeightBlock; ///< 默认44
@property (nonatomic, copy  ) SMRWebSideMenuTouchedBlock menuTouchedBlock;
@property (nonatomic, copy  ) SMRWebSideMenuWillDismissBlock menuWillDismissBlock;

@property (nonatomic, assign) SMRSideMenuTrangleStyle trangleStyle; ///< 三角形的样式
@property (nonatomic, assign) CGPoint trangleOffset; ///< 三角形的偏移
@property (nonatomic, assign) BOOL trangleOffsetReverse; ///< 反转计算三角形的偏移

@property (nonatomic, strong, readonly) NSArray<UIView *> *menuItems;
@property (nonatomic, assign, readonly) CGFloat menuWidth;
@property (nonatomic, assign) CGFloat minHeightOfContent; ///< view.height
@property (nonatomic, assign) CGFloat maxHeightOfContent; ///< view.height
@property (nonatomic, assign) BOOL scrollEnabled; ///< default:YES

@property (nonatomic, strong, readonly) UITableView *tableView;

- (void)loadMenuWithItems:(NSArray<UIView *> *)menuItems
                menuWidth:(CGFloat)menuWidth
                   origin:(CGPoint)origin;

- (void)show;
- (void)showInView:(UIView *)view;
- (void)hide;

+ (NSArray<UIView *> *)menuItemsWithTitles:(NSArray<NSString *> *)titles;

@end
