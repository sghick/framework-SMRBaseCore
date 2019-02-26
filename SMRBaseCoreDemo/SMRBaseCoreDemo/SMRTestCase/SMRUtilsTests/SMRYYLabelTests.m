//
//  SMRYYLabelTests.m
//  SMRBaseCoreDemo
//
//  Created by 丁治文 on 2019/2/25.
//  Copyright © 2019 sumrise. All rights reserved.
//

#import "SMRYYLabelTests.h"
#import "SMRUtils+YYText.h"

typedef void(^SMRYYTextRangeBlock)(NSString *string, NSString *text, NSRange range);

@interface SMRYYLabelTests ()

@end

@implementation SMRYYLabelTests

- (id)begin {
    NSArray<NSString *> *tags = @[@"Louis Vuitton", @"Hermès", @"Chanel", @"Dior", @"Bottega Veneta", @"Bvlgari", @"Chloé", @"Gucci"];
    NSMutableAttributedString *text = [SMRUtils yy_attributedStringWithTags:tags
                                                                   textFont:[UIFont systemFontOfSize:12]
                                                                  textColor:[UIColor blackColor]
                                                           hilitedTextColor:[UIColor grayColor]
                                                                   tagSpace:@""
                                                                  lineSpace:31
                                                                borderWidth:1
                                                                borderColor:[UIColor redColor]
                                                               cornerRadius:3
                                                               borderInsets:UIEdgeInsetsZero
                                                            backgroundColor:[UIColor yellowColor]
                                                                  tapAction:^(NSString *text, NSInteger index) {
        NSLog(@"tap text range:...%@, index:%@", text, @(index));
    }];
    
    YYLabel *label = [[YYLabel alloc] init];
    label.numberOfLines = 0;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.attributedText = text;
    label.backgroundColor = [UIColor cyanColor];
    
    YYTextContainer *container = [YYTextContainer containerWithSize:CGSizeMake(SCREEN_WIDTH, 200)];
    container.maximumNumberOfRows = 0;
    
    YYTextLayout *layout = [YYTextLayout layoutWithContainer:container text:text];
    CGSize size = [layout textBoundingSize];
    label.size = CGSizeMake(size.width, size.height + 31);
    label.center = YYTextCGRectGetCenter([UIScreen mainScreen].bounds);
    
    [[UIApplication sharedApplication].delegate.window addSubview:label];
    
    return self;
}


@end
