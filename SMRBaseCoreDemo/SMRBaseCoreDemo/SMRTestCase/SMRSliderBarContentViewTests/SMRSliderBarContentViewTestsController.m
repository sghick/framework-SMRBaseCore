//
//  SMRSliderBarContentViewTestsController.m
//  SMRBaseCoreDemo
//
//  Created by 丁治文 on 2019/4/11.
//  Copyright © 2019 sumrise. All rights reserved.
//

#import "SMRSliderBarContentViewTestsController.h"
#import "SMRSliderBarContentView.h"
#import "PureLayout.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface SMRSliderBarContentViewTestsController ()<
SMRSliderBarContentViewDelegate>

@property (strong, nonatomic) SMRSliderBarContentView *sliderView;
@property (copy  , nonatomic) NSArray<NSString *> *imageURLs;

@end

@implementation SMRSliderBarContentViewTestsController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.sliderView];
    
    self.imageURLs = @[@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1558587313663&di=94f632cbb70f5d65b08e577594ac61dd&imgtype=0&src=http%3A%2F%2Fb-ssl.duitang.com%2Fuploads%2Fitem%2F201701%2F19%2F20170119144835_wcHdX.thumb.700_0.jpeg",@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1558587313663&di=7b7082f19176d70aafc2118c22fac3d2&imgtype=0&src=http%3A%2F%2Fstaticqn.qizuang.com%2Fimg%2F20180918%2F5ba09ddd5157f-s5.jpg",@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1558587313663&di=077b6e2a4a18b005614626e9d96674f6&imgtype=0&src=http%3A%2F%2Fimg.pconline.com.cn%2Fimages%2Fupload%2Fupc%2Ftx%2Fhousephotolib%2F1612%2F20%2Fc1%2F32853477_1482205101484_690x460.jpg",@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1558587313663&di=dec7ff4d634390732daa0ddf96ad17b5&imgtype=0&src=http%3A%2F%2Fimgs.bzw315.com%2Fuploadfiles%2FNew%2Fimage%2F20131104%2F20131104104102_5770.jpg",@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1558587313662&di=316b04bc25b9405971e7172dc79f08fa&imgtype=0&src=http%3A%2F%2Fimg.pconline.com.cn%2Fimages%2Fupload%2Fupc%2Ftx%2Fhousephotolib%2F1611%2F02%2Fc0%2F29286275_1478057749125_690x460.jpg",@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1558587313662&di=223d3cb02135b905c255fb059fdb3834&imgtype=0&src=http%3A%2F%2Fimg.pconline.com.cn%2Fimages%2Fupload%2Fupc%2Ftx%2Fhousephotolib%2F1612%2F20%2Fc1%2F32853477_1482205100312_690x460.jpg"];
    
    UIButton *btn = [SMRNavigationView buttonOfOnlyTextWithText:@"小明" selectedText:@"小东" target:self action:@selector(description)];
    btn.frame = CGRectMake(0, 0, 30, 30);
    self.navigationView.leftView = btn;
    
    [self.sliderView reloadView];
}

- (void)updateViewConstraints {
    [self.sliderView autoCenterInSuperview];
    [self.sliderView autoSetDimensionsToSize:CGSizeMake([UIScreen mainScreen].bounds.size.width, 300)];
    [super updateViewConstraints];
}

#pragma mark - SMRSliderBarContentViewDelegate

- (NSInteger)numbersOfCountForSliderBarContentView:(SMRSliderBarContentView *)contentView {
    return self.imageURLs.count;
}

- (UIView *)sliderBarContentView:(SMRSliderBarContentView *)contentView subviewForIndex:(NSInteger)index {
    NSString *url = self.imageURLs[index%self.imageURLs.count];
    UIImageView *imageView = [[UIImageView alloc] init];
    [imageView sd_setImageWithURL:[NSURL URLWithString:url]];
    return imageView;
}

- (void)sliderBarContentView:(SMRSliderBarContentView *)contentView didScrollToIndex:(NSInteger)index {
    NSLog(@"toIndex:%@", @(index));
}


#pragma mark - Getters

- (SMRSliderBarContentView *)sliderView {
    if (!_sliderView) {
        _sliderView = [[SMRSliderBarContentView alloc] init];
        _sliderView.backgroundColor = [UIColor yellowColor];
        _sliderView.delegate = self;
    }
    return _sliderView;
}

@end
