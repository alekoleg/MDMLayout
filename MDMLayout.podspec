Pod::Spec.new do |s|
  s.name         = "MDMLayout"
  s.version      = "0.0.16"
  s.summary      = "Custom layout view controller"
  s.description  = "Custom layout view controller. Which can add view to hierarchy and remove from that animated"
  s.homepage     = "https://github.com/alekoleg/MDMLayout.git"
  s.license      = 'MIT'
  s.author       = { "Oleg Alekseenko" => "alekoleg@gmail.com" }
  s.source       = { :git => "https://github.com/alekoleg/MDMLayout.git", :tag => s.version.to_s}
  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'Classes/*.{h,m}'
  s.public_header_files = 'Classes/*.h'
  s.frameworks = 'Foundation', 'UIKit'
  s.dependency 'ViewUtils', '~> 1.1.2'

end
