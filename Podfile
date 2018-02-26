# Uncomment this line to define a global platform for your project
# platform :ios, '9.0'

workspace 'hh-ios'
source 'https://github.com/CocoaPods/Specs.git'


target 'hh-ios' do
  # Uncomment this line if you're using Swift or would like to use dynamic frameworks
  # use_frameworks!

  # Pods for hh-ios
  pod 'Unirest', '~> 1.1.4'
  pod 'AWSMobileClient', '~> 2.6.6'  # For AWSMobileClient
  pod 'AWSS3', '~> 2.6.6'            # For file transfers
  pod 'AWSCognito', '~> 2.6.6'       # For data sync

  target 'hh-iosTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'hh-iosUITests' do
    inherit! :search_paths
    # Pods for testing
  end

end
