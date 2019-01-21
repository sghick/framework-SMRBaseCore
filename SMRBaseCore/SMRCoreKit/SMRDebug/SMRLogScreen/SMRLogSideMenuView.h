//
//  SMRLogSideMenuView.h
//  SMRLogScreenDemo
//
//  Created by 丁治文 on 2018/10/1.
//  Copyright © 2018年 sumrise.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SMRLogSideMenuView;
@protocol SMRSideMenuViewDelegate <NSObject>

@required
- (CGFloat)sideMenuView:(SMRLogSideMenuView *)menu heightOfItem:(UIView *)item atIndex:(NSInteger)index;
@optional
- (void)sideMenuView:(SMRLogSideMenuView *)menu didTouchedItem:(UIView *)item atIndex:(NSInteger)index;
- (void)sideMenuViewWillDismiss:(SMRLogSideMenuView *)menu;///< 菜单即将消失时的回调

@end

@interface SMRLogSideMenuView : UIView

@property (nonatomic, weak  ) id<SMRSideMenuViewDelegate> delegate;
@property (nonatomic, strong, readonly) NSArray<UIView *> *menuItems;
@property (nonatomic, assign, readonly) CGFloat menuWidth;
@property (nonatomic, assign) CGFloat maxHeightOfContent;///< view.height
@property (nonatomic, assign) BOOL scrollEnabled;///< default:YES

- (void)loadMenuWithItems:(NSArray<UIView *> *)menuItems menuWidth:(CGFloat)menuWidth origin:(CGPoint)origin;

- (void)show;
- (void)showInView:(UIView *)view;
- (void)hide;

+ (NSArray<UIView *> *)menuItemsWithTitles:(NSArray<NSString *> *)titles;

@end
