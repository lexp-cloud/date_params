require 'rubygems'
require 'bundler/setup'

ENV['RAILS_ENV'] = 'test'

require 'pry-byebug'
require File.expand_path('../dummy/config/environment.rb', __FILE__)
require 'rspec/rails'
require 'date_params'

RSpec.configure do |config|
  require 'rspec/expectations'
  config.include RSpec::Matchers

  config.infer_spec_type_from_file_location!
  config.infer_base_class_for_anonymous_controllers = false
end
