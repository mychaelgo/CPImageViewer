Pod::Spec.new do |s|
  s.name             = "CPImageViewer"
  s.version          = "3.0.2"
  s.summary          = "Viewing a single image using transition animation."
  s.homepage         = "https://github.com/cp3hnu/CPImageViewer.git"
  s.license          = 'MIT'
  s.author           = { "Wei Zhao" => "cp3hnu@gmail.com" }
  s.source           = { :git => "https://github.com/cp3hnu/CPImageViewer.git", :tag => s.version }
  s.platform     = :ios, '8.0'
  s.requires_arc = true
  s.source_files = 'Classes/*.swift'
end
