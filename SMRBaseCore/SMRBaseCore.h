//
//  SMRBaseCore.h
//  SMRBaseCoreDemo
//
//  Created by 丁治文 on 2019/1/31.
//  Copyright © 2019 sumrise. All rights reserved.
//

/**
 || +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ ||
 || +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ ||
 info.plist 配置表
 配置表的key:Base Core Config,以下所有值请在这个配置下写
 
 | key | value | rem |
 | ------ | ------ | ------ |
 | Adapter Margin | 15*scale | [SMRUIAdapter margin] |
 
 || +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ ||
 || +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ ||
 **/

#ifndef SMRBaseCore_h
#define SMRBaseCore_h

/// SMRCoreKit
#import "SMRDB.h"
#import "SMRLifecycle.h"
#import "SMRRouter.h"
#import "SMRModel.h"
#import "SMRDebug.h"
#import "SMRNetwork.h"
#import "NSError+SMRError.h"
#import "SMRRanker.h"
#import "SMRLayout.h"
#import "SMRCache.h"

/// SMRUIKit
#import "SMRViewController.h"
#import "SMRAdapter.h"
#import "SMRNavigationView.h"
#import "SMRTableAssistant.h"
#import "UIView+SMRResponder.h"
#import "UIButton+SMR.h"
#import "SMRAlertView.h"
#import "SMRTextView.h"
#import "UIView+SMRGesture.h"
#import "SMRSimpleCamera.h"
#import "SMRLBXScanController.h"
#import "SMRWeb.h"

/// SMRUtilsKit
#import "SMRMatrixCalculator.h"
#import "SMRPhoneInfo.h"
#import "SMRAppInfo.h"
#import "SMRKeyChainManager.h"
#import "SMRUtilsHeader.h"

#endif /* SMRBaseCore_h */
