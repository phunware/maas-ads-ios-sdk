Pod::Spec.new do |s|
  s.name         = 'PWAds'
  s.version      = '4.0.4'
  s.summary      = "The Phunware Advertising SDK for iOS"
  s.homepage     = "http://phunware.github.io/maas-ads-ios-sdk/"
  s.author       = { 'Phunware, Inc.' => 'http://www.phunware.com' }
  s.social_media_url = 'https://twitter.com/Phunware'

  s.platform     = :ios, '10.1'
  s.source       = { :git => "https://github.com/phunware/maas-ads-ios-sdk.git", :tag => "v4.0.4" }
  s.license      = { :type => 'Copyright', :text => 'Copyright 2019 by Phunware Inc. All rights reserved.' }

  s.vendored_frameworks = 'Framework/Phunware.framework'
end
