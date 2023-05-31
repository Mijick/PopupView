Pod::Spec.new do |s|
  s.name                  = 'PopupView'
  s.summary               = 'Beautiful and fully customisable popups in no time. Keep your SwiftUI code clean'
  s.description           = <<-DESC
  PopupView is a free and open-source library dedicated for SwiftUI that makes the process of presenting popups easier and much cleaner.
                               DESC
  
  s.version               = '1.6.0'
  s.ios.deployment_target = '15.0'
  s.swift_version         = '5.0'
  
  s.source_files          = 'Sources/PopupView/**/*'
  s.frameworks            = 'SwiftUI', 'Foundation', 'Combine'
  
  s.homepage              = 'https://github.com/Mijick/PopupView.git'
  s.license               = { :type => 'MIT', :file => 'LICENSE' }
  s.author                = { 'Tomasz Kurylik' => 'tomasz.kurylik@mijick.com' }
  s.source                = { :git => 'https://github.com/Mijick/PopupView.git', :tag => s.version.to_s, :branch => 'task/Cocoapods-Distribution' }
end
