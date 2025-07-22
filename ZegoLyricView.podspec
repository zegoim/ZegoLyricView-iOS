#
# Be sure to run `pod lib lint ZegoLyricView.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'ZegoLyricView'
  s.version          = '0.1.1'
  s.summary          = 'A view to display krc lyrics.'

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Vic' => 'vicwan@zego.im' }
  s.ios.deployment_target = '9.0'
  s.homepage         = 'https://github.com/zegoim/ZegoLyricView-iOS'
  s.source           = { :git => 'git@github.com:zegoim/ZegoLyricView-iOS.git',
    :tag => s.version.to_s }
  s.source_files = 'ZegoLyricView/Classes/**/*'
  
end
