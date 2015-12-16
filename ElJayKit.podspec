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

  s.osx.platform      = :osx, '10.10'
  s.ios.platform      = :ios, '8.0'
  s.requires_arc = true

  s.source_files = 'Pod/**/*'

  s.dependency 'AlamofireXMLRPC', '~> 1.0'
  s.dependency 'MD5Digest'
end
