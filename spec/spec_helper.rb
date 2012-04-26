require 'rspec'
require './lib/shopsense.rb'
require 'yaml'
#require 'shopsense'

RSpec.configure do |config|
  config.color_enabled  = true
  config.formatter      = 'documentation'
end