# Uncomment this line to define a global platform for your project
platform :ios, '9.0'
# Uncomment this line if you're using Swift
use_frameworks!

target 'WWDCast' do
  pod 'google-cast-sdk', '~> 3.1.1'
  pod 'RxCocoa', '~> 3.6.1'
  pod 'RxDataSources', '~> 2.0.2'
  pod 'SwiftyJSON', '~> 3.1'
  pod 'SDWebImage', '~> 3.8'

    target 'WWDCastTests' do
        inherit! :search_paths
    end

end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '3.0'
            config.build_settings['SWIFT_SUPPRESS_WARNINGS'] = 'YES'
        end
    end
end
