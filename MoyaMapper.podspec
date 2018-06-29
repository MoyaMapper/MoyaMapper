Pod::Spec.new do |s|
  s.name             = 'MoyaMapper'
  s.version          = '0.1.1'
  s.summary          = '基于Moya+SwiftyJSON，使解析Response更加方便'


  s.description      = <<-DESC
MoyaMapper可以更加方便的解析Response，提供RxSwift拓展
                       DESC

  s.homepage         = 'https://github.com/LinXunFeng/MoyaMapper'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'LinXunFeng' => '598600855@qq.com' }
  s.source           = { :git => 'https://github.com/LinXunFeng/MoyaMapper.git', :tag => s.version.to_s }

  s.ios.deployment_target = '9.0'
#s.source_files = 'MoyaMapper/Classes/**/*'

  s.default_subspec = "Core"

  s.subspec "Core" do |ss|
    ss.source_files  = "MoyaMapper/Classes/Core"
    ss.dependency "Moya", ">= 11.0.0"
    ss.dependency "SwiftyJSON"
  end

  s.subspec "Rx" do |ss|
    ss.source_files = "MoyaMapper/Classes/Rx"
    ss.dependency "MoyaMapper/Core"
    ss.dependency "Moya/RxSwift", ">= 11.0.0"
    ss.dependency "RxSwift"
  end

end
