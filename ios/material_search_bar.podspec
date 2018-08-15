#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#
Pod::Spec.new do |s|
  s.name             = 'material_search_bar'
  s.version          = '0.0.1'
  s.summary          = 'A materialistic and feature packed search bar with a Trie implementation for efficient autocorrect. Made by Christopher Gong and Ankush Vangari.'
  s.description      = <<-DESC
A materialistic and feature packed search bar with a Trie implementation for efficient autocorrect. Made by Christopher Gong and Ankush Vangari.
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'
  
  s.ios.deployment_target = '8.0'
end

