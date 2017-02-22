
Pod::Spec.new do |s|
  # pod 库名
  s.name             = 'SYNetwork'
  # pod 版本
  s.version          = "2.5.2"
  # pod 概述 
  s.summary          = 'A grest network frameworks.'
  # pod的详细描述
  s.description      = <<-DESC
    ’this is A great network frameworks with one beautiful logger'
                       DESC
  # pod 的主页
  s.homepage         = 'https://github.com/CepheusSun/SYNetwork'
  # 许可证书
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  # 作者信息
  s.author           = { 'CepheusSun' => 'cd_sunyang@163.com' }
  # pod 源码在 GitHub 的仓库地址,以及 pod 版本
  s.source           = { :git => 'https://github.com/CepheusSun/SYNetwork.git', :tag => s.version }
  # pod 支持 iOS 系统
  s.ios.deployment_target = '8.0'

  s.source_files = 'SYNetwork/Classes/*'

  # s.public_header_files = 'SYNetwork/Classes/SYNetwork.h'
  # s.frameworks = 'UIKit', 'MapKit'
  s.dependency 'AFNetworking', '~> 3.0'
end
