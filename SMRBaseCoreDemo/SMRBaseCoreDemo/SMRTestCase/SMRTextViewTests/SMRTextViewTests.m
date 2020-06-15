//
//  SMRTextViewTests.m
//  SMRBaseCoreDemo
//
//  Created by 丁治文 on 2019/2/19.
//  Copyright © 2019 sumrise. All rights reserved.
//

#import "SMRTextViewTests.h"
#import "SMRCommon.h"
#import "SMRUIKit.h"

@implementation SMRTextViewTests

- (id)begin {
    SMRTextView *textview = [[SMRTextView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 300)/2.0, 100, 300, 200)];
    textview.showCountLabel = YES;
    textview.placeHolderLabel.text = @"请输入那么多字";
    [[UIApplication sharedApplication].delegate.window addSubview:textview];
    return self;
}

@end
