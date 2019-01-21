//
//  SMRLogScreen.m
//  SMRLogScreenDemo
//
//  Created by 丁治文 on 2018/10/1.
//  Copyright © 2018年 sumrise.com. All rights reserved.
//

#import "SMRLogScreen.h"
#import "SMRLogSideMenuView.h"
#import "FLEX.h"
#import "SMRLogSys.h"

#define FontSizeOfButtons (10)
#define SpaceOfButtons (10)
#define TopOfButtons (10)

@interface SMRLogScreen () <
UIGestureRecognizerDelegate,
SMRSideMenuViewDelegate>

@property (nonatomic, strong) UIButton *clearBtn;
@property (nonatomic, strong) UIButton *foldBtn;
@property (nonatomic, strong) UIButton *logBtn;
@property (nonatomic, strong) UIButton *flexBtn;
@property (nonatomic, strong) UIButton *filterBtn;
@property (nonatomic, strong) UIButton *hideBtn;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UITextView *filterTextView;
@property (nonatomic, strong) SMRLogSideMenuView *sideMenu;

@property (nonatomic, strong) NSMutableArray *groupLabels;
@property (nonatomic, strong) NSMutableArray *groupLogs;

@property (nonatomic, strong) NSArray *lastGroupLabels;
@property (nonatomic, strong) NSArray *filterdGroupLables;

@property (nonatomic, assign) CGAffineTransform lastTransform;
@property (nonatomic, assign) CGPoint viewOrigin;
@property (nonatomic, assign) CGSize viewSize;
@property (nonatomic, assign) CGSize buttonSize;

@property (nonatomic, assign) NSInteger numberOfLine;

@property (nonatomic, assign) BOOL didShow;

@end

@implementation SMRLogScreen

+ (instancetype)sharedScreen {
    static SMRLogScreen *_sharedLogScreen = nil;
    static dispatch_once_t onceTokenLogScreen;
    dispatch_once(&onceTokenLogScreen, ^{
        _sharedLogScreen = [[SMRLogScreen alloc] init];
        _sharedLogScreen.viewOrigin = CGPointMake(10, 180);
        _sharedLogScreen.viewSize = CGSizeMake([UIScreen mainScreen].bounds.size.width - 20, 320);
        _sharedLogScreen.numberOfLine = 0;
        _sharedLogScreen.maxNumberOfLine = 10000;
        _sharedLogScreen.enableOnlyWhenShow = YES;
        _sharedLogScreen.buttonSize = CGSizeMake(30, 20);
    });
    return _sharedLogScreen;
}

#pragma mark - Getters

/// index from 1 to n
- (CGFloat)xFromLeftWithIndex:(NSInteger)index {
    return SpaceOfButtons + (index-1)*(self.buttonSize.width + SpaceOfButtons);
}
/// index from 1 to n
- (CGFloat)xFromRightWithIndex:(NSInteger)index {
    return self.view.bounds.size.width - index*(self.buttonSize.width + SpaceOfButtons);
}

