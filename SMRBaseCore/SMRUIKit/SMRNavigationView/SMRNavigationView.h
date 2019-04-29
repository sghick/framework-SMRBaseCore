//
//  SMRNavigationView.h
//  SMRBaseCoreDemo
//
//  Created by 丁治文 on 2019/1/21.
//  Copyright © 2019 sumrise. All rights reserved.
//

#import "SMRNavigationAccessoriesBar.h"
#import "SMRNavigationDefine.h"

NS_ASSUME_NONNULL_BEGIN

@interface SMRNavigationView : SMRNavigationAccessoriesBar

/**
 *  返回按钮
 */
@property (nonatomic, strong) UIButton *backBtn;

/**
 *  一次返回按钮
 */
@property (nonatomic, strong) UIButton *closeBtn;

/**
 *  标题
 */
@property (nonatomic, strong) UILabel *titleLabel;

/**
 *  下边阴影(在nav之外)
 */
@property (nonatomic, strong) UIImageView *shadowView;


/**
 *  设置navigationView的theme
 */
@property (nonatomic, strong) SMRNavigationTheme *theme;

/**
 *  渐变值 0-1, 通过调用此方法来设置渐变,渐变色控制请在backgroundImageView上设置
 */
@property (nonatomic, assign) CGFloat gradationOffset;

/**
 *  渐变色的处理
 */
@property (nonatomic, copy  ) NavigationViewGradationBlock gradationBlock;

/**
 设置全局默认属性的block
 */
@property (nonatomic, copy  ) NavigationViewAppearanceBlock appearanceBlock;

@property (nonatomic, copy  ) NSString *title;          ///< default:nil
@property (nonatomic, assign) BOOL backBtnHidden;       ///< default:NO
@property (nonatomic, assign) BOOL titleLabelHidden;    ///< default:NO
@property (nonatomic, assign) BOOL closeBtnShow;        ///< defautl:NO
@property (nonatomic, assign) BOOL shadowViewShow;      ///< defautl:NO

/**
 代理
 */
@property (nonatomic, weak  ) id<SMRNavigationViewDelegate> delegate;



/**
 用于创建全局样式的实例
 */
+ (instancetype)appearance;

/**
 *  快速创建对象
 */
+ (instancetype)navigationView;

/**
 *  (推荐)在这个block中实现转换主题的方法
 */
- (void)addNavigationThemeAction:(NavigationViewResetToThemeBlock)themeAction;

/**
 *  设置渐变逻辑block处理的方法
 */
- (void)setGradationBlock:(NavigationViewGradationBlock)gradationBlock;

#pragma mark - Utils

/**
 仅是一个文案的按钮
 */
+ (UIButton *)buttonOfOnlyTextWithText:(NSString *)text target:(id)target action:(SEL)action;

/**
 一个文案和一个选中文案的按钮
 */
+ (UIButton *)buttonOfOnlyTextWithText:(NSString *)text selectedText:(NSString *)selectedText target:(id)target action:(SEL)action;

/**
 仅是一个图片的按钮
 */
+ (UIButton *)buttonOfOnlyImage:(UIImage *)image target:(id)target action:(SEL)action;

/**
 一个文案和一个图片的按钮
 */
+ (UIButton *)buttonOfTextWithText:(NSString *)text image:(UIImage *)image target:(id)target action:(SEL)action;

@end

NS_ASSUME_NONNULL_END
