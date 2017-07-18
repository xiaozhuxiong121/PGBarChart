Pod::Spec.new do |s|
  s.name         = "PGBarChart"
  s.version      = "1.0.1"
  s.summary      = "一款非常简单灵活的柱状统计图。"
  s.homepage     = "https://github.com/xiaozhuxiong121/PGBarChart"
  s.license      = "MIT"
  s.author       = { "piggybear" => "piggybear_net@163.com" }
  s.platform     = :ios, "7.0"
  s.source       = { :git => "https://github.com/xiaozhuxiong121/PGBarChart.git", :tag => s.version }
  s.source_files = "PGBarChart", "PGBarChart/**/*.{h,m}"
  s.frameworks   = "UIKit"
  s.requires_arc = true
end
 
