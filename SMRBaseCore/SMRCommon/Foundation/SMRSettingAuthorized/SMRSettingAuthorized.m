//
//  SMRSettingAuthorized.m
//  SMRBaseCoreDemo
//
//  Created by 丁治文 on 2019/7/11.
//  Copyright © 2019 sumrise. All rights reserved.
//

#import "SMRSettingAuthorized.h"
#import <UIKit/UIApplication.h>
#import <UIKit/UIUserNotificationSettings.h>
#import <UserNotifications/UserNotifications.h>
#import <Photos/Photos.h>

@implementation SMRSettingAuthorized


+ (void)openSettings {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
}

+ (void)getNotificationSetting:(void (^)(BOOL authorized))block {
    if (@available(iOS 10.0, *)) {
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (block) {
                    block(UNAuthorizationStatusAuthorized == settings.authorizationStatus);
                }
            });
        }];
    } else {
        UIUserNotificationSettings *settings = [[UIApplication sharedApplication] currentUserNotificationSettings];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (block) {
                block(UIUserNotificationTypeNone != settings.types);
            }
        });
    }
}

+ (void)getCameraSetting:(void (^)(BOOL))block request:(BOOL)request {
    if (!request) {
        AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if (block) {
            block(status == AVAuthorizationStatusAuthorized);
        }
    } else {
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (block) {
                    block(granted);
                }
            });
        }];
    }
}

+ (void)getMicrophoneSetting:(void (^)(BOOL))block request:(BOOL)request {
    if (!request) {
        if (block) {
            block([AVAudioSession sharedInstance].recordPermission == AVAudioSessionRecordPermissionGranted);
        }
    } else {
        [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if(block) {
                    block(granted);
                }
            });
        }];
    }
}

+ (void)getAlblumSetting:(void (^)(BOOL))block request:(BOOL)request {
    if (!request) {
        PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
        if (block) {
            block(status == PHAuthorizationStatusAuthorized);
        }
    } else {
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            dispatch_async(dispatch_get_main_queue(), ^{
               if (block) {
                   block(status == PHAuthorizationStatusAuthorized);
               }
            });
        }];
    }
}

@end
