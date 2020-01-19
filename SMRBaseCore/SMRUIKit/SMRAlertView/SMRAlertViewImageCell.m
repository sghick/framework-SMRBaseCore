//
//  SMRAlertViewImageCell.m
//  SMRBaseCoreDemo
//
//  Created by Tinswin on 2020/1/19.
//  Copyright © 2020 sumrise. All rights reserved.
//

#import "SMRAlertViewImageCell.h"
#import "PureLayout.h"
#import <UIImageView+WebCache.h>

@interface SMRAlertViewImageCell ()

@property (strong, nonatomic) UIImageView *alertImageView;
@property (assign, nonatomic) BOOL didLoadLayout;

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

- (void)layoutSubviews {
    [super layoutSubviews];
    self.alertImageView.center = self.contentView.center;
    CGRect frame = self.alertImageView.frame;
    frame = CGRectMake(frame.origin.x,
                       frame.origin.y + self.imageTop,
                       frame.size.width, frame.size.height);
    self.alertImageView.frame = frame;
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
    self.alertImageView.frame = CGRectMake(0, 0, imageSize.width, imageSize.height);
    self.alertImageView.center = self.contentView.center;
}

- (void)setImageTop:(CGFloat)imageTop {
    _imageTop = imageTop;
    CGRect frame = self.alertImageView.frame;
    frame = CGRectMake(frame.origin.x,
                       frame.origin.y + imageTop,
                       frame.size.width, frame.size.height);
    self.alertImageView.frame = frame;
}

#pragma mark - Getters

- (UIImageView *)alertImageView {
    if (!_alertImageView) {
        _alertImageView = [[UIImageView alloc] init];
    }
    return _alertImageView;
}

@end
