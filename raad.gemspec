# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'raad_totem/version'

Gem::Specification.new do |spec|
  spec.name          = 'raad_totem'
  spec.version       = RaadTotem::VERSION
  spec.authors       = ['Colin Surprenant', 'Chad Remesch']
  spec.email         = ['colin.surprenant@gmail.com', 'chad@remesch.com']
  spec.summary       = %q{Easily create daemons in Totem projects (fork of Raad gem)}
  spec.description   = %q{Easily create daemons in Totem projects (fork of Raad gem)}
  spec.homepage      = 'https://github.com/chadrem/raad_totem'
  spec.license       = 'Apache'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency('totem', '>= 0.0.5')

  spec.add_development_dependency('bundler', '~> 1.5')
  spec.add_development_dependency('rake')
end
