
Pod::Spec.new do |s|

  s.name         = "NetworkManager.podpec"
  s.version      = "1.0.1"
  s.summary      = "A short description of NetworkManager.podpec."
  s.description  = <<-DESC
                   DESC
  s.homepage     = "http://EXAMPLE/NetworkManager.podpec"

  s.license      = "MIT (example)"
  s.author             = { "" => "" }
  s.source       = { :git => "http://EXAMPLE/NetworkManager.podpec.git", :tag => "#{s.version}" }

  s.source_files  = "Classes", "Classes/**/*.{h,m}"
  s.exclude_files = "Classes/Exclude"


end
