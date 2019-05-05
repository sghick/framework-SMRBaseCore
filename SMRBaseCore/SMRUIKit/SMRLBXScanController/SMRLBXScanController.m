//
//  SMRLBXScanController.m
//  Gucci
//
//  Created by 丁治文 on 2019/4/2.
//  Copyright © 2019 sumrise. All rights reserved.
//

#import "SMRLBXScanController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import "SMRAdapter.h"
#import "PureLayout.h"

@interface SMRLBXScanController ()

@end

@implementation SMRLBXScanController
@synthesize backView = _backView;

- (instancetype)init {
    self = [super init];
    if (self) {
        _style = [self.class defaultCameraStyle];
        _scanCodeType = SMRScanCodeTypeQRCode;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.statusBarStyle = UIStatusBarStyleLightContent;
    [self.view addSubview:self.backView];
    [self.backView autoPinEdgesToSuperviewEdges];
    
    self.navigationView.theme = [SMRNavigationTheme themeForAlpha];
    self.navigationView.title = @"扫码";
    
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    self.view.backgroundColor = [UIColor blackColor];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self drawScanView];
    
    __weak typeof(self) weakSelf = self;
    [self requestCameraPemissionWithResult:^(BOOL granted) {
        if (granted) {
            //不延时，可能会导致界面黑屏并卡住一会
            [self performSelector:@selector(startScan) withObject:nil afterDelay:0.3];
        } else {
            [weakSelf.qRScanView stopDeviceReadying];
        }
    }];
}

//绘制扫描区域
- (void)drawScanView {
    if (!_qRScanView) {
        CGRect rect = self.view.frame;
        rect.origin = CGPointMake(0, 0);
        
        self.qRScanView = [[LBXScanView alloc] initWithFrame:rect style:_style];
        
        [self.backView addSubview:_qRScanView];
    }
    
    if (!_cameraInvokeMsg) {
        // _cameraInvokeMsg = NSLocalizedString(@"wating...", nil);
    }
    
    [_qRScanView startDeviceReadyingWithText:_cameraInvokeMsg];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    
    [self stopScan];
    [_qRScanView stopScanAnimation];
}

- (void)reStartDevice {
    [_scanObj startScan];
    [_qRScanView startScanAnimation];
}

- (void)stopScan {
    [_scanObj stopScan];
    [_qRScanView stopScanAnimation];
}

//启动设备
- (void)startScan {
    UIView *videoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame))];
    videoView.backgroundColor = [UIColor clearColor];
    [self.backView insertSubview:videoView atIndex:0];
    __weak __typeof(self) weakSelf = self;
    if (!_scanObj ) {
        CGRect cropRect = CGRectZero;
        
        if (_isOpenInterestRect) {
            //设置只识别框内区域
            cropRect = [LBXScanView getScanRectWithPreView:self.backView style:_style];
        }
        
        NSString *strCode = AVMetadataObjectTypeQRCode;
        if (_scanCodeType != SMRScanCodeTypeBarCodeITF) {
            strCode = [self nativeCodeWithType:_scanCodeType];
        }
        
        //AVMetadataObjectTypeITF14Code 扫码效果不行,另外只能输入一个码制，虽然接口是可以输入多个码制
        self.scanObj = [[LBXScanNative alloc] initWithPreView:videoView ObjectType:@[strCode] cropRect:cropRect success:^(NSArray<LBXScanResult *> *array) {
            [weakSelf.qRScanView stopScanAnimation];
            [weakSelf scanResultWithArray:array];
        }];
        [_scanObj setNeedCaptureImage:_isNeedScanImage];
    }
    [_scanObj startScan];
    
    [_qRScanView stopDeviceReadying];
    [_qRScanView startScanAnimation];
    
    self.backView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
}

#pragma mark - 扫码结果处理

- (void)scanResultWithArray:(NSArray<LBXScanResult*>*)array {
    //设置了委托的处理
    if (_delegate) {
        [_delegate scanResultWithArray:array];
    }
    //也可以通过继承LBXScanViewController，重写本方法即可
}

//开关闪光灯
- (void)openOrCloseFlash {
    [_scanObj changeTorch];
    self.isOpenFlash =!self.isOpenFlash;
}

#pragma mark - 打开相册并识别图片

/*!
 *  打开本地照片，选择图片识别
 */
- (void)openLocalPhoto:(BOOL)allowsEditing {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    picker.delegate = self;
    
    //部分机型有问题
    picker.allowsEditing = allowsEditing;
    
    
    [self presentViewController:picker animated:YES completion:nil];
}