- (UIButton *)clearBtn {
    if (_clearBtn == nil) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.frame = CGRectMake([self xFromLeftWithIndex:1], TopOfButtons, self.buttonSize.width, self.buttonSize.height);
        [button setTitle:@"清除" forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:FontSizeOfButtons];
        [button addTarget:self action:@selector(clearBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        button.layer.cornerRadius = 5;
        button.layer.borderWidth = 1;
        button.layer.borderColor = [UIColor colorWithRed:240/255.0 green:255/255.0 blue:240/255.0 alpha:1.0].CGColor;
        [button setTintColor:[UIColor colorWithRed:240/255.0 green:255/255.0 blue:240/255.0 alpha:1.0]];
        _clearBtn = button;
    }
    return _clearBtn;
}

- (UIButton *)foldBtn {
    if (_foldBtn == nil) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.frame = CGRectMake([self xFromLeftWithIndex:2], TopOfButtons, self.buttonSize.width, self.buttonSize.height);
        [button setTitle:@"收起" forState:UIControlStateNormal];
        [button setTitle:@"展开" forState:UIControlStateSelected];
        button.titleLabel.font = [UIFont systemFontOfSize:FontSizeOfButtons];
        [button addTarget:self action:@selector(foldBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        button.layer.cornerRadius = 5;
        button.layer.borderWidth = 1;
        button.layer.borderColor = [UIColor colorWithRed:240/255.0 green:255/255.0 blue:240/255.0 alpha:1.0].CGColor;
        [button setTintColor:[UIColor colorWithRed:240/255.0 green:255/255.0 blue:240/255.0 alpha:1.0]];
        _foldBtn = button;
    }
    return _foldBtn;
}

- (UIButton *)logBtn {
    if (_logBtn == nil) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.frame = CGRectMake([self xFromLeftWithIndex:3], TopOfButtons, self.buttonSize.width, self.buttonSize.height);
        [button setTitle:@"LogF" forState:UIControlStateNormal];
        [button setTitle:@"LogN" forState:UIControlStateSelected];
        button.titleLabel.font = [UIFont systemFontOfSize:FontSizeOfButtons];
        [button addTarget:self action:@selector(logBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        button.layer.cornerRadius = 5;
        button.layer.borderWidth = 1;
        button.layer.borderColor = [UIColor colorWithRed:240/255.0 green:255/255.0 blue:240/255.0 alpha:1.0].CGColor;
        [button setTintColor:[UIColor colorWithRed:240/255.0 green:255/255.0 blue:240/255.0 alpha:1.0]];
        button.selected = [SMRLogSys debug];
        _logBtn = button;
    }
    return _logBtn;
}

- (UIButton *)flexBtn {
    if (_flexBtn == nil) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.frame = CGRectMake([self xFromLeftWithIndex:4], TopOfButtons, self.buttonSize.width, self.buttonSize.height);
        [button setTitle:@"FLEX" forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:FontSizeOfButtons];
        [button addTarget:self action:@selector(flexBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        button.layer.cornerRadius = 5;
        button.layer.borderWidth = 1;
        button.layer.borderColor = [UIColor colorWithRed:240/255.0 green:255/255.0 blue:240/255.0 alpha:1.0].CGColor;
        [button setTintColor:[UIColor colorWithRed:240/255.0 green:255/255.0 blue:240/255.0 alpha:1.0]];
        button.selected = ![FLEXManager sharedManager].isHidden;
        _flexBtn = button;
    }
    return _flexBtn;
}

- (UIButton *)filterBtn {
    if (_filterBtn == nil) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.frame = CGRectMake([self xFromLeftWithIndex:5], TopOfButtons, self.buttonSize.width, self.buttonSize.height);
        [button setTitle:@"过滤" forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:FontSizeOfButtons];
        [button addTarget:self action:@selector(filterBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        button.layer.cornerRadius = 5;
        button.layer.borderWidth = 1;
        button.layer.borderColor = [UIColor colorWithRed:240/255.0 green:255/255.0 blue:240/255.0 alpha:1.0].CGColor;
        [button setTintColor:[UIColor colorWithRed:240/255.0 green:255/255.0 blue:240/255.0 alpha:1.0]];
        _filterBtn = button;
    }
    return _filterBtn;
}

- (UIButton *)hideBtn {
    if (_hideBtn == nil) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.frame = CGRectMake([self xFromRightWithIndex:1], TopOfButtons, self.buttonSize.width, self.buttonSize.height);
        [button setTitle:@"关闭" forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:FontSizeOfButtons];
        [button addTarget:self action:@selector(hideBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        button.layer.cornerRadius = 5;
        button.layer.borderWidth = 1;
        button.layer.borderColor = [UIColor colorWithRed:240/255.0 green:255/255.0 blue:240/255.0 alpha:1.0].CGColor;
        [button setTintColor:[UIColor colorWithRed:240/255.0 green:255/255.0 blue:240/255.0 alpha:1.0]];
        _hideBtn = button;
    }
    return _hideBtn;
}

- (UIView *)view {
    if (_view == nil) {
        _view = [[UIView alloc] initWithFrame:CGRectMake(self.viewOrigin.x, self.viewOrigin.y, self.viewSize.width, self.viewSize.height)];
        _view.backgroundColor = [UIColor colorWithRed:105/255.0 green:105/255.0 blue:105/255.0 alpha:1.0];
        _view.clipsToBounds = YES;
        _view.layer.cornerRadius = 5;
        _view.layer.borderWidth = 5;
        _view.layer.borderColor = [UIColor colorWithRed:105/255.0 green:105/255.0 blue:105/255.0 alpha:1.0].CGColor;
        
        [_view addSubview:self.clearBtn];
        [_view addSubview:self.hideBtn];
        [_view addSubview:self.foldBtn];
        [_view addSubview:self.logBtn];
        [_view addSubview:self.flexBtn];
        [_view addSubview:self.filterBtn];
        [_view addSubview:self.textView];
        [_view addSubview:self.filterTextView];
        
        UIPanGestureRecognizer *panGes = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
        panGes.delegate = self;
        [_view addGestureRecognizer:panGes];
    }
    return _view;
}

- (UITextView *)textView {
    if (_textView == nil) {
        _textView = [[UITextView alloc] initWithFrame:CGRectMake(5, 40, self.viewSize.width - 10, self.viewSize.height - 40)];
        _textView.backgroundColor = [UIColor colorWithRed:211/255.0 green:211/255.0 blue:211/255.0 alpha:1.0];
        _textView.layer.cornerRadius = 5;
        _textView.editable = NO;
    }
    return _textView;
}

- (UITextView *)filterTextView {
    if (_filterTextView == nil) {
        _filterTextView = [[UITextView alloc] initWithFrame:CGRectMake(5, 40, self.viewSize.width - 10, self.viewSize.height - 40)];
        _filterTextView.backgroundColor = [UIColor colorWithRed:211/255.0 green:211/255.0 blue:211/255.0 alpha:1.0];
        _filterTextView.layer.cornerRadius = 5;
        _filterTextView.editable = NO;
        _filterTextView.hidden = YES;
    }
    return _filterTextView;
}

- (SMRLogSideMenuView *)sideMenu {
    if (!_sideMenu) {
        SMRLogSideMenuView *view = [[SMRLogSideMenuView alloc] initWithFrame:self.view.bounds];
        view.delegate = self;
        view.maxHeightOfContent = 150;
        _sideMenu = view;
    }
    return _sideMenu;
}

- (NSMutableArray *)groupLabels {
    if (!_groupLabels) {
        _groupLabels = [NSMutableArray array];
    }
    return _groupLabels;
}

- (NSMutableArray *)groupLogs {
    if (!_groupLogs) {
        _groupLogs = [NSMutableArray array];
    }
    return _groupLogs;
}

#pragma mark - Publics

- (NSString *)filterLogs:(NSArray *)logs groupLabels:(NSArray<NSString *> *)groupLabels {
    NSMutableString *rtn = [NSMutableString string];
    if (groupLabels) {
        for (NSString *groupLabel in groupLabels) {
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF beginswith[cd] %@", [NSString stringWithFormat:@"[%@]:", groupLabel]];
            NSArray *rtns = groupLabel?[logs filteredArrayUsingPredicate:predicate]:logs;
            for (NSString *str in rtns) {
                [rtn appendString:str];
            }
        }
    } else {
        for (NSString *str in logs) {
            [rtn appendString:str];
        }
    }
    return rtn;
}

#pragma mark - Actions

- (void)clearBtnAction:(UIButton *)sender {
    [self.view endEditing:YES];
    [self clear];
}

- (void)foldBtnAction:(UIButton *)sender {
    [self.view endEditing:YES];
    sender.selected = !sender.selected;
    if (sender.selected) {
        [UIView animateWithDuration:0.3 animations:^{
            self.view.frame = CGRectMake(self.viewOrigin.x, self.viewOrigin.y, self.viewSize.width, 40);
            self.textView.alpha = 0;
            self.filterTextView.alpha = 0;
        }];
    } else {
        [UIView animateWithDuration:0.3 animations:^{
            self.view.frame = CGRectMake(self.viewOrigin.x, self.viewOrigin.y, self.viewSize.width, self.viewSize.height);
            self.textView.alpha = 1;
            self.filterTextView.alpha = 1;
        }];
    }
}

- (void)logBtnAction:(UIButton *)sender {
    [self.view endEditing:YES];
    sender.selected = !sender.selected;
    [SMRLogSys setDebug:sender.selected];
}

- (void)filterBtnAction:(UIButton *)sender {
    [self.view endEditing:YES];
    
    NSArray *titles = [@[@"全部"] arrayByAddingObjectsFromArray:self.groupLabels.reverseObjectEnumerator.allObjects];
    NSArray *menuItems = [SMRLogSideMenuView menuItemsWithTitles:titles];
    self.lastGroupLabels = titles;
    [self.sideMenu loadMenuWithItems:menuItems menuWidth:70 origin:CGPointMake([self xFromLeftWithIndex:5] + self.buttonSize.width + 10, TopOfButtons)];
    [self.sideMenu layoutIfNeeded];
    [self.sideMenu showInView:self.view];
}

- (void)flexBtnAction:(UIButton *)sender {
    [self.view endEditing:YES];
    sender.selected = !sender.selected;
    [[FLEXManager sharedManager] toggleExplorer];
}

- (void)hideBtnAction:(UIButton *)sender {
    [self.view endEditing:YES];
    [SMRLogScreen hide];
}

#pragma mark - SMRSideMenuViewDelegate

- (CGFloat)sideMenuView:(SMRLogSideMenuView *)menu heightOfItem:(UIView *)item atIndex:(NSInteger)index {
    return 30;
}

- (void)sideMenuView:(SMRLogSideMenuView *)menu didTouchedItem:(UIView *)item atIndex:(NSInteger)index {
    dispatch_async(dispatch_get_main_queue(), ^{
        [menu hide];
        if (index == 0) {
            self.filterBtn.selected = NO;
            self.textView.hidden = NO;
            self.filterTextView.hidden = YES;
            self.filterTextView.text = nil;
            self.textView.text = [self filterLogs:self.groupLogs groupLabels:nil];
        } else {
            self.filterBtn.selected = YES;
            self.textView.hidden = YES;
            self.filterTextView.hidden = NO;
            self.textView.text = nil;
            self.filterdGroupLables = [self.lastGroupLabels objectsAtIndexes:[NSIndexSet indexSetWithIndex:index]];
            self.filterTextView.text = [self filterLogs:self.groupLogs groupLabels:self.filterdGroupLables];
        }
    });
}

#pragma mark - Move
- (void)handlePan:(UIPanGestureRecognizer *)recognizer {
    UIView *swipeView = recognizer.view;
    CGPoint translation = [recognizer translationInView:swipeView.superview];
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        self.lastTransform = swipeView.transform;
    }
    
    if (recognizer.state == UIGestureRecognizerStateChanged) {
        swipeView.transform = CGAffineTransformTranslate(self.lastTransform, translation.x, translation.y);
    }
    
    if (recognizer.state == UIGestureRecognizerStateEnded || recognizer.state == UIGestureRecognizerStateCancelled) {
        self.viewOrigin = swipeView.frame.origin;
    }
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    [self.view endEditing:YES];
    return YES;
}

#pragma mark - Utils

- (void)addLine:(NSString *)line linebreak:(BOOL)linebreak groupLabel:(NSString *)groupLabel {
    if (self.enableOnlyWhenShow && !self.view.superview) {
        return;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.didShow == YES) {
            if ([UIApplication respondsToSelector:@selector(sharedApplication)]) {
                UIApplication *application = [UIApplication performSelector:@selector(sharedApplication)];
                UIWindow *window = application.keyWindow;
                if (window && [window isKindOfClass:[UIView class]]) {
                    if (self.view.superview == window) {
                        [self.view.superview bringSubviewToFront:self.view];
                    } else {
                        [window addSubview:self.view];
                    }
                }
            }
        }
        
        if (self.numberOfLine > self.maxNumberOfLine) {
            [self clear];
        }
        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        format.dateFormat = @"HH:mm:ss";
        NSString *datestr = [format stringFromDate:[NSDate date]];
        NSString *realGroupLabel = groupLabel?:@"默认分组";
        NSString *logstr = [NSString stringWithFormat:@"[%@]:%@:%@%@", realGroupLabel, datestr, line, linebreak?@"\n":@""];
        
        // 展示过滤内容
        if (!self.filterTextView.hidden && [self.filterdGroupLables containsObject:realGroupLabel]) {
            [self.filterTextView insertText:logstr];
            [self.filterTextView scrollRangeToVisible:NSMakeRange(self.filterTextView.text.length, 1)];
        } else {
            [self.textView insertText:logstr];
            [self.textView scrollRangeToVisible:NSMakeRange(self.textView.text.length, 1)];
        }
        
        self.numberOfLine++;
        
        // 增加分组索引,用来过滤日志
        [self.groupLogs addObject:logstr];
        if (![self.groupLabels containsObject:realGroupLabel]) {
            [self.groupLabels addObject:realGroupLabel];
        }
    });
}

- (void)clear {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.groupLabels = nil;
        self.groupLogs = nil;
        self.numberOfLine = 0;
        self.textView.text = @"";
        self.filterTextView.text = @"";
    });
}

- (void)show {
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([UIApplication respondsToSelector:@selector(sharedApplication)]) {
            UIApplication *application = [UIApplication performSelector:@selector(sharedApplication)];
            UIWindow *window = application.keyWindow;
            if (window && [window isKindOfClass:[UIView class]]) {
                [window addSubview:self.view];
            }
        }
        self.didShow = YES;
    });
}
- (void)hide {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.didShow = NO;
        [self.view removeFromSuperview];
    });
}

+ (void)show {
    SMRLogScreen *mainLogscreen = [SMRLogScreen sharedScreen];
    [mainLogscreen show];
}
+ (void)hide {
    SMRLogScreen *mainLogscreen = [SMRLogScreen sharedScreen];
    [mainLogscreen hide];
}

+ (void)addLine:(NSString *)line linebreak:(BOOL)linebreak {
    SMRLogScreen *mainLogscreen = [SMRLogScreen sharedScreen];
    [mainLogscreen addLine:line linebreak:linebreak groupLabel:nil];
}
+ (void)addLine:(NSString *)line linebreak:(BOOL)linebreak groupLabel:(NSString *)groupLabel {
    SMRLogScreen *mainLogscreen = [SMRLogScreen sharedScreen];
    [mainLogscreen addLine:line linebreak:linebreak groupLabel:groupLabel];
}
+ (void)clear {
    SMRLogScreen *mainLogscreen = [SMRLogScreen sharedScreen];
    [mainLogscreen clear];
}

@end
