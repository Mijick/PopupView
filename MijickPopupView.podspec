Pod::Spec.new do |s|
  s.name                  = 'MijickPopupView'
  s.summary               = 'Popups presentation made simple'
  s.description           = <<-DESC
  PopupView is a free and open-source library dedicated for SwiftUI that makes the process of presenting popups easier and much cleaner.
                               DESC
  
  s.version               = '3.0.0'
  s.ios.deployment_target = '14.0'
  s.osx.deployment_target = '13.0'
  s.swift_version         = '5.0'
  
  s.source_files          = 'Sources/**/*'
  s.frameworks            = 'SwiftUI', 'Foundation', 'Combine'
  
  s.homepage              = 'https://github.com/Mijick/PopupView.git'
  s.license               = { :type => 'MIT', :file => 'LICENSE' }
  s.author                = { 'Tomasz Kurylik' => 'tomasz.kurylik@mijick.com' }
  s.source                = { :git => 'https://github.com/Mijick/PopupView.git', :tag => s.version.to_s }
end
