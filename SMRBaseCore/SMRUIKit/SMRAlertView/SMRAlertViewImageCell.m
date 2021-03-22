//
//  SMRAlertViewImageCell.m
//  SMRBaseCoreDemo
//
//  Created by Tinswin on 2020/1/19.
//  Copyright © 2020 sumrise. All rights reserved.
//

#import "SMRAlertViewImageCell.h"
#import "PureLayout.h"
#import "UIImageView+WebCache.h"

@interface SMRAlertViewImageCell ()

@property (strong, nonatomic) UIImageView *alertImageView;
@property (assign, nonatomic) BOOL didLoadLayout;

@property (strong, nonatomic) NSArray<NSLayoutConstraint *> *layoutsForSize;

@end

@implementation SMRAlertViewImageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [self.contentView addSubview:self.alertImageView];
}

- (void)updateConstraints {
    if (!self.didLoadLayout) {
        self.didLoadLayout = YES;
        [self.alertImageView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:1];
        [self.alertImageView autoAlignAxisToSuperviewAxis:ALAxisVertical];
    }
    [self.layoutsForSize autoRemoveConstraints];
    self.layoutsForSize = [self.alertImageView autoSetDimensionsToSize:self.imageSize];
    [super updateConstraints];
}

#pragma mark - Setters

- (void)setImage:(UIImage *)image {
    _image = image;
    self.alertImageView.image = image;
}

- (void)setImageURL:(NSString *)imageURL {
    _imageURL = imageURL;
    [self.alertImageView sd_setImageWithURL:[NSURL URLWithString:imageURL]];
}

- (void)setImageSize:(CGSize)imageSize {
    _imageSize = imageSize;
    [self setNeedsUpdateConstraints];
}

- (void)setImageBackgroundColor:(UIColor *)imageBackgroundColor {
    _imageBackgroundColor = imageBackgroundColor;
    self.alertImageView.backgroundColor = imageBackgroundColor;
}

- (void)setImageViewContentMode:(UIViewContentMode)imageViewContentMode {
    _imageViewContentMode = imageViewContentMode;
    self.alertImageView.contentMode = imageViewContentMode;
}

#pragma mark - Getters

- (UIImageView *)alertImageView {
    if (!_alertImageView) {
        _alertImageView = [[UIImageView alloc] init];
    }
    return _alertImageView;
}

@end
