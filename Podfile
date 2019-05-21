source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '10.0'
use_frameworks!

target 'Chaps' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks

  # Pods for Chaps
  pod 'ForecastIO'
  pod 'Firebase/Auth'
  pod 'Firebase/Core'
  pod 'Firebase/Analytics'
  pod 'Firebase/Database'
  pod 'Firebase/Firestore'
	pod 'Firebase/Messaging'
	pod 'MessageKit'

  pod 'PromiseKit', '~> 6.8'
  pod 'SwiftLint', '~> 0.27'

  pod 'IQKeyboardManagerSwift'
  pod 'UnsplashSwift'

	post_install do |installer|
		installer.pods_project.targets.each do |target|
			if target.name == 'MessageKit'
				target.build_configurations.each do |config|
					config.build_settings['SWIFT_VERSION'] = '4.0'
				end
			end
		end
	end

  target 'ChapsTests' do
    inherit! :search_paths
    # Pods for testing
  end

end
