//
//  SMRDialogBodyView.h
//  Hermes
//
//  Created by Tinswin on 2021/3/27.
//  Copyright © 2021 ibaodashi. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class SMRDialogBodyView;
@protocol SMRDialogBodyViewDelegate <NSObject>

@required
- (UIView *)titleViewForBodyView:(SMRDialogBodyView *)bodyView;
- (UIView *)bottomViewForBodyView:(SMRDialogBodyView *)bodyView;
- (UIView *)contentViewForBodyView:(SMRDialogBodyView *)bodyView;

@optional
- (void)bodyViewAfterDisplay:(SMRDialogBodyView *)bodyView contentSize:(CGSize)contentSize;

@end

@interface SMRDialogBodyView : UIView

@property (weak  , nonatomic, readonly) UIView *titleView;
@property (weak  , nonatomic, readonly) UIView *bottomView;
@property (weak  , nonatomic, readonly) UIView *contentView;

@property (weak  , nonatomic) id<SMRDialogBodyViewDelegate> delegate;

- (void)reloadData;

@end

NS_ASSUME_NONNULL_END
