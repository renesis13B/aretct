project 'Aretct.xcodeproj'

# Uncomment the next line to define a global platform for your project
platform :ios, '10.0'
 
def shared_pods
pod 'Firebase/Core', '6.1.0'
pod 'Firebase/Auth', '6.1.0'
pod 'Firebase/Firestore', '6.1.0'
pod 'Firebase/Storage', '6.1.0'
pod 'Firebase/Functions', '6.1.0'
pod 'IQKeyboardManagerSwift', '6.3.0'
pod 'Kingfisher', '~> 4.0'
end

target 'Aretct' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Aretct
  shared_pods
  pod 'Stripe', '15.0.1'

  target 'AretctTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'AretctUITests' do
    inherit! :search_paths
    # Pods for testing
  end

end

target 'AretctAdmin' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for AretctAdmin
  shared_pods

  target 'AretctAdminTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'AretctAdminUITests' do
    inherit! :search_paths
    # Pods for testing
  end

end
