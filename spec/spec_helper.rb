# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path('../lib', __dir__)
require 'plagscan'

require 'webmock/rspec'
require 'tempfile'

require 'simplecov'
SimpleCov.start

RSpec.configure do |config|
  config.order = 'random'
end
