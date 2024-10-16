Pod::Spec.new do |s|
  s.name                  = 'MijickPopups'
  s.summary               = 'Popups, popovers, sheets, alerts, toasts, banners, (...) presentation made simple. Written with and for SwiftUI.'
  s.description           = <<-DESC
  MijickPopups is a free and open-source library dedicated for SwiftUI that makes the process of presenting popups easier and much cleaner.
                               DESC
  
  s.version               = '3.0.0'
  s.ios.deployment_target = '14.0'
  s.osx.deployment_target = '13.0'
  s.swift_version         = '6.0'
  
  s.source_files          = 'Sources/**/*'
  s.frameworks            = 'SwiftUI', 'Foundation', 'Combine'
  
  s.homepage              = 'https://github.com/Mijick/Popups.git'
  s.license               = { :type => 'Apache License 2.0', :file => 'LICENSE' }
  s.author                = { 'Tomasz Kurylik from Mijick' => 'tomasz.kurylik@mijick.com' }
  s.source                = { :git => 'https://github.com/Mijick/Popups.git', :tag => s.version.to_s }
end
