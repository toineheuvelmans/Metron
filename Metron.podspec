Pod::Spec.new do |s|
  s.name             = 'Metron'
  s.version          = '1.0.1'
  s.swift_version    = '4.2'
  s.summary          = 'Gemeometry, simplified.'

  s.description      = <<-DESC
Metron is a comprehensive collection of geometric functions and types that extend the 2D geometric primitives provided by CoreGraphics.
                       DESC

  s.homepage         = 'https://github.com/toineheuvelmans/Metron'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Toine Heuvelmans' => 'toine@algorithmic.me' }
  s.source           = { :git => 'https://github.com/toineheuvelmans/Metron.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/toineheuvelmans'

  s.platforms = { :ios => "8.0", :osx => "10.9", :watchos => "2.0", :tvos => "9.0" }

  s.source_files = ['Metron/Classes/**/*','Metron/Protocols/**/*']

end
