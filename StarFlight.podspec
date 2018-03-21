#
# Be sure to run `pod lib lint StarFlight.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'StarFlight'
  s.version          = '0.2.0'
  s.summary          = 'StarFlight is a library that gives you the integration with StarFlight Push Notification service.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = 'This CocoaPod provides the ability to integrate StarFlight Push Notification API to your application and to use StarFlight services developed by Starcut Finland Oy'
  s.homepage         = 'https://github.com/StarcutFinland/StarFlight'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Starcut' => 'Starcut Finland Oy' }
  s.source           = { :git => 'https://github.com/StarcutFinland/StarFlight.git', :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'

  s.source_files = 'StarFlight/Classes/**/*'

  # s.resource_bundles = {
  #   'StarFlight' => ['StarFlight/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
