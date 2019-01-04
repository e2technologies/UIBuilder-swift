#
# Be sure to run `pod lib lint UIBuilder.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'UIBuilder'
  s.version          = '0.2.5'
  s.summary          = 'An iOS swift library intended to assist with programatically building complicated UI elements.'

  s.description      = <<-DESC
Provides low level constraint based building blocks to ease development of programatically generated
views.  Also includes stacking views that aid in more complex view creation.
                       DESC

  s.homepage         = 'https://github.com/e2technologies/UIBuilder-swift'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Eric Chapman' => 'chapman@e2tec.com' }
  s.source           = { :git => 'https://github.com/e2technologies/UIBuilder-swift.git', :tag => s.version.to_s }
  s.swift_version    = '4.0'

  s.ios.deployment_target = '8.0'

  s.source_files = 'UIBuilder/Classes/**/*'
end
