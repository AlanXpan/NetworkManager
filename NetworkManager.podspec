

Pod::Spec.new do |s|


  s.name         = "NetworkManager"
  s.version      = "1.1.2"
  s.summary      = "AL封装"
  s.homepage     = "https://github.com/AlanXpan/NetworkManager"

  s.license      = "MIT"

  s.author             = { "" => "" }


  s.platform     = :ios, '8.0'

  s.source       = { :git => "https://github.com/AlanXpan/NetworkManager.git", :tag => "#{s.version}" }



  s.source_files  = "NetworkManager/**/*"
  s.exclude_files = "NetworkManager/Exclude"





end
