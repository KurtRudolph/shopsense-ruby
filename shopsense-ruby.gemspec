# -*- encoding: utf-8 -*-
$LOAD_PATH.push File.expand_path('../lib', __FILE__)
require 'shopsense/version'

Gem::Specification.new do |s|
  s.name        = 'shopsense-ruby'
  s.version     = Shopsense::VERSION
  s.authors     = ['Kurt Rudolph']
  s.email       = ['kurt@rudycomputing.io']

  s.summary     = 'ShopSense API! For Ruby! So Great.'
  s.description = 'This Gem provides an easy to use interface for the ShopStyleAPI commonly known as ShopSense. ShopSense-Ruby includes a set of convent classes and methods designed to make accessing the ShopStyle API from your Ruby application seamless.'
  s.homepage    = 'http://rudycomputing.github.io/shopsense-ruby'

  s.license     = 'MIT'
  s.required_ruby_version = '>= 1.8.7'

  s.requirements << 'An internet connection'

  s.add_dependency 'yajl-ruby'
  

  s.files = Dir.glob 'lib/**/*.rb'
  
  s.add_development_dependency 'rspec', '~> 2.8'
  s.test_files = Dir.glob '{spec, test}/**/*.rb'

  s.add_development_dependency 'rdoc', '~> 3.2'
  s.test_files= Dir.glob '{rdoc, doc}/**/*.rb'
end
