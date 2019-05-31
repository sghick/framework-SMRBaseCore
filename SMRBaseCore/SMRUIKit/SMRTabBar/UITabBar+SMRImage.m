//
//  UITabBar+SMRImage.m
//  SMRBaseCoreDemo
//
//  Created by 丁治文 on 2019/5/31.
//  Copyright © 2019 sumrise. All rights reserved.
//

#import "UITabBar+SMRImage.h"
#import "UITabBar+SMRTabBarInfo.h"
#import "UIImage+SMRGif.h"

static NSUInteger const SMRTabBarImageViewTag = 8811000;

@implementation UITabBar (SMRImage)

#pragma mark - Public

/// 显示tabBar上的动态图
- (void)showAnimatedImage:(UIImage *)image imageSize:(CGSize)imageSize repeatTime:(NSInteger)repeatTime atIndex:(NSInteger)index {
    
    // 移除
    [self removeImageViewOnItemIndex:index viewStartTag:SMRTabBarImageViewTag];
    
    if (index >= self.items.count) {
        return;
    }
    
    UIButton *tabBarButton = [self tabBarButtonAtIndex:index];
    if (tabBarButton) {
        // 创建
        UIImageView *gifImageView = [self createImageViewWithImage:image tag:(SMRTabBarImageViewTag + index)];
        // {(0, 0), (44, 33)}
        gifImageView.animationRepeatCount = repeatTime;
        gifImageView.animationDuration = image.duration;
        
        UIImageView *tabBarSwappableImageView = [self tabBarSwappableImageViewAtTabBarButton:tabBarButton];
        if (tabBarSwappableImageView) {
            CGRect swappableImageViewFrame = [tabBarSwappableImageView convertRect:tabBarSwappableImageView.bounds toView:self];
            gifImageView.frame = CGRectMake(swappableImageViewFrame.origin.x + (swappableImageViewFrame.size.width - gifImageView.bounds.size.width)/2,
                                            swappableImageViewFrame.origin.y + (swappableImageViewFrame.size.height - gifImageView.bounds.size.height)/2,
                                            gifImageView.bounds.size.width,
                                            gifImageView.bounds.size.height);
        } else {
            gifImageView.center = CGPointMake(tabBarButton.center.x, tabBarButton.center.y - 7);
        }
        [gifImageView startAnimating];
        [self addSubview:gifImageView];
    }
}

/// 隐藏tabBar上的动态图
- (void)hideAnimatedImageViewAtItemIndex:(NSInteger)index {
    // 移除imageView
    [self removeImageViewOnItemIndex:index viewStartTag:SMRTabBarImageViewTag];
}

/// 隐藏tabBar上所有的动态图
- (void)hideAllAniatedImageView {
    NSInteger tabsCount = self.tabBarButtonsArray.count;
    for (NSInteger index = 0; index < tabsCount; index++) {
        [self hideAnimatedImageViewAtItemIndex:index];
    }
}

/// tabBar的动态图的imageView
- (UIImageView *)animatedImageViewAtItemIndex:(NSInteger)index {
    
    UIView *returnView = nil;
    for (UIView *subView in self.subviews) {
        if (subView.tag == SMRTabBarImageViewTag + index) {
            returnView = subView;
        }
    }
    return (UIImageView *)returnView;
}

#pragma mark - Private

- (void)removeImageViewOnItemIndex:(NSInteger)index viewStartTag:(NSInteger)viewStartTag {
    
    //按照tag值进行移除
    for (UIView *subView in self.subviews) {
        if (subView.tag == viewStartTag + index) {
            [subView removeFromSuperview];
            // 删除break，因为调用方法是异步的，程序中小红点增删频繁且异步，可能会加多个，如果加入break只能删除第一个匹配的。
        }
    }
}

// private 创建ImageView
- (UIImageView *)createImageViewWithImage:(UIImage *)image tag:(NSInteger)tag {
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = image.smr_gifImages.firstObject;;
    imageView.animationImages = image.smr_gifImages;
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.frame = CGRectMake(0, 0, image.size.width, image.size.height);
    imageView.tag = tag;
    return imageView;
}

@end
