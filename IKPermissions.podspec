Pod::Spec.new do |spec|
  spec.name         = 'IKPermissions'
  spec.version      = '1.0.0'
  spec.license      = { :type => 'MIT' }
  spec.homepage     = 'https://github.com/iankeen/'
  spec.authors      = { 'Ian Keen' => 'iankeen82@gmail.com' }
  spec.summary      = 'Allows simple permission checking / requesting.'
  spec.source       = { :git => 'https://github.com/iankeen/ikpermissions.git', :tag => spec.version.to_s }

  spec.source_files = 'IKPermissions/**/**.{h,m}'
  
  spec.requires_arc = true
  spec.platform     = :ios
  spec.ios.deployment_target = "7.0"

  spec.dependency 'IKResults', '~> 1.0'
  spec.dependency 'IKCore', '~> 1.0'
end
