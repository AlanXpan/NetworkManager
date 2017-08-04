

Pod::Spec.new do |s|

  s.name         = "NetworkManager"
  s.version      = "1.2.1"
  s.summary      = "封装"
  s.description  = <<-DESC
                    NetWork封装
                   DESC
  s.homepage     = "https://github.com/AlanXpan/NetworkManager"
  s.license      = { :type => "MIT", :file => "FILE_LICENSE" }

  s.author             = { "" => "" }

  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/AlanXpan/NetworkManager.git", :tag => "#{s.version}" }
  s.source_files  = "NetworkManager/*"
  s.requires_arc = true

  s.dependency 'Alamofire', '~> 4.4'
  s.dependency 'SwiftyJSON'

end
