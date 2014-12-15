Pod::Spec.new do |s|
    s.name         = "AGSTimeProfile"
    s.version      = "1.0"
    s.summary      = "Measure how much time different blocks of code takes to execute"
    s.homepage     = "https://github.com/hfossli/AGSTimeProfile"
    s.license      = 'MIT'
    s.platform     = :ios, '5.0'
    s.requires_arc = true
    s.authors      = {
    	"Håvard Fossli" => "hfossli@gmail.com",
    	}
    s.source       = {
      :git => "https://github.com/hfossli/AGSTimeProfile.git",
      :tag => s.version.to_s
      }
    s.frameworks    = 'Foundation', 'QuartzCore'
    s.source_files  = 'Source/**/*.{h,m}'
end