//当选择一张图片后进入这里

- (void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    __block UIImage* image = [info objectForKey:UIImagePickerControllerEditedImage];
    
    if (!image){
        image = [info objectForKey:UIImagePickerControllerOriginalImage];
    }
    
    __weak __typeof(self) weakSelf = self;
    if ([[[UIDevice currentDevice]systemVersion]floatValue] >= 8.0) {
        [LBXScanNative recognizeImage:image success:^(NSArray<LBXScanResult *> *array) {
            [weakSelf scanResultWithArray:array];
        }];
    } else {
        [self showError:@"native低于ios8.0系统不支持识别图片条码"];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    NSLog(@"cancel");
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (NSString *)nativeCodeWithType:(SMRScanCodeType)type {
    switch (type) {
        case SMRScanCodeTypeQRCode:
            return AVMetadataObjectTypeQRCode;
            break;
        case SMRScanCodeTypeBarCode93:
            return AVMetadataObjectTypeCode93Code;
            break;
        case SMRScanCodeTypeBarCode128:
            return AVMetadataObjectTypeCode128Code;
            break;
        case SMRScanCodeTypeBarCodeITF:
            return @"ITF条码:only ZXing支持";
            break;
        case SMRScanCodeTypeBarEAN13:
            return AVMetadataObjectTypeEAN13Code;
            break;
            
        default:
            return AVMetadataObjectTypeQRCode;
            break;
    }
}

- (void)showError:(NSString*)str {
    
}

- (void)requestCameraPemissionWithResult:(void(^)(BOOL granted))completion {
    if ([AVCaptureDevice respondsToSelector:@selector(authorizationStatusForMediaType:)]) {
        AVAuthorizationStatus permission =
        [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        
        switch (permission) {
            case AVAuthorizationStatusAuthorized:
                completion(YES);
                break;
            case AVAuthorizationStatusDenied:
            case AVAuthorizationStatusRestricted:
                completion(NO);
                break;
            case AVAuthorizationStatusNotDetermined:
            {
                [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo
                                         completionHandler:^(BOOL granted) {
                                             
                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                 if (granted) {
                                                     completion(true);
                                                 } else {
                                                     completion(false);
                                                 }
                                             });
                                         }];
            }
                break;
                
        }
    }
    
    
}

+ (BOOL)photoPermission {
    PHAuthorizationStatus authorStatus = [PHPhotoLibrary authorizationStatus];
    if ( authorStatus == PHAuthorizationStatusDenied ) {
        return NO;
    }
    return YES;
}

#pragma mark - Custom

+ (LBXScanViewStyle *)defaultCameraStyle {
    //设置扫码区域参数设置
    
    //创建参数对象
    LBXScanViewStyle *style = [[LBXScanViewStyle alloc] init];
    //矩形区域中心上移，默认中心点为屏幕中心点
    style.centerUpOffset = 44;
    
    //photo_scan_border
    //扫码框周围4个角的类型,设置为外挂式
    style.photoframeAngleStyle = LBXScanViewPhotoframeAngleStyle_Inner;
    style.colorAngle = [UIColor smr_colorWithHexRGB:@"#FFCE38"];
    style.colorRetangleLine = [UIColor smr_colorWithHexRGB:@"#FFCE38"];
    //显示矩形框
    style.isNeedShowRetangle = YES;
    //扫码框周围4个角绘制的线条宽度
    style.photoframeLineW = 4;
    //扫码框周围4个角的宽度
    style.photoframeAngleW = 12;
    //扫码框周围4个角的高度
    style.photoframeAngleH = 12;
    //扫码框大小
    style.xScanRetangleOffset = [SMRUIAdapter value:40.0];
    //扫码框内 动画类型 --线条上下移动
    style.anmiationStyle = LBXScanViewAnimationStyle_LineMove;
    //线条上下移动图片
    style.animationImage = [UIImage imageNamed:@"photo_scan_line"];
    //非识别区域背景色值
    style.notRecoginitonArea = [[UIColor blackColor] smr_colorWithAlphaComponent:0.5];
    
    return style;
}

#pragma mark - Getters

- (UIView *)backView {
    if (!_backView) {
        _backView = [[UIView alloc] init];
        _backView.backgroundColor = [[UIColor blackColor] smr_colorWithAlphaComponent:0.5];
    }
    return _backView;
}

@end
