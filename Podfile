# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'MageNative Shopify App' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for MageNative Shopify App

  pod "Mobile-Buy-SDK"
  pod 'Firebase/Core'
  pod 'Firebase/InAppMessaging'
  pod 'Alamofire'
  pod 'IQKeyboardManagerSwift', '6.5.6'
  pod 'FSPagerView'
  pod 'DropDown'
  pod "TTGSnackbar"
  pod 'SWRevealViewController'
  pod "RATreeView"
  pod 'ListPlaceholder'
  pod 'SDWebImage'
  pod 'DZNEmptyDataSet'
  pod 'SwiftyJSON'
  pod 'Firebase/Crashlytics'
  pod 'Firebase/Database', :inhibit_warnings => true
  pod 'Firebase/Auth', :inhibit_warnings => true
  pod 'GoogleMLKit/BarcodeScanning'
  pod 'GoogleMLKit/ImageLabelingCustom'
  pod 'GoogleMLKit/LinkFirebase'
  pod 'GoogleMLKit/ImageLabeling'
  pod 'Firebase/Messaging'
  pod 'Firebase/Analytics'
  pod 'RxSwift'
  pod 'RxCocoa'
  pod 'EzPopup'
  pod 'Cosmos'
  pod 'FBSDKCoreKit'
  pod "Popover"
  pod 'youtube-ios-player-helper'
  pod 'FSCalendar'
  pod 'ZendeskChatSDK'
  pod 'RealmSwift'
  pod "TTRangeSlider"
  pod 'CryptoSwift', '~> 1.4.1'
  pod 'FBSDKLoginKit'
  pod 'GoogleSignIn'
  pod 'InstantSearch'
  pod 'BottomPopup'
  target 'MageNative Shopify AppTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'MageNative Shopify AppUITests' do
    # Pods for testing
  end

end

target 'Notifications' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Notifications

end

target 'NotificationViewController' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for NotificationViewController

end

def fix_config(config)
  # https://github.com/CocoaPods/CocoaPods/issues/8891
    config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '12.0'
  if config.build_settings['DEVELOPMENT_TEAM'].nil?
    config.build_settings['DEVELOPMENT_TEAM'] = '27TVM8QEM5'
  end
end

post_install do |installer|
  installer.generated_projects.each do |project|
    project.build_configurations.each do |config|
        fix_config(config)
    end
    project.targets.each do |target|
      target.build_configurations.each do |config|
        fix_config(config)
      end
    end
  end
end
