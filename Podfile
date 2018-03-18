project 'Places2.xcodeproj'

platform :ios, '11.2'

TARGET_NAME = 'Places2'

target TARGET_NAME do
  use_frameworks!

  # Pods for Places2
  pod 'Mapbox-iOS-SDK'
  pod 'Pulley'
  pod 'Dwifft'
  pod 'ReSwift'
  pod 'Reveal-SDK', :configurations => ['Debug']

  target TARGET_NAME + 'Tests' do
    inherit! :search_paths
    # Pods for testing
  end
  
  # Enable DEBUG flag in Swift
  post_install do |installer|
    installer.pods_project.targets.each do |target|
      if target.name == TARGET_NAME
        target.build_configurations.each do |config|
          config.build_settings['SWIFT_VERSION'] = '4.0'
        end
      end
    end
  end
end
