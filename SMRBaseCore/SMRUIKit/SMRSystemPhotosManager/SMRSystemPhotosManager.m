//
//  SMRSystemPhotosManager.m
//  SMRBaseCoreDemo
//
//  Created by Tinswin on 2020/7/27.
//  Copyright © 2020 Tinswin. All rights reserved.
//

#import "SMRSystemPhotosManager.h"
#import "SMRAlertView.h"
#import "SMRSettingAuthorized.h"
#import "SMRUtils.h"
#import "SMRUtils+MBProgressHUD.h"
#import "SMRRouter.h"
#import "UIImage+SMRAdapter.h"

@interface SMRSystemPhotosManager ()<
UINavigationControllerDelegate,
UIImagePickerControllerDelegate>

@end

@implementation SMRSystemPhotosManager


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey, id> *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *selectedImage = info[UIImagePickerControllerOriginalImage];
    selectedImage = [UIImage smr_fixOrientation:selectedImage];
    NSData *data = UIImageJPEGRepresentation(selectedImage, 1.0);
    selectedImage = [UIImage imageWithData:data];
    if ([self.delegate respondsToSelector:@selector(systemPhotosManager:didFinishedPickingImage:data:)]) {
        [self.delegate systemPhotosManager:self didFinishedPickingImage:selectedImage data:data];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)showImagePickerAlert {
    __weak typeof(self) weakSelf = self;
    UIAlertAction *actionForTakePhoto = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf showImagePickerControllerWithType:UIImagePickerControllerSourceTypeCamera];
    }];
    UIAlertAction *actionForPhotoLibray = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf showImagePickerControllerWithType:UIImagePickerControllerSourceTypePhotoLibrary];
    }];
    
    UIAlertAction *actionForCancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        // None
    }];
    
    UIAlertController *alert = [[UIAlertController alloc] init];
    [alert addAction:actionForTakePhoto];
    [alert addAction:actionForPhotoLibray];
    [alert addAction:actionForCancel];
    [SMRNavigator presentToViewController:alert animated:YES];
}

- (void)showImagePickerControllerWithType:(UIImagePickerControllerSourceType)type {
    if (![UIImagePickerController isSourceTypeAvailable:type]) {
        [SMRUtils toast:@"设备不支持"];
        return;
    }
    if (type == UIImagePickerControllerSourceTypeCamera) {
        [SMRSettingAuthorized getCameraSetting:^(BOOL authorized) {
            if (authorized) {
                [self pushToImagePickerControllerWithType:type];
            } else {
                [self showCameraSettingAlertView];
            }
        } request:YES];
        return;
    }
    if (type == UIImagePickerControllerSourceTypePhotoLibrary) {
        [SMRSettingAuthorized getAlblumSetting:^(BOOL authorized) {
            if (authorized) {
                [self pushToImagePickerControllerWithType:type];
            } else {
                [self showAlbumSettingAlertView];
            }
        } request:YES];
        return;
    }
}

- (void)showCameraSettingAlertView {
    SMRAlertView *alert =
    [SMRAlertView alertViewWithTitle:@"您未启用相机功能"
                             content:@"请前往“设置”＞“隐私”＞“相机”中开启"
                        buttonTitles:@[@"取消", @"开启"]
                       deepColorType:SMRAlertViewButtonDeepColorTypeSure];
    [alert show];
    alert.sureButtonTouchedBlock = ^(id  _Nonnull maskView) {
        [maskView hide];
        [SMRSettingAuthorized openSettings];
    };
}

- (void)showAlbumSettingAlertView {
    SMRAlertView *alert =
    [SMRAlertView alertViewWithTitle:@"您未启用照片功能"
                             content:@"请前往“设置”＞“隐私”＞“照片”中开启"
                        buttonTitles:@[@"取消", @"开启"]
                       deepColorType:SMRAlertViewButtonDeepColorTypeSure];
    [alert show];
    alert.sureButtonTouchedBlock = ^(id  _Nonnull maskView) {
        [maskView hide];
        [SMRSettingAuthorized openSettings];
    };
}

- (void)pushToImagePickerControllerWithType:(UIImagePickerControllerSourceType)type {
    UIImagePickerController *controller = [[UIImagePickerController alloc] init];
    controller.sourceType = type;
    controller.delegate = self;
    
    if (@available(iOS 11.0, *)) {
        [UIScrollView appearance].contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAutomatic;
    } else {
        // Fallback on earlier versions
    }
    
    [SMRNavigator presentToViewController:controller animated:YES];
}

@end
