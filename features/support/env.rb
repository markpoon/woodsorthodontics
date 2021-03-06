# Generated by cucumber-sinatra. (2013-07-21 15:14:52 -0400)

ENV['RACK_ENV'] = 'test'

require File.join(File.dirname(__FILE__), '..', '..', './')

require 'capybara'
require 'capybara/cucumber'
require 'rspec'

Capybara.app = Application

class ApplicationWorld
  include Capybara::DSL
  include RSpec::Expectations
  include RSpec::Matchers
end

World do
  ApplicationWorld.new
end
