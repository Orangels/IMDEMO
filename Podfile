platform :ios, '7.0'
use_frameworks!
target ‘talk2’ do
   
pod 'EaseMobSDKFull', :git => 'https://github.com/easemob/sdk-ios-cocoapods-integration.git' 
pod 'PinYin4Objc', '~> 1.1.1'
pod 'AMap2DMap' 
pod 'AMapSearch' 

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['ENABLE_BITCODE'] = 'NO'
    end
  end
end


end