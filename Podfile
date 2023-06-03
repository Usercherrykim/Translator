  platform :ios, '16.4'

target 'Translator' do
    use_frameworks!
    pod 'Alamofire', '5.2'
    pod 'SwiftyJSON'

post_install do |installer|
    installer.generated_projects.each do |project|
      project.targets.each do |target|
          target.build_configurations.each do |config|
              config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '11.0'
           end
      end
    end
  end
end
