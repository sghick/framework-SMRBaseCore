//
//  SMRCarouselView.m
//  SMRBaseCoreDemo
//
//  Created by 丁治文 on 2019/8/22.
//  Copyright © 2019 sumrise. All rights reserved.
//

#import "SMRCarouselView.h"
#import "PureLayout.h"
#import "SMRLog.h"

@interface SMRCarouselView ()

@property (strong, nonatomic) UIPickerView *pickerView;

@end

@implementation SMRCarouselView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.pickerView];
        [self.pickerView autoPinEdgesToSuperviewEdges];
    }
    return self;
}

- (void)reloadData {
    [self.pickerView reloadAllComponents];
}

#pragma mark - UIPickerViewDelegate, UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.views.count;
}


- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    return self.sizeOfView.width;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return self.sizeOfView.height;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable UIView *)view {
    
    return view;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    NSString *content = @[@"aaa", @"bbb", @"ccc"][row];
    base_core_log(@"%@", content);
}

#pragma mark - Getters

- (UIPickerView *)pickerView {
    if (!_pickerView) {
        _pickerView = [[UIPickerView alloc] init];
        _pickerView.delegate = self;
        _pickerView.dataSource = self;
    }
    return _pickerView;
}

@end
