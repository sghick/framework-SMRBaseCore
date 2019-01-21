Pod::Spec.new do |s|
s.name         = 'SMRBaseCore'
s.version      = '1.0.0'
s.summary      = 'the base core of framework'
s.authors      = { 'tinswin' => 'https://github.com/sghick'}
s.homepage     = 'https://github.com/sghick/framework-SMRBaseCore'
s.platform     = :ios
s.ios.deployment_target = '9.0'
s.requires_arc = true
s.source       = { :git => 'git@github.com:sghick/framework-SMRBaseCore.git' }
s.source_files = 'SMRBaseCore/**/*.{h,m}'
s.resource     = 'SMRBaseCore/SMRUIKit/SMRUIKitBundle.bundle'

#### SMRCoreKit.SMRNetwork
s.dependency 'AFNetworking', '3.2.1'
s.dependency 'YYCache', '1.0.4'
#### SMRCoreKit.SMRDataBase
s.dependency 'FMDB', '2.7.2'
#### SMRCoreKit.SMRDataBase/SMRModel
s.dependency 'YYModel', '1.0.4'
#### SMRCoreKit.SMRDebug
s.dependency 'FLEX', '2.4.0'
#### SMRUIKit.SMRNavigationView
s.dependency 'PureLayout', '3.1.4'
s.dependency 'SDWebImage', '4.4.3'
s.dependency 'MJRefresh', '3.1.15.7'


end
