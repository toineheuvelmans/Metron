Pod::Spec.new do |spec|
  spec.name             = 'Metron'
  spec.summary          = 'Gemeometry, simplified.'
  spec.description      = 'Metron is a comprehensive collection of geometric functions and types that extend the 2D geometric primitives provided by CoreGraphics.'
  spec.version          = '1.0.4'
  spec.source           = { :git => 'https://github.com/toineheuvelmans/Metron.git', :tag => spec.version.to_s }
  spec.license          = { :type => 'MIT', :file => 'LICENSE' }

  spec.author           = { 'Toine Heuvelmans' => 'toine@algorithmic.me' }
  spec.homepage         = 'https://github.com/toineheuvelmans/Metron'
  spec.social_media_url = 'https://twitter.com/toineheuvelmans'

  spec.swift_version    = '4.2'
  spec.platforms        = { :ios => "8.0", :osx => "10.9", :watchos => "2.0", :tvos => "9.0" }
  spec.source_files     = ['source/Metron/**/*.swift']
  spec.exclude_files    = ['source/Metron/Test/**/*']
end
