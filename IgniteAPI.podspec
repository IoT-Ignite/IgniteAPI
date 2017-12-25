Pod::Spec.new do |s|
  s.name             = 'IgniteAPI'
  s.version          = '0.9.7'
  s.summary          = 'A Swift wrapper library for IoT-Ignite REST API.'

  s.description      = <<-DESC
A Swift wrapper library for IoT-Ignite REST API. Written with Swift 4.0 for iOS Development using IoT-Ignite's cloud.
                       DESC

  s.homepage         = 'https://github.com/IoT-Ignite/IgniteAPI'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'Apache-2.0', :file => 'LICENSE' }
  s.author           = { 'Doruk Gezici' => 'doruk@gezici.me' }
  s.source           = { :git => 'https://github.com/IoT-Ignite/IgniteAPI.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/derektraveller'

  s.ios.deployment_target = '10.0'

  s.source_files = 'IgniteAPI/Classes/**/*'
  
  # s.resource_bundles = {
  #   'IgniteAPI' => ['IgniteAPI/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  s.dependency 'Alamofire'
  s.dependency 'SwiftyJSON'
end
