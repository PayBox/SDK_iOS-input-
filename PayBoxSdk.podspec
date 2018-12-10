
Pod::Spec.new do |s|

 

  s.name         = "PayBoxSdk"
  s.version      = "1.0.3"
  s.summary      = "PayBoxSdk"
  s.description  = "test"
  s.homepage     = "http://paybox.money"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.pod_target_xcconfig = {'SWIFT_INCLUDE_PATHS' => '$(SRCROOT)/PayBoxSdk/PayBoxSdk/commonCrypto/**','LIBRARY_SEARCH_PATHS' => '$(SRCROOT)/PayBoxSdk/PayBoxSdk/'}
  s.author             = { "Arman" => "am@paybox.money" }
  s.public_header_files = 'PayBoxSdk/*.h'
  s.preserve_paths = 'PayBoxSdk/commonCrypto/module.modulemap'
  s.ios.deployment_target = '10.0'
  s.tvos.deployment_target = '9.0'
  s.watchos.deployment_target = '2.0'
  s.osx.deployment_target = '10.9'
  s.requires_arc = true
  s.source       = { :git => "https://github.com/PayBox/SDK_iOS-input-.git", :tag => "#{s.version}" }
  s.source_files  = 'PayBoxSdk/*.{swift,h}', 'PayBoxSdk/commonCrypto/*.{c,h}'
  s.libraries = 'z'
  
end
