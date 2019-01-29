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
  * 可配置使用比例`<Config use=s iPhone5=1 iPhone6=1.2 iPhone7=1.2 default=1>`
* 布局格式
  * `<Class top=100 left=30 bottom=90 right=30>`
  * `<Class top=100 left=30 width=300 height=200>`
  * `<Class top=100s left=30s bottom=90s right=30s>` s表示根据不同屏幕尺寸使用不同的比值,这个比值应该在`<Config />`标签中配置
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
  * s.dependency 'MBProgressHUD', '1.1.0'
  * s.dependency 'IQKeyboardManager', '~> 3.3.7'
####
  * s.dependency 'CocoaSecurity', '1.2.4'
