# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'plagscan/version'

Gem::Specification.new do |spec|
  spec.name        = 'plagscan'
  spec.version     = Plagscan::VERSION
  spec.authors     = ['Andrew Bromwich']
  spec.email       = ['abromwich@studiosity.com']

  spec.summary     = 'Ruby gem for PlagScan plagiarism APIs'
  spec.description = 'Ruby gem for PlagScan (https://www.plagscan.com/) plagiarism checking APIs'
  spec.homepage    = 'https://github.com/Studiosity/plagscan-ruby'
  spec.license     = 'MIT'
  spec.required_ruby_version = ['>= 2.5.0', '< 3.2.0']

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  unless spec.respond_to?(:metadata)
    raise 'RubyGems 2.0 or newer is required to protect against public gem pushes.'
  end

  spec.metadata['allowed_push_host'] = 'https://rubygems.org'
  spec.metadata['rubygems_mfa_required'] = 'true'

  spec.files = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 2.0'
  spec.add_development_dependency 'rake', '>= 12.3.3'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rubocop', '~> 1.28'
  spec.add_development_dependency 'rubocop-rake', '~> 0.6'
  spec.add_development_dependency 'rubocop-rspec', '~> 2.10'
  spec.add_development_dependency 'simplecov', '~> 0.17', '< 0.18'
  spec.add_development_dependency 'webmock', '~> 3.0'
end
