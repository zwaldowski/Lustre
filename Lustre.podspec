Pod::Spec.new do |s|
  s.name         = "Lustre"
  s.version      = "0.9"
  s.summary      = "An alternative, protocol-based Result pattern for Swift."
  s.description  = <<-DESC
                   An alternative, protocol-based Result pattern for Swift.
                   DESC
  s.homepage     = "https://github.com/zwaldowski/Lustre"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author           = { "Zachary Waldowski" => "zach@waldowski.me" }
  s.social_media_url = "http://twitter.com/zwaldowski"
  s.ios.deployment_target = "8.0"
  s.osx.deployment_target = "10.9"
  s.source       = { :git => "https://github.com/zwaldowski/Lustre.git", :tag => "v#{s.version}" }
  s.source_files  = "Lustre/*.swift"
  s.requires_arc = true
end
