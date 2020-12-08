#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint flutter_ddshare.podspec' to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'flutter_ddshare'
  s.version          = '0.0.1'
  s.summary          = 'A ddshare flutter plugin project.'
  s.description      = <<-DESC
A new flutter plugin project.
                       DESC
  s.homepage         = 'https://github.com/Konoha-orz/flutter_ddshare'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Konoha' => '517136675@qq.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'
  s.platform = :ios, '8.0'
  # include project framework

  #资源导入
  s.vendored_frameworks = '**/*.framework'
  # include project .a
  s.vendored_libraries = '**/*.a'
  # ios system framework
  s.frameworks = [

  ]
  # ios system library
  s.libraries = [

  ]
  # resources
  s.resources = '*.framework/*.bundle'

  # Flutter.framework does not contain a i386 slice. Only x86_64 simulators are supported.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'VALID_ARCHS[sdk=iphonesimulator*]' => 'x86_64' }
end
