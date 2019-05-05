//
//  SMRLBXScanController.h
//  Gucci
//
//  Created by 丁治文 on 2019/4/2.
//  Copyright © 2019 ibaodashi. All rights reserved.
//

#import "SMRNavFatherController.h"
#import <Foundation/Foundation.h>
#import "LBXScanTypes.h"
#import "LBXScanView.h"
#import "LBXScanNative.h"

// @[@"QRCode",@"BarCode93",@"BarCode128",@"BarCodeITF",@"EAN13"];
typedef NS_ENUM(NSInteger, SMRScanCodeType) {
    SMRScanCodeTypeQRCode, //QR二维码
    SMRScanCodeTypeBarCode93,
    SMRScanCodeTypeBarCode128,//支付条形码(支付宝、微信支付条形码)
    SMRScanCodeTypeBarCodeITF,//燃气回执联 条形码?
    SMRScanCodeTypeBarEAN13 //一般用做商品码
};


/**
 扫码结果delegate,也可通过继承本控制器，override方法scanResultWithArray即可
 */
@protocol SMRLBXScanViewControllerDelegate <NSObject>

@optional
- (void)scanResultWithArray:(NSArray<LBXScanResult *> *)array;

@end


@interface SMRLBXScanController : SMRNavFatherController<UIImagePickerControllerDelegate, UINavigationControllerDelegate>


#pragma mark ---- 需要初始化参数 ------

/**
 当前选择的识别码制,QRCode
 */
@property (nonatomic, assign) SMRScanCodeType scanCodeType;



//扫码结果委托，另外一种方案是通过继承本控制器，override方法scanResultWithArray即可
@property (nonatomic, weak) id<SMRLBXScanViewControllerDelegate> delegate;


/**
 @brief 是否需要扫码图像
 */
@property (nonatomic, assign) BOOL isNeedScanImage;



/**
 @brief  启动区域识别功能
 */
@property(nonatomic,assign) BOOL isOpenInterestRect;


/**
 相机启动提示,如 相机启动中...
 */
@property (nonatomic, copy) NSString *cameraInvokeMsg;

/**
 *  界面效果参数,defaultCameraStyle
 */
@property (nonatomic, strong) LBXScanViewStyle *style;


#pragma mark -----  扫码使用的库对象 -------

/**
 @brief  扫码功能封装对象
 */
@property (nonatomic,strong) LBXScanNative *scanObj;



#pragma mark - 扫码界面效果及提示等

/**
 @brief  扫码区域视图都在此view之上
 */
@property (strong, nonatomic, readonly) UIView *backView;

/**
 @brief  扫码区域视图,二维码一般都是框
 */
@property (nonatomic,strong) LBXScanView *qRScanView;


/**
 @brief  扫码存储的当前图片
 */
@property(nonatomic,strong) UIImage *scanImage;


/**
 @brief  闪关灯开启状态记录
 */
@property(nonatomic,assign)BOOL isOpenFlash;


//打开相册
- (void)openLocalPhoto:(BOOL)allowsEditing;

//开关闪光灯
- (void)openOrCloseFlash;

//启动扫描
- (void)reStartDevice;

//关闭扫描
- (void)stopScan;

#pragma mark - Custom

/** 默认相机样式 */
+ (LBXScanViewStyle *)defaultCameraStyle;

@end
