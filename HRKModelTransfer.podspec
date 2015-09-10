Pod::Spec.new do |s|
  s.name         = "HRKModelTransfer"
  s.version      = "0.0.1"
  s.summary      = "JSON to CoreData Transfer."
  s.homepage     = "https://github.com/hrk-ys/HRKModelTransfer"
  s.license      = "MIT"
  s.author             = { "hiroki.yoshifuji" => "hiroki.yoshifuji@gmail.com" }
  s.platform     = :ios, "7.0"
  s.source       = { :git => "https://github.com/hrk-ys/HRKModelTransfer", :tag => "0.0.1" }
  s.source_files  = "HRKModelTransfer/**/*.{h,m}"

  s.dependency "ActiveSupportInflector"
  s.dependency "MagicalRecord"
end
