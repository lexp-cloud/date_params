# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'date_params/version'

Gem::Specification.new do |spec|
  spec.name          = 'date_params'
  spec.version       = DateParams::VERSION
  spec.authors       = ['Bogdan Rada', 'Jason Rust']
  spec.email         = ['bogdan@lessonplanet.com']
  spec.description   = 'Dates passed in by date-pickers or text-input fields to a rails controller need to be converted to a ruby Date to be able to be saved and manipulated.  This gem provides a simple controller add-on to facilitate the conversion.'
  spec.summary       = 'Convert date string parameters in a rails controller into Date objects.'
  spec.homepage      = 'https://github.com/lexp-cloud/date_params'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.licenses = ['MIT']
  spec.required_ruby_version = '>= 2.2'

  spec.add_dependency 'activesupport'
  spec.add_dependency 'tzinfo'

  spec.add_development_dependency 'appraisal', '~> 2.1', '>= 2.1'
  spec.add_development_dependency 'pry-byebug'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec-rails', '~> 3.5', '>= 3.5'
  spec.add_development_dependency 'test-unit', '~> 3.0'
end
