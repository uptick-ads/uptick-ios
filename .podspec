Pod::Spec.new do |s|
  s.name         = "UptickSDK"
  s.version      = "1.0.0"
  s.summary      = "Uptick SDK for publishers integrating ad solutions in iOS apps."
  s.description  = <<-DESC
    The Uptick SDK enables publishers to integrate ad solutions easily in their iOS apps, 
    supporting various ad formats and targeting options.
  DESC

  s.homepage     = "https://github.com/axeldeploy/uptick-ios"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = { "Uptick" => "contact@ppxdigital.com" }
  s.source       = { :git => "https://github.com/axeldeploy/uptick-ios", :tag => "#{s.version}" }
  s.ios.deployment_target = '15.0'
  s.source_files  = "Sources/**/*.{swift,h,m}"
  s.frameworks = 'UIKit', 'Foundation'
  s.swift_version = '5.0'  # Update to the Swift version used in the SDK
end