//
//  SMRImageLabel.m
//  SMRBaseCore
//
//  Created by 丁治文 on 2019/9/23.
//  Copyright © 2019 sumrise. All rights reserved.
//

#import "SMRImageLabel.h"
#import "PureLayout.h"

@interface SMRImageLabel ()

@property (assign, nonatomic) BOOL didLoadLayout;

@property (strong, nonatomic) NSArray<NSLayoutConstraint *> *layoutOfbackImages;

@end

@implementation SMRImageLabel

@synthesize backImageView = _backImageView;
@synthesize textLabel = _textLabel;

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews {
    [self addSubview:self.backImageView];
    [self addSubview:self.textLabel];
    
    [self setNeedsUpdateConstraints];
}

- (void)updateConstraints {
    if (!self.didLoadLayout) {
        self.didLoadLayout = YES;
        
        [NSLayoutConstraint autoSetPriority:UILayoutPriorityDefaultHigh forConstraints:^{
            [self.textLabel autoPinEdgesToSuperviewEdgesWithInsets:self.textLabelInsets];
        }];
        [self.backImageView autoPinEdgesToSuperviewEdges];
    }
    [super updateConstraints];
}

#pragma mark - Setters

#pragma mark - Getters

- (UIImageView *)backImageView {
    if (!_backImageView) {
        _backImageView = [[UIImageView alloc] init];
    }
    return _backImageView;
}

- (UILabel *)textLabel {
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] init];
    }
    return _textLabel;
}

@end
