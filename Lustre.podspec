Pod::Spec.new do |s|
  s.name         = "Lustre"
  s.version      = "0.7"
  s.summary      = "An imperfect but more performant Result pattern in Swift."
  s.description  = <<-DESC
                   An imperfect but more performant implementation of the Result
                   pattern in Swift.

                   The common-case implementation of `Result<T> is clearly the
                   future, but until Swift supports multi-payload generic enums,
                   Lustre mitigates the performance problems of a `Box<T>`
                   Result type.
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
