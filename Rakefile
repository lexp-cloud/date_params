# encoding: utf-8
require 'rubygems'
require 'bundler/setup'
require 'bundler/gem_tasks'
require 'appraisal'
require 'rspec/core/rake_task'
require 'rake'

RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.rspec_opts = ['--backtrace '] if ENV['DEBUG']
  spec.verbose = true
end

desc 'Default: run the unit tests.'
task default: [:all]

desc 'Test the plugin under all supported Rails versions.'
task :all do |_t|
  if ENV['TRAVIS']
    if ENV['BUNDLE_GEMFILE'] =~ /gemfiles/
      exec ("BUNDLE_GEMFILE=#{ENV['BUNDLE_GEMFILE']} bundle install && BUNDLE_GEMFILE=#{ENV['BUNDLE_GEMFILE']} bundle exec rake spec")
    else
      exec('bundle exec appraisal install && bundle exec rake appraisal spec')
    end
  else
    exec('bundle exec appraisal install && bundle exec rake appraisal spec')
  end
end


