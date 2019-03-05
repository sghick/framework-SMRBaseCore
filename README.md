# framework-SMRBaseCore
基于组件化的基础库


#
## Index
* SMRCoreKit
  * [SMRRouter](#wiki-SMRRouter)
  * [SMRDB](#wiki-SMRDB)
  * [SMRNetwork](#wiki-SMRNetwork)
  * [SMRModel](#wiki-SMRModel)
  * [SMRDebug](#wiki-SMRDebug)
  * [SMRRanker](#wiki-SMRRanker)
  * [SMRLifecycle](#wiki-SMRLifecycle)
  * [SMRLayout](#wiki-SMRLayout)
  

* SMRUIKit
  * [SMRAdapter](#wiki-SMRAdapter)
  * [SMRNavigationView](#wiki-SMRNavigationView)
  * [SMRController](#wiki-SMRController)
  * [SMRImageCate](#wiki-SMRImageCate)
  * [SMRTableAssistant](#wiki-SMRTableAssistant)
  

* SMRUtilsKit
  * [SMRKeyChain](#wiki-SMRKeyChain)
  * [SMRPhoneInfo](#wiki-SMRPhoneInfo)
 
 
#
## <a id="wiki-SMRRouter"></a>SMRRouter
## <a id="wiki-SMRDB"></a>SMRDB
## <a id="wiki-SMRNetwork"></a>SMRNetwork
## <a id="wiki-SMRDebug"></a>SMRDebug
## <a id="wiki-SMRRanker"></a>SMRRanker
## <a id="wiki-SMRLifecycle"></a>SMRLifecycle
## <a id="wiki-SMRLayout"></a>SMRLayout
* 布局原理
  * 采用plist/xml文件布局
  * 可配置使用比例`"config" =     {
        use = s;
        iPhone5 = 1;
        iPhone6 = 1.2;
        iPhone6Plus = 1.5;
        iPhoneX = 1.7;
    };` s表示根据不同屏幕尺寸使用不同的比值
* 布局格式
  * `"backImage<UIImageView" =     {
        top = 105;
        left = 40;
        bottom = 20;
        right = 10;
        "setBackgroundColor:" = "#FF00FF";
    };`
  * `"deleteBtn<UIButton" =     {
        top = 100;
        left = 10;
        width = 30;
        height = 30;
        "setBackgroundColor:" = "#33FFEE";
    };`
#
## <a id="wiki-SMRAdapter"></a>SMRAdapter
## <a id="wiki-SMRNavigationView"></a>SMRNavigationView
## <a id="wiki-SMRController"></a>SMRController
## <a id="wiki-SMRImageCate"></a>SMRImageCate
## <a id="wiki-SMRTableAssistant"></a>SMRTableAssistant
#
## <a id="wiki-SMRKeyChain"></a>SMRKeyChain
## <a id="wiki-SMRPhoneInfo"></a>SMRPhoneInfo


#
## ThirdLib Used
#### SMRCoreKit.SMRNetwork
  * s.dependency 'AFNetworking', '3.2.1'
  * s.dependency 'YYCache', '1.0.4'
#### SMRCoreKit.SMRDataBase
  * s.dependency 'FMDB', '2.7.2'
#### SMRCoreKit.SMRDataBase/SMRModel
  * s.dependency 'YYModel', '1.0.4'
#### SMRCoreKit.SMRDebug
  * s.dependency 'FLEX', '2.4.0'
#### SMRCoreKit.SMRLayout/SMRUIKit.SMRNavigationView
  * s.dependency 'PureLayout', '3.1.4'
  * s.dependency 'SDWebImage', '4.4.3'
#### SMRUIKit.SMRController
  * s.dependency 'MJRefresh', '3.1.15.7'
  * s.dependency 'IQKeyboardManager', '~> 3.3.7'
#### SMRUtilsKit.SMRUtils
  * s.dependency 'YYText', '1.0.7'
  * s.dependency 'MBProgressHUD', '1.1.0'
####
  * s.dependency 'CocoaSecurity', '1.2.4'
