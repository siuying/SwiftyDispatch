Pod::Spec.new do |s|
  s.name             = "SwiftyDispatch"
  s.version          = "0.2.1"
  s.summary          = "A lightweight GCD wrapper for Swift."
  s.homepage         = "https://github.com/siuying/SwiftyDispatch"
  s.license          = 'MIT'
  s.author           = { "Francis Chong" => "francis@ignition.hk" }
  s.source           = { :git => "https://github.com/siuying/SwiftyDispatch.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/siuying'

  s.ios.deployment_target = '8.0'
  s.osx.deployment_target = '10.10'

  s.requires_arc = true
  s.source_files = 'Classes/**/*.swift'
end
