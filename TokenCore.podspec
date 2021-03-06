Pod::Spec.new do |s|
  s.name          = "TokenCore"
  s.version       = "0.1"
  s.summary       = "Blockchain Library for imToken"
  
  s.description   = <<-DESC
  Token Core Library powering imToken iOS app.
  DESC
  
  s.homepage      = "https://token.im"
  s.license       = {
    type: "Apache License, Version 2.0",
    file: "LICENSE"
  }

  s.author        = { "James Chen" => "james@ashchan.com" }
  s.platform      = :ios, "9.0"

  s.source        = { :git => "https://github.com/ooozws/ios-token-core.git", :tag => "#{s.version}" }
  s.source_files  = "Sources/**/*.{h,m,swift}", "Vendor/**/*.{h,m,swift,c}"
  s.vendored_frameworks = 'Vendor/secp256k1/secp256k1.framework'
  s.preserve_path = "Modules/module.modulemap"
  s.xcconfig = { "SWIFT_INCLUDE_PATHS" => "$(PODS_ROOT)/TokenCore/Modules"}
  s.swift_version = "4.0"
  s.dependency "CryptoSwift", "1.3.0"
  s.dependency "BigInt", "5.2"
  s.dependency 'GRKOpenSSLFramework', '1.0.2.16'
end
