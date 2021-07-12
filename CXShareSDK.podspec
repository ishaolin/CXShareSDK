#
# Be sure to run `pod lib lint CXShareSDK.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do | s |
    s.name             = 'CXShareSDK'
    s.version          = '1.0'
    s.summary          = 'CXShareSDK'
    
    # This description is used to generate tags and improve search results.
    #   * Think: What does it do? Why did you write it? What is the focus?
    #   * Try to keep it short, snappy and to the point.
    #   * Write the description between the DESC delimiters below.
    #   * Finally, don't worry about the indent, CocoaPods strips it!
    
    s.description      = 'CXShareSDK'
    
    s.homepage         = 'https://github.com/ishaolin/CXShareSDK'
    s.license          = { :type => 'MIT', :file => 'LICENSE' }
    s.author           = { 'wshaolin' => 'ishaolin@163.com' }
    s.source           = { :git => 'https://github.com/ishaolin/CXShareSDK.git', :tag => s.version.to_s }
    
    s.ios.deployment_target = '9.0'
    s.static_framework = true
    
    s.resource_bundles = {
      'CXShareSDK' => ['CXShareSDK/Assets/*.png']
    }
    
    s.vendored_libraries = [
      'CXShareSDK/ThirdLib/Libs/**/*.a'
    ]
    
    s.vendored_frameworks = [
      'CXShareSDK/ThirdLib/Frameworks/**/*.framework'
    ]
    
    s.resources = [
      'CXShareSDK/ThirdLib/Resources/**/*.bundle'
    ]
    
    s.frameworks = [
      'ImageIO',
      'QuartzCore',
      'CoreText',
      'CoreGraphics',
      'CoreTelephony',
      'Security',
      'SystemConfiguration'
    ]
    
    s.libraries = [
      'z',
      'c++',
      'sqlite3',
      'iconv'
    ]
    
    s.public_header_files = [
      'CXShareSDK/Classes/**/*.h',
      'CXShareSDK/ThirdLib/Headers/**/*.h'
    ]
    
    s.source_files = [
      'CXShareSDK/Classes/**/*',
      'CXShareSDK/ThirdLib/Headers/**/*.h'
    ]
    
    s.dependency 'WechatOpenSDK', '1.8.7.1'
    s.dependency 'CXUIKit'
end
