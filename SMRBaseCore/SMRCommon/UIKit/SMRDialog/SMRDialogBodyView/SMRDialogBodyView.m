//
//  SMRDialogBodyView.m
//  Hermes
//
//  Created by Tinswin on 2021/3/27.
//  Copyright © 2021 isumrise. All rights reserved.
//

#import "SMRDialogBodyView.h"

@interface SMRDialogBodyView ()

@property (assign, nonatomic) BOOL needsReloadView;

@end

@implementation SMRDialogBodyView

@synthesize titleView = _titleView;
@synthesize bottomView = _bottomView;
@synthesize contentView = _contentView;

#pragma mark - Override

- (void)layoutSubviews {
    [super layoutSubviews];
    [self p_reloadViewIfNeeded];
}

#pragma mark - Utils

- (UIView *)p_addSubview:(UIView *)subview oldView:(UIView *)oldView {
    if (!subview) {
        [oldView removeFromSuperview];
        return nil;
    }
    if (subview != oldView) {
        [oldView removeFromSuperview];
        [self addSubview:subview];
    } else if (subview.superview != self) {
        [self addSubview:subview];
    }
    return subview;
}

- (UIView *)p_displayColumn:(UIView *)subview size:(CGSize)size lastView:(nullable UIView *)lastView {
    if (!subview) {
        return lastView;
    }
    CGRect frame = lastView.frame;
    CGFloat bottom = frame.origin.y + frame.size.height;
    CGRect subframe = {0, bottom, size};
    subview.frame = subframe;
    return subview;
}

- (void)p_reloadViewIfNeeded {
    if (!_needsReloadView) {
        return;
    }
    _needsReloadView = NO;
    CGFloat width = CGRectGetWidth(self.bounds);
    
    UIView *titleView = [self.delegate titleViewForBodyView:self];
    _titleView = [self p_addSubview:titleView oldView:_titleView];
    
    UIView *bottomView = [self.delegate bottomViewForBodyView:self];
    _bottomView = [self p_addSubview:bottomView oldView:_bottomView];
    
    UIView *contentView = [self.delegate contentViewForBodyView:self];
    _contentView = [self p_addSubview:contentView oldView:_contentView];
    
    UIView *lastView = nil;
    lastView = [self p_displayColumn:titleView size:CGSizeMake(width, CGRectGetHeight(titleView.bounds)) lastView:lastView];
    lastView = [self p_displayColumn:contentView size:CGSizeMake(width, CGRectGetHeight(contentView.bounds)) lastView:lastView];
    lastView = [self p_displayColumn:bottomView size:CGSizeMake(width, CGRectGetHeight(bottomView.bounds)) lastView:lastView];
    
    if ([self.delegate respondsToSelector:@selector(bodyViewAfterDisplay:contentSize:)]) {
        CGFloat originY = lastView.frame.origin.y;
        CGFloat height = lastView.frame.size.height;
        [self.delegate bodyViewAfterDisplay:self contentSize:CGSizeMake(width, originY + height)];
    }
}

#pragma mark - Public

- (void)reloadData {
    _needsReloadView = YES;
    [self setNeedsLayout];
}

@end
