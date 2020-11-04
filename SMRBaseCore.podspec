Pod::Spec.new do |s|
    s.name         = 'SMRBaseCore'
    s.version      = '1.0.0'
    s.summary      = 'the base core of framework'
    s.authors      = { 'tinswin' => ''}
    s.homepage     = 'https://github.com/sghick/framework-SMRBaseCore'
    s.platform     = :ios
    s.ios.deployment_target = '9.0'
    s.requires_arc = true
    s.source       = { :git => 'git@github.com:sghick/framework-SMRBaseCore.git' }

    s.subspec 'SMRCommon' do |ss| 
        ss.source_files = 'SMRBaseCore/SMRCommon/SMRCommon.h'
        ss.subspec 'Foundation' do |sss| 
            sss.source_files = 'SMRBaseCore/SMRCommon/Foundation/**/*.{h,m,c,mm}'
        end
        ss.subspec 'UIKit' do |sss| 
            sss.source_files = 'SMRBaseCore/SMRCommon/UIKit/**/*.{h,m,c,mm}'
        end
    end

    s.subspec 'SMRCoreKit' do |ss| 
        ss.source_files = 'SMRBaseCore/SMRCoreKit/**/*.{h,m,c,mm}'
        ss.dependency 'SMRBaseCore/SMRCommon'
        #### SMRCoreKit.SMRNetwork
        ss.dependency 'AFNetworking', '4.0.1'
        ss.dependency 'YYCache', '1.0.4'
        #### SMRCoreKit.SMRDataBase
        ss.dependency 'FMDB', '2.7.2'
        #### SMRCoreKit.SMRDataBase/SMRModel
        ss.dependency 'YYModel', '1.0.4'
    end

    s.subspec 'SMRUIKit' do |ss| 
        ss.source_files = 'SMRBaseCore/SMRUIKit/**/*.{h,m,c,mm}'
        ss.resource     = 'SMRBaseCore/SMRUIKit/SMRUIKitBundle.bundle'
        ss.dependency 'SMRBaseCore/SMRCommon'
        ss.dependency 'SMRBaseCore/SMRCoreKit'
        #### SMRUIKit.SMRNavigationView
        ss.dependency 'PureLayout', '3.1.4'
        ss.dependency 'SDWebImage', '5.9.1'
        #### SMRUIKit.SMRController
        ss.dependency 'MJRefresh', '3.1.15.7'
        ss.dependency 'IQKeyboardManager', '~> 6.5.6'
        #### SMRUtilsKit.SMRUtils
        ss.dependency 'YYText', '1.0.7'
        ss.dependency 'MBProgressHUD', '1.1.0'
        ####
        ss.dependency 'YBImageBrowser', '3.0.6'
    end

    s.subspec 'SMRConfigs' do |ss| 
        ss.source_files = 'SMRBaseCore/SMRConfigs/**/*.{h,m,c,mm}'
        ss.dependency 'SMRBaseCore/SMRCommon'
        ss.dependency 'SMRBaseCore/SMRCoreKit'
        ss.dependency 'SMRBaseCore/SMRUIKit'
    end
    
end
