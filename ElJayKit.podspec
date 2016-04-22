#
# Be sure to run `pod lib lint ElJayKit.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "ElJayKit"
  s.version          = "0.1.0"
  s.summary          = "A short description of ElJayKit."

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!  
  s.description      = <<-DESC
                       DESC

  s.homepage         = "https://github.com/ilg/ElJayKit"
  s.license          = 'MIT'
  s.author           = { "Isaac Greenspan" => "ilg@2718.us" }
  s.source           = { :git => "https://github.com/ilg/ElJayKit.git", :tag => s.version.to_s }

  # s.platform     = :ios, '8.0'
  s.requires_arc = true

  s.source_files = 'Pod/**/*'

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  s.dependency 'AlamofireXMLRPC', '~> 1.0'
  s.dependency 'MD5Digest'
end
