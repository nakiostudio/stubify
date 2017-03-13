# coding: utf-8

lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "stubify/version"

Gem::Specification.new do |spec|
  spec.name          = "stubify"
  spec.version       = Stubify::VERSION
  spec.authors       = ["Carlos Vidal"]
  spec.email         = ["nakioparkour@gmail.com"]
  spec.summary       = Stubify::DESCRIPTION
  spec.description   = Stubify::DESCRIPTION
  spec.homepage      = "https://github.com/nakiostudio/stubify"
  spec.license       = "MIT"

  # Paths
  spec.files          = Dir["lib/**/*"] + %w(bin/stubify README.md LICENSE)
  spec.executables    = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths  = ["lib"]

  # Ruby
  spec.required_ruby_version = ">= 2.0.0"

  # Lib
  spec.add_dependency 'sinatra', '>= 1.4.8'
  spec.add_dependency 'commander', '>= 4.4.0', '< 5.0.0'
  spec.add_dependency 'terminal-table'

  # Development only
  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
end
