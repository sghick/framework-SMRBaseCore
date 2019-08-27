//
//  SMRCarouselView.h
//  SMRBaseCoreDemo
//
//  Created by 丁治文 on 2019/8/22.
//  Copyright © 2019 sumrise. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SMRCarouselView : UIView

@property (assign, nonatomic) CGSize sizeOfView;
@property (strong, nonatomic) NSArray<UIView *> *views;

- (void)reloadData;

@end

NS_ASSUME_NONNULL_END
