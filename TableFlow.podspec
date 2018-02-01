Pod::Spec.new do |s|
  s.name             = "TableFlow"
  s.version          = "1.0.1"
  s.summary          = "UITableView manager."

  s.homepage         = "https://github.com/Meniny/TableFlow"
  s.license          = { :type => "MIT", :file => "LICENSE.md" }
  s.author           = { "Meniny" => "Meniny@qq.com" }
  s.source           = { :git => "https://github.com/Meniny/TableFlow.git", :tag => s.version.to_s }
  s.social_media_url = 'https://meniny.cn/'
  s.swift_version    = "4.0"

  s.ios.deployment_target = '8.0'

  s.source_files     = 'TableFlow/**/*.swift'
  s.resources        = ["TableFlow/**/*.xib"]
  # s.public_header_files = 'UIRefresher/*{.h}'
  s.frameworks       = 'Foundation', 'UIKit'
end
