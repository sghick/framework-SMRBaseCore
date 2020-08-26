//
//  SMRSearchNavigationView.h
//  SMRBaseCoreDemo
//
//  Created by Tinswin on 2020/7/8.
//  Copyright © 2020 Tinswin. All rights reserved.
//

#import "SMRNavigationView.h"

NS_ASSUME_NONNULL_BEGIN

@class SMRSearchBar;
@class SMRSearchNavigationView;
@protocol SMRSearchNavigationViewDelegate <SMRNavigationViewDelegate>

@optional
- (BOOL)searchNavigationView:(SMRSearchNavigationView *)navigationView shouldBeginEditing:(id)sender;
- (void)searchNavigationView:(SMRSearchNavigationView *)navigationView searchButtonClicked:(NSString *)text sender:(id)sender;
- (void)searchNavigationView:(SMRSearchNavigationView *)navigationView cancelButtonClicked:(NSString *)text sender:(id)sender;

@end

@interface SMRSearchNavigationView : SMRNavigationView

@property (strong, nonatomic, readonly) SMRSearchBar *searchBar;

@property (weak  , nonatomic) id<SMRSearchNavigationViewDelegate> delegate;
@property (assign, nonatomic) BOOL showCancelBtn;

@end

NS_ASSUME_NONNULL_END
